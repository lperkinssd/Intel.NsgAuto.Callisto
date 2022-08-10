using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Data;
using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Callisto.Business.Entities.MATs.Workflows;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using Intel.NsgAuto.Shared.Mail;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class MATVersionsDataContext : IMATVersionsDataContext
    {
        public MATVersion Get(string userId, int id)
        {
            var versions = getAll(userId, id: id);
            if (versions.Count > 0) return versions[0];
            return null;
        }

        public MATVersions GetAll(string userId, bool? isActive = null)
        {
            return getAll(userId, isActive: isActive);
        }

        public IdAndNames GetAllIdAndNamesOnly(string userId, bool? isActive = null)
        {
            return getAllIdAndNamesOnly(userId, isActive: isActive);
        }

        public MATs GetMATs(string userId, int versionId)
        {
            return getMATs(userId, versionId: versionId, includeAttributes: true);
        }

        //public MATVersion GetVersionDetails(string userId, int versionId)
        //{
        //    return getVersionDetails(userId, versionId);
        //}

        public MATReviewResponse GetReviewSteps(int versionId, string userId)
        {
            return getReviewSteps(versionId, userId);
        }

        public MATVersion GetMATVersionDetails(int versionId, string userId)
        {
            MATVersion result = null;
            ISqlDataAccess dataAccess = null;
            try
            {

                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMATVERSIONDETAILS);
                dataAccess.AddInputParameter("@VersionId", versionId);
                dataAccess.AddInputParameter("@UserId", userId);
                IDataReader reader = dataAccess.ExecuteReader();
                result = getMATVersionDetails(result, dataAccess, reader);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private MATVersion getMATVersionDetails(MATVersion result, ISqlDataAccess dataAccess, IDataReader reader)
        {
            if (reader.Read())
            {
                result = new MATVersion()
                {
                    Id = reader["VersionId"].ToIntegerSafely(),
                    Version = reader["VersionNumber"].ToIntegerSafely(),
                    IsActive = reader["IsActive"].ToStringSafely().ToBooleanSafely(),
                    IsPOR = reader["IsPOR"].ToStringSafely().ToBooleanSafely(),
                    Status = new IdAndName()
                    {
                        Id = reader["StatusId"].ToIntegerSafely(),
                        Name = reader["Status"].ToStringSafely()
                    },
                    CreatedBy = reader["CreatedBy"].ToStringSafely(),
                    CreatedOn = reader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                    UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
                };
                result.MATRecords = new MATs();
                reader.NextResult();
                while (reader.Read())
                {
                    result.MATRecords.Add(
                        new MAT()
                        {
                            Id = reader["Id"].ToIntegerSafely(),
                            MATSsdId = new IdAndName()
                            {
                                Id = reader["SsdNameId"].ToIntegerSafely(),
                                Name = reader["SsdId"].ToStringSafely()
                            },
                            MATDesignId = new IdAndName()
                            {
                                Id = reader["ProductId"].ToIntegerSafely(),
                                Name = reader["DesignId"].ToStringSafely()
                            },
                            Scode = reader["Scode"].ToStringSafely(),
                            MediaIPN = reader["MediaIPN"].ToStringSafely(),
                            MediaType = reader["MediaType"].ToStringSafely(),
                            DeviceName = reader["DeviceName"].ToStringSafely(),
                            CreatedBy = reader["CreatedBy"].ToStringSafely(),
                            CreatedOn = reader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                            UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                            UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                            Attributes = new MATAttributes()
                        }
                        );
                }

                // Read all MAT Attributes
                reader.NextResult();
                MATAttributes flatAttributes = new MATAttributes();
                while (reader.Read())
                {
                    flatAttributes.Add(
                        new MATAttribute()
                        {
                            Id = reader["Id"].ToIntegerSafely(),
                            MATId = reader["MATId"].ToIntegerSafely(),
                            Name = reader["Name"].ToStringSafely(),
                            NameDisplay = reader["NameDisplay"].ToStringSafely(),
                            Value = reader["Value"].ToStringSafely(),
                            Operator = reader["Operator"].ToStringSafely(),
                            DataType = reader["DataType"].ToStringSafely(),
                            CreatedBy = reader["CreatedBy"].ToStringSafely(),
                            CreatedOn = reader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                            UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                            UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                        }
                        );
                }
                // Now make the hierarchy for attributes
                MAT mat = null;
                foreach (MATAttribute attribute in flatAttributes)
                {
                    // Add the attribute entry to MAT based on MAT Id
                    mat = result.MATRecords.GetByMATId(attribute.MATId);
                    if (mat.IsNotNull())
                    {
                        mat.Attributes.Add(attribute);
                    }
                }

                result.Review = new MATReview();
                reader.NextResult();
                // Get the review records & build heirarchy - TODO
                result.Review = setupReviewStages(dataAccess);

            }

            return result;
        }

        // REVIEW SECTION CODE STARTS

        private MATReview setupReviewStages(ISqlDataAccess dataAccess)
        {
            MATReview mATReview = new MATReview();
            MATReviewStep step = null;
            MATReviewStep tmpStep = null;
            MATReviewGroupReviewer tmpGroupReviewer = null;

            //Read in the stages first, for each one create
            //a step and add the stage.
            MATReviewStage stage = null;
            while (dataAccess.DataReader.Read())
            {
                stage = new MATReviewStage()
                {
                    ReviewStageId = dataAccess.DataReader["ReviewStageId"].ToIntegerSafely(),
                    ParentStageId = dataAccess.DataReader["ParentId"].ToIntegerSafely(),
                    StageName = dataAccess.DataReader["StageName"].ToStringSafely(),
                    //DisplayName = dataAccess.DataReader["StageDisplayName"].ToStringSafely(),
                    IsNextInParallel = (bool)dataAccess.DataReader["IsNextInParallel"].ToNullableBooleanSafely(),
                    Sequence = dataAccess.DataReader["StageSequence"].ToIntegerSafely()
                };
                step = new MATReviewStep();
                step.ReviewStage = stage;
                mATReview.ReviewSteps.Add(step);
            };

            //Get the groups next
            //for each group, set its IsCheckListCompleted using the CheckList method param
            //and then find the step it belongs to, and add it.
            dataAccess.DataReader.NextResult();
            MATReviewGroup group = null;
            MATReviewGroupReviewer groupReviewer = null;
            while (dataAccess.DataReader.Read())
            {
                group = new MATReviewGroup()
                {
                    ReviewGroupId = dataAccess.DataReader["ReviewGroupId"].ToIntegerSafely(),
                    GroupName = dataAccess.DataReader["GroupName"].ToStringSafely(),
                    ReviewStageId = dataAccess.DataReader["ReviewStageId"].ToIntegerSafely()
                };

                //Indicate if the checklist have been completed.
                //First get the step, using the StageId
                tmpStep = (MATReviewStep) mATReview.ReviewSteps.GetStepByStageId(group.ReviewStageId);
                group.IsCheckListCompleted = true;

                //Create the MATReviewGroupReviewer and add the new group to it.
                //Then add the MATReviewGroupReviewer to its step
                //Find the step by the stage id
                groupReviewer = new MATReviewGroupReviewer();
                groupReviewer.ReviewGroup = group;
                tmpStep.ReviewGroupReviewers.Add(groupReviewer);
            };

            //Now get the reviewers
            //Find the step this review belongs to, then find the group in that step
            //then add the reviewer to the correct step/group
            dataAccess.DataReader.NextResult();
            MATReviewReviewer reviewer = null;
            while (dataAccess.DataReader.Read())
            {
                reviewer = new MATReviewReviewer()
                {
                    ReviewerId = dataAccess.DataReader["ReviewReviewerId"].ToIntegerSafely(),
                    ReviewStageId = dataAccess.DataReader["ReviewStageId"].ToIntegerSafely(),
                    ReviewGroupId = dataAccess.DataReader["ReviewGroupId"].ToIntegerSafely(),
                    Idsid = dataAccess.DataReader["Idsid"].ToStringSafely(),
                    Wwid = dataAccess.DataReader["wwid"].ToStringSafely(),
                    Employee = new Shared.DirectoryServices.Employee()
                    {
                        Name = dataAccess.DataReader["Name"].ToStringSafely(),
                        Idsid = dataAccess.DataReader["Idsid"].ToStringSafely(),
                        WWID = dataAccess.DataReader["wwid"].ToStringSafely(),
                        Email = dataAccess.DataReader["Email"].ToStringSafely(),
                    },
                };
                //Get the step, based on stage
                tmpStep = (MATReviewStep) mATReview.ReviewSteps.GetStepByStageId(reviewer.ReviewStageId);
                //Get the MATReviewGroupReviewer, based on the groupId
                tmpGroupReviewer = (MATReviewGroupReviewer) tmpStep.ReviewGroupReviewers.GetById(reviewer.ReviewGroupId);
                //Add the new MATReviewReviewer to the list of MATReviewReviewers
                tmpGroupReviewer.Reviewers.Add(reviewer);
            };

            //Now get the decisions
            //find the step this decision belongs to, the group and reviewer it belongs to
            //Then set the reviewers decision
            dataAccess.DataReader.NextResult();
            MATReviewDecision decision = null;
            while (dataAccess.DataReader.Read())
            {
                decision = new MATReviewDecision()
                {
                    ReviewStageId = dataAccess.DataReader["ReviewStageId"].ToIntegerSafely(),
                    ReviewGroupId = dataAccess.DataReader["ReviewGroupId"].ToIntegerSafely(),
                    ReviewerId = dataAccess.DataReader["ReviewReviewerId"].ToIntegerSafely(),
                    IsApproved = dataAccess.DataReader["IsApproved"].ToNullableBooleanSafely(),
                    Comment = dataAccess.DataReader["Comment"].ToStringSafely(),
                    ReviewedOn = dataAccess.DataReader["ReviewedOn"].ToDateTimeSafely()
                };
                //Get the step, based on stage
                tmpStep = (MATReviewStep) mATReview.ReviewSteps.GetStepByStageId(decision.ReviewStageId);
                //Get the MATReviewGroupReviewer, based on the groupId
                tmpGroupReviewer = (MATReviewGroupReviewer) tmpStep.ReviewGroupReviewers.GetById(decision.ReviewGroupId);
                //Get the Reviewer
                reviewer = (MATReviewReviewer) tmpGroupReviewer.Reviewers.GetById(decision.ReviewerId);
                switch (decision.IsApproved)
                {
                    case null: reviewer.ReviewStatus = ReviewStatus.Open; reviewer.ReviewStatusText = "open"; break;
                    case true: reviewer.ReviewStatus = ReviewStatus.Approved; reviewer.ReviewStatusText = "approved"; break;
                    case false: reviewer.ReviewStatus = ReviewStatus.Rejected; reviewer.ReviewStatusText = "rejected"; break;
                }
                reviewer.Comment = decision.Comment;
                reviewer.ReviewDate = decision.ReviewedOn;
            };

            //Set the Group Statuses
            setStatuses(mATReview);

            //go create the children
            mATReview.ReviewSteps = createSteps(0, mATReview.ReviewSteps);

            //Set which stage is the current stage.  the method returns
            //the status of the "current stage".  If its approved, then its the last stage and
            //the steps (entire mAT) is approved, so set IsCompleted to true.
            //This method also sets "parent" stages status, so the UI can do its thing.
            // firstStepFound = false;
            if (setCurrentStage(mATReview.ReviewSteps) == ReviewStatus.Approved)
                mATReview.IsCompleted = true;

            return mATReview;
        }

        private ReviewSteps createSteps(int parentId, ReviewSteps source)
        {
            ReviewSteps steps = new ReviewSteps();
            foreach (ReviewStep step in source)
            {
                if (step.ReviewStage.ParentStageId == parentId)
                {
                    steps.Add(new ReviewStep()
                    {
                        Status = step.Status,
                        StatusText = step.StatusText,
                        IsCurrentStage = step.IsCurrentStage,
                        ReviewStage = step.ReviewStage,
                        ReviewGroupReviewers = step.ReviewGroupReviewers,
                        ChildSteps = createSteps(step.ReviewStage.ReviewStageId, source)
                    });
                }
            }
            return steps;
        }


        // REVIEW SECTION CODE ENDS


        public MATVersionImportResponse Import(string userId, MATsImport records)
        {
            MATVersionImportResponse result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                result = new MATVersionImportResponse();
                result.ImportMessages = new ImportMessages();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_IMPORTMATS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddTableValueParameter("@Records", UserDefinedTypes.MATIMPORT, createTableImport(records));
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // Note: purposely did not wrap Read() and NextResult() calls in if blocks below -> want an exception to be thrown if they fail
                    // Messages (e.g. errors)
                    while (reader.Read())
                    {
                        ImportMessage message = newMessage(reader);
                        result.ImportMessages.Add(message);
                    }

                    //Version
                    reader.NextResult();
                    reader.Read();
                    result.Version = newVersion(reader);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public MATVersion Approve(string userId, ReviewDecision decision)
        {
            //return changeStatus(StoredProcedures.SP_UPDATEMATVERSIONAPPROVED, userId, id);

            MATVersion result = new MATVersion();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_APPROVEMATVERSION);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", decision.VersionId);
                dataAccess.AddInputParameter("@StageId", decision.ReviewStageId);
                dataAccess.AddInputParameter("@GroupId", decision.ReviewGroupId);
                dataAccess.AddInputParameter("@ReviewerId", decision.ReviewerId);
                dataAccess.AddInputParameter("@Comment", decision.Comment);
                IDataReader reader = dataAccess.ExecuteReader();
                result = getMATVersionDetails(result, dataAccess, reader);
                string stageName = "";
                string detailsURL = Settings.BaseUrl + "MATVersions/Details/";

                reader.NextResult();
                if (reader.Read())
                {
                    stageName = reader["StageName"].ToStringSafely();
                }

                reader.NextResult();
                sendTheSubmitterEmails(dataAccess, stageName, detailsURL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public MATVersion Cancel(string userId, int id)
        {
            //return changeStatus(StoredProcedures.SP_UPDATEMATVERSIONCANCELED, userId, id);

            MATVersion result = new MATVersion();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CANCELMATVERSION);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@UserId", userId);
                IDataReader reader = dataAccess.ExecuteReader();
                result = getCancelVersionDetails(result, reader);
                string stageName = "";
                string detailsURL = Settings.BaseUrl + "MATVersions/Details/";

                reader.NextResult();
                if (reader.Read())
                {
                    stageName = reader["StageName"].ToStringSafely();
                }

                reader.NextResult();
                sendTheSubmitterEmails(dataAccess, stageName, detailsURL);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public MATVersion Reject(string userId, ReviewDecision decision)
        {
            //return changeStatus(StoredProcedures.SP_UPDATEMATVERSIONREJECTED, userId, id);

            MATVersion result = new MATVersion();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_REJECTMATVERSION);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", decision.VersionId);
                dataAccess.AddInputParameter("@StageId", decision.ReviewStageId);
                dataAccess.AddInputParameter("@GroupId", decision.ReviewGroupId);
                dataAccess.AddInputParameter("@ReviewerId", decision.ReviewerId);
                dataAccess.AddInputParameter("@Comment", decision.Comment);
                IDataReader reader = dataAccess.ExecuteReader();
                result = getMATVersionDetails(result, dataAccess, reader);
                string stageName = "";
                string detailsURL = Settings.BaseUrl + "MATVersions/Details/";

                reader.NextResult();
                if (reader.Read())
                {
                    stageName = reader["StageName"].ToStringSafely();
                }

                reader.NextResult();
                sendTheSubmitterEmails(dataAccess, stageName, detailsURL);

                reader.NextResult();
                sendTheReviewerEmails(dataAccess, stageName, detailsURL);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public MATVersion Submit(string userId, int id)
        {
            //if (!createSnapshots(id, StoredProcedures.SP_CREATEMATSNAPSHOTS))
            //{
            //    return Get(userId, id);
            //}
            //return changeStatus(StoredProcedures.SP_UPDATEMATVERSIONSUBMITTED, userId, id);

            MATVersion result = new MATVersion();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_SUBMITMATVERSION);                
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@UserId", userId);
                IDataReader reader = dataAccess.ExecuteReader();
                result = getMATVersionDetails(result, dataAccess, reader);
                string stageName = "";
                string detailsURL = Settings.BaseUrl + "MATVersions/Details/";

                reader.NextResult();
                if (reader.Read())
                {
                    stageName = reader["StageName"].ToStringSafely();
                }

                reader.NextResult();
                sendTheSubmitterEmails(dataAccess, stageName, detailsURL);

                reader.NextResult();
                sendTheReviewerEmails(dataAccess, stageName, detailsURL);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;

        }

        // Multipurpose function that can optionally filter results based on optional parameters
        // If the corresponding parameter is null, no filter will occur
        // Any that are populated will filter results
        // Examples:
        // get(userId, id: 10);                 --> where Id = 10
        // get(userId, id: 10, isActive: true); --> where Id = 10 and IsActive = 1
        private MATVersions getAll(string userId, int? id = null, bool? isActive = null, bool? isPOR = null)
        {
            MATVersions result = new MATVersions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMATVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@IsActive", isActive.NullToDBNull());
                dataAccess.AddInputParameter("@IsPOR", isPOR.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private IdAndNames getAllIdAndNamesOnly(string userId, int? id = null, bool? isActive = null)
        {
            IdAndNames result = new IdAndNames();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMATVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@IsActive", isActive.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newIdAndName(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private MATs getMATs(string userId, int? id = null, int? versionId = null, bool includeAttributes = false)
        {
            MATs results = new MATs();
            ISqlDataAccess dataAccess = null;
            try
            {
                MATAttributes attributes = new MATAttributes();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMATS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@VersionId", versionId.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeAttributes", includeAttributes);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add(newMAT(reader));
                    }
                    if (includeAttributes)
                    {
                        reader.NextResult();
                        while (reader.Read())
                        {
                            attributes.Add(newAttribute(reader));
                        }
                    }
                }
                foreach (MATAttribute attribute in attributes)
                {
                    MAT mat = results.Find(x => x.Id == attribute.MATId);
                    if (mat != null)
                    {
                        if (mat.Attributes == null) mat.Attributes = new MATAttributes();
                        mat.Attributes.Add(attribute);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return results;
        }

        private MATVersion getCancelVersionDetails(MATVersion result, IDataReader reader)
        {
            if (reader.Read())
            {
                result = new MATVersion()
                {
                    Id = reader["VersionId"].ToIntegerSafely(),
                    Version = reader["VersionNumber"].ToIntegerSafely(),
                    IsActive = reader["IsActive"].ToStringSafely().ToBooleanSafely(),
                    IsPOR = reader["IsPOR"].ToStringSafely().ToBooleanSafely(),
                    Status = new IdAndName()
                    {
                        Id = reader["StatusId"].ToIntegerSafely(),
                        Name = reader["Status"].ToStringSafely()
                    },
                    CreatedBy = reader["CreatedBy"].ToStringSafely(),
                    CreatedOn = reader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                    UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
                };
                result.MATRecords = new MATs();
                reader.NextResult();
                while (reader.Read())
                {
                    result.MATRecords.Add(
                        new MAT()
                        {
                            Id = reader["Id"].ToIntegerSafely(),
                            MATSsdId = new IdAndName()
                            {
                                Id = reader["SsdNameId"].ToIntegerSafely(),
                                Name = reader["SsdId"].ToStringSafely()
                            },
                            MATDesignId = new IdAndName()
                            {
                                Id = reader["ProductId"].ToIntegerSafely(),
                                Name = reader["DesignId"].ToStringSafely()
                            },
                            Scode = reader["Scode"].ToStringSafely(),
                            MediaIPN = reader["MediaIPN"].ToStringSafely(),
                            MediaType = reader["MediaType"].ToStringSafely(),
                            DeviceName = reader["DeviceName"].ToStringSafely(),
                            CreatedBy = reader["CreatedBy"].ToStringSafely(),
                            CreatedOn = reader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                            UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                            UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                            Attributes = new MATAttributes()
                        }
                        );
                }

                // Read all MAT Attributes
                reader.NextResult();
                MATAttributes flatAttributes = new MATAttributes();
                while (reader.Read())
                {
                    flatAttributes.Add(
                        new MATAttribute()
                        {
                            Id = reader["Id"].ToIntegerSafely(),
                            MATId = reader["MATId"].ToIntegerSafely(),
                            Name = reader["Name"].ToStringSafely(),
                            NameDisplay = reader["NameDisplay"].ToStringSafely(),
                            Value = reader["Value"].ToStringSafely(),
                            Operator = reader["Operator"].ToStringSafely(),
                            DataType = reader["DataType"].ToStringSafely(),
                            CreatedBy = reader["CreatedBy"].ToStringSafely(),
                            CreatedOn = reader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                            UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                            UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                        }
                        );
                }
                // Now make the hierarchy for attributes
                MAT mat = null;
                foreach (MATAttribute attribute in flatAttributes)
                {
                    // Add the attribute entry to MAT based on MAT Id
                    mat = result.MATRecords.GetByMATId(attribute.MATId);
                    if (mat.IsNotNull())
                    {
                        mat.Attributes.Add(attribute);
                    }
                }
            }

            return result;
        }

        //private MATVersion getVersionDetails(string userId, int id)
        //{
        //    MATVersion version = new MATVersion();
        //    MATs mats = new MATs();
        //    MATAttributes attributes = new MATAttributes();
        //    MATReviewResponse response = new MATReviewResponse();
        //    MATReview review = new MATReview();
        //    MATReviewStep step = null;
        //    MATReviewStep tmpStep = null;
        //    MATReviewGroupReviewer tmpGroupReviewer = null;
        //    response.Status = true;
        //    response.Messages = new MATReviewMessages();
        //    response.Review = null;

        //    ISqlDataAccess dataAccess = null;
        //    try
        //    {
        //        dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, "[qan].[GetMATVersionDetails]");
        //        dataAccess.AddInputParameter("@UserId", userId);
        //        dataAccess.AddInputParameter("@Id", id.NullToDBNull());
        //        using (IDataReader reader = dataAccess.ExecuteReader())
        //        {
        //            if (reader.Read())
        //            {
        //                version = newVersion(reader);
        //            }

        //            reader.NextResult();
        //            while (reader.Read())
        //            {
        //                mats.Add(newMAT(reader));
        //            }

        //            reader.NextResult();
        //            while (reader.Read())
        //            {
        //                attributes.Add(newAttribute(reader));
        //            }

        //            foreach (MATAttribute attribute in attributes)
        //            {
        //                MAT mat = mats.Find(x => x.Id == attribute.MATId);
        //                if (mat != null)
        //                {
        //                    if (mat.Attributes == null) mat.Attributes = new MATAttributes();
        //                    mat.Attributes.Add(attribute);
        //                }
        //            }

        //            MATReviewStage stage = null;
        //            while (reader.Read())
        //            {
        //                stage = new MATReviewStage()
        //                {
        //                    Id = reader["ReviewStageId"].ToIntegerSafely(),
        //                    StageName = reader["StageName"].ToStringSafely(),
        //                    DisplayName = reader["StageDisplayName"].ToStringSafely()
        //                };
        //                step = new MATReviewStep();
        //                step.ReviewStage = stage;
        //                review.ReviewSteps.Add(step);
        //            };

        //            //Get the groups next
        //            //for each group, set its IsCheckListCompleted using the CheckList method param
        //            //and then find the step it belongs to, and add it.
        //            reader.NextResult();
        //            MATReviewGroup group = null;
        //            MATReviewGroupReviewer groupReviewer = null;
        //            while (reader.Read())
        //            {
        //                group = new MATReviewGroup()
        //                {
        //                    Id = reader["ReviewGroupId"].ToIntegerSafely(),
        //                    GroupName = reader["GroupName"].ToStringSafely(),
        //                    DisplayName = reader["GroupDisplayName"].ToStringSafely(),
        //                    ReviewStageId = reader["ReviewStageId"].ToIntegerSafely()
        //                };

        //                //First get the step, using the StageId
        //                tmpStep = (MATReviewStep)review.ReviewSteps.GetStepByStageId(group.ReviewStageId);

        //                //Create the RequestReviewGroupReviewer and add the new group to it.
        //                //Then add the RequestReviewGroupReviewer to its step
        //                //Find the step by the stage id
        //                groupReviewer = new MATReviewGroupReviewer();
        //                groupReviewer.ReviewGroup = group;
        //                tmpStep.ReviewGroupReviewers.Add(groupReviewer);

        //            };

        //            //Now get the reviewers
        //            //Find the step this review belongs to, then find the group in that step
        //            //then add the reviewer to the correct step/group
        //            reader.NextResult();
        //            MATReviewReviewer reviewer = null;
        //            while (reader.Read())
        //            {
        //                reviewer = new MATReviewReviewer()
        //                {
        //                    Id = reader["ReviewReviewerId"].ToIntegerSafely(),
        //                    ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
        //                    ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
        //                    idsid = reader["Idsid"].ToStringSafely(),
        //                    wwid = reader["wwid"].ToStringSafely(),
        //                    Employee = new Shared.DirectoryServices.Employee()
        //                    {
        //                        Name = reader["Name"].ToStringSafely(),
        //                        Idsid = reader["Idsid"].ToStringSafely(),
        //                        WWID = reader["wwid"].ToStringSafely(),
        //                        Email = reader["Email"].ToStringSafely()
        //                    },
        //                };
        //                //Get the step, based on stage
        //                tmpStep = (MATReviewStep)review.ReviewSteps.GetStepByStageId(reviewer.ReviewStageId);
        //                //Get the ReviewGroupReviewer, based on the groupId
        //                //tmpGroupReviewer = tmpStep.ReviewGroupReviewers
        //                tmpGroupReviewer = (MATReviewGroupReviewer)tmpStep.ReviewGroupReviewers.GetById(reviewer.ReviewGroupId);
        //                //Add the new RequestReviewReviewer to the list of RequestReviewReviewers
        //                tmpGroupReviewer.ReviewReviewers.Add(reviewer);
        //            };

        //            //Now get the decisions
        //            //find the step this decision belongs to, the group and reviewer it belongs to
        //            //Then set the reviewers decision
        //            reader.NextResult();
        //            MATReviewDecision decision = null;
        //            while (reader.Read())
        //            {
        //                decision = new MATReviewDecision()
        //                {
        //                    ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
        //                    ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
        //                    ReviewReviewerId = reader["ReviewReviewerId"].ToIntegerSafely(),
        //                    IsApproved = reader["IsApproved"].ToNullableBooleanSafely(),
        //                    Comment = reader["Comment"].ToStringSafely(),
        //                    ReviewedOn = reader["ReviewedOn"].ToDateTimeSafely()
        //                };
        //                //Get the step, based on stage
        //                tmpStep = (MATReviewStep)review.ReviewSteps.GetStepByStageId(decision.ReviewStageId);
        //                //Get the RequestReviewGroupReviewer, based on the groupId
        //                tmpGroupReviewer = (MATReviewGroupReviewer)tmpStep.ReviewGroupReviewers.GetById(decision.ReviewGroupId);
        //                //Get the Reviewer
        //                reviewer = (MATReviewReviewer)tmpGroupReviewer.ReviewReviewers.GetById(decision.ReviewReviewerId);
        //                switch (decision.IsApproved)
        //                {
        //                    case null: reviewer.ReviewStatus = ReviewStatus.Open; reviewer.ReviewStatusText = "open"; break;
        //                    case true: reviewer.ReviewStatus = ReviewStatus.Approved; reviewer.ReviewStatusText = "approved"; break;
        //                    case false: reviewer.ReviewStatus = ReviewStatus.Rejected; reviewer.ReviewStatusText = "rejected"; break;
        //                }
        //                reviewer.Comment = decision.Comment;
        //                reviewer.ReviewDate = decision.ReviewedOn;
        //            };

        //            //Set the Group Statuses
        //            setStatuses(review);

        //            //go create the children
        //            //review.ReviewSteps = createSteps(0, requestReview.RequestReviewSteps);

        //            //Set which stage is the current stage.  the method returns
        //            //the status of the "current stage".  If its approved, then its the last stage and
        //            //the steps (entire request) is approved, so set IsCompleted to true.
        //            //This method also sets "parent" stages status, so the UI can do its thing.
        //            // firstStepFound = false;
        //            if (setCurrentStage(review.ReviewSteps) == ReviewStatus.Approved)
        //                review.IsCompleted = true;

        //            response.Review = review;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        dataAccess?.Close();
        //    }

        //    return version;
        //}

        private MATReviewResponse getReviewSteps(int versionId, string userId)
        {
            MATReviewResponse response = new MATReviewResponse();
            MATReview review = new MATReview();
            MATReviewStep step = null;
            MATReviewStep tmpStep = null;
            MATReviewGroupReviewer tmpGroupReviewer = null;
            response.Status = true;
            response.Messages = new MATReviewMessages();
            response.Review = null;

            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMATSTAGESANDREVIEWERS);
                dataAccess.AddInputParameter("@VersionId", versionId);
                //dataAccess.AddInputParameter("@UserId", userId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    //Read in the stages first, for each one create
                    //a step and add the stage.
                    MATReviewStage stage = null;
                    while (reader.Read())
                    {
                        stage = new MATReviewStage()
                        {
                            ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
                            StageName = reader["StageName"].ToStringSafely(),
                            DisplayName = reader["StageDisplayName"].ToStringSafely()
                        };
                        step = new MATReviewStep();
                        step.ReviewStage = stage;
                        review.ReviewSteps.Add(step);
                    };

                    //Get the groups next
                    //for each group, set its IsCheckListCompleted using the CheckList method param
                    //and then find the step it belongs to, and add it.
                    reader.NextResult();
                    MATReviewGroup group = null;
                    MATReviewGroupReviewer groupReviewer = null;
                    while (reader.Read())
                    {
                        group = new MATReviewGroup()
                        {
                            ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
                            GroupName = reader["GroupName"].ToStringSafely(),
                            DisplayName = reader["GroupDisplayName"].ToStringSafely(),
                            ReviewStageId = reader["ReviewStageId"].ToIntegerSafely()
                        };

                        //First get the step, using the StageId
                        tmpStep = (MATReviewStep)review.ReviewSteps.GetStepByStageId(group.ReviewStageId);

                        //Create the RequestReviewGroupReviewer and add the new group to it.
                        //Then add the RequestReviewGroupReviewer to its step
                        //Find the step by the stage id
                        groupReviewer = new MATReviewGroupReviewer();
                        groupReviewer.ReviewGroup = group;
                        tmpStep.ReviewGroupReviewers.Add(groupReviewer);

                    };

                    //Now get the reviewers
                    //Find the step this review belongs to, then find the group in that step
                    //then add the reviewer to the correct step/group
                    reader.NextResult();
                    MATReviewReviewer reviewer = null;
                    while (reader.Read())
                    {
                        reviewer = new MATReviewReviewer()
                        {
                            ReviewerId = reader["ReviewReviewerId"].ToIntegerSafely(),
                            ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
                            ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
                            Idsid = reader["Idsid"].ToStringSafely(),
                            Wwid = reader["wwid"].ToStringSafely(),
                            Employee = new Shared.DirectoryServices.Employee()
                            {
                                Name = reader["Name"].ToStringSafely(),
                                Idsid = reader["Idsid"].ToStringSafely(),
                                WWID = reader["wwid"].ToStringSafely(),
                                Email = reader["Email"].ToStringSafely()
                            },
                        };
                        //Get the step, based on stage
                        tmpStep = (MATReviewStep) review.ReviewSteps.GetStepByStageId(reviewer.ReviewStageId);
                        //Get the ReviewGroupReviewer, based on the groupId
                        //tmpGroupReviewer = tmpStep.ReviewGroupReviewers
                        tmpGroupReviewer = (MATReviewGroupReviewer)tmpStep.ReviewGroupReviewers.GetById(reviewer.ReviewGroupId);
                        //Add the new RequestReviewReviewer to the list of RequestReviewReviewers
                        tmpGroupReviewer.Reviewers.Add(reviewer);
                    };

                    //Now get the decisions
                    //find the step this decision belongs to, the group and reviewer it belongs to
                    //Then set the reviewers decision
                    reader.NextResult();
                    MATReviewDecision decision = null;
                    while (reader.Read())
                    {
                        decision = new MATReviewDecision()
                        {
                            ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
                            ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
                            ReviewerId = reader["ReviewReviewerId"].ToIntegerSafely(),
                            IsApproved = reader["ReviewReviewerId"].ToNullableBooleanSafely(),
                            Comment = reader["ReviewReviewerId"].ToStringSafely(),
                            ReviewedOn = reader["ReviewReviewerId"].ToDateTimeSafely()
                        };
                        //Get the step, based on stage
                        tmpStep = (MATReviewStep)review.ReviewSteps.GetStepByStageId(decision.ReviewStageId);
                        //Get the RequestReviewGroupReviewer, based on the groupId
                        tmpGroupReviewer = (MATReviewGroupReviewer)tmpStep.ReviewGroupReviewers.GetById(decision.ReviewGroupId);
                        //Get the Reviewer
                        reviewer = (MATReviewReviewer)tmpGroupReviewer.Reviewers.GetById(decision.ReviewerId);
                        switch (decision.IsApproved)
                        {
                            case null: reviewer.ReviewStatus = ReviewStatus.Open; reviewer.ReviewStatusText = "open"; break;
                            case true: reviewer.ReviewStatus = ReviewStatus.Approved; reviewer.ReviewStatusText = "approved"; break;
                            case false: reviewer.ReviewStatus = ReviewStatus.Rejected; reviewer.ReviewStatusText = "rejected"; break;
                        }
                        reviewer.Comment = decision.Comment;
                        reviewer.ReviewDate = decision.ReviewedOn;
                    };

                    //Set the Group Statuses
                    setStatuses(review);

                    //go create the children
                    //review.ReviewSteps = createSteps(0, requestReview.RequestReviewSteps);

                    //Set which stage is the current stage.  the method returns
                    //the status of the "current stage".  If its approved, then its the last stage and
                    //the steps (entire request) is approved, so set IsCompleted to true.
                    //This method also sets "parent" stages status, so the UI can do its thing.
                    // firstStepFound = false;
                    if (setCurrentStage(review.ReviewSteps) == ReviewStatus.Approved)
                        review.IsCompleted = true;

                    response.Review = review;
                    return response;
                }
            }
            catch (Exception ex)
            {
                response.Status = false;
                response.Messages.Add(new MATReviewMessage()
                {
                    Result = ex.Message
                });
            }
            finally
            {
                if (dataAccess.IsNotNull())
                {
                    dataAccess.Close();
                }
            }
            return response;

        }

        private void setStatuses(MATReview review)
        {
            int numGroups = 0;
            int numGroupApprovals = 0;
            int numGroupRejects = 0;
            foreach (ReviewStep step in review.ReviewSteps)
            {
                numGroups = step.ReviewGroupReviewers.Count;
                numGroupApprovals = 0;
                numGroupRejects = 0;

                foreach (ReviewGroupReviewer groupReviewer in step.ReviewGroupReviewers)
                {
                    int numReviewApproved = 0;
                    int numReviewRejected = 0;

                    //For the group to be "approved", Only ONE reviewer needs to approve
                    //For the group to be "rejected", only ONE reviewer needs to reject.
                    //Go through all of them, unless you see a reject, then can break out of loop
                    foreach (Reviewer reviewer in groupReviewer.Reviewers)
                    {
                        if (reviewer.ReviewStatus == ReviewStatus.Rejected)
                        {
                            numReviewRejected++;
                            break;
                        }
                        else if (reviewer.ReviewStatus == ReviewStatus.Approved)
                        {
                            numReviewApproved++;
                        }
                    }//Reviewers

                    //Reviewer statuses are counted, set the group status
                    if (numReviewRejected > 0)
                    {
                        //If anyone rejected, entire group is rejected
                        groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Rejected;
                        groupReviewer.ReviewGroup.ReviewStatusText = "rejected";
                        numGroupRejects++;
                    }
                    else if (numReviewApproved > 0)
                    {
                        //if no rejected, and at least one approval, group is approved
                        groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Approved;
                        groupReviewer.ReviewGroup.ReviewStatusText = "approved";
                        numGroupApprovals++;
                    }
                    else
                    {
                        //If no rejects or approvals its still open
                        groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Open;
                        groupReviewer.ReviewGroup.ReviewStatusText = "open";
                    }
                }//Groups

                //All groups have there status set, check the counts to set Step status
                //Parent Group with Children may not have any groups, account for that
                if (numGroups == numGroupApprovals && numGroups > 0)
                {
                    //If all groups approved, step is approved
                    step.Status = ReviewStatus.Approved;
                    step.StatusText = "approved";
                }
                else if (numGroupRejects > 0)
                {
                    //if any group rejected, step is rejected
                    step.Status = ReviewStatus.Rejected;
                    step.StatusText = "rejected";
                }
                else
                {
                    //otherwise step is still open
                    step.Status = ReviewStatus.Open;
                    step.StatusText = "open";
                }
            }//Steps
        }

        //private ReviewSteps createSteps(int parentId, ReviewSteps source)
        //{
        //    ReviewSteps steps = new ReviewSteps();
        //    foreach (ReviewStep step in source)
        //    {
        //        if (step.ReviewStage.ParentId == parentId)
        //        {
        //            steps.Add(new ReviewStep()
        //            {
        //                Status = step.Status,
        //                StatusText = step.StatusText,
        //                IsCurrentStage = step.IsCurrentStage,
        //                ReviewStage = step.ReviewStage,
        //                ReviewGroupReviewers = step.ReviewGroupReviewers,
        //                ChildSteps = createSteps(step.ReviewStage.Id, source)
        //            });
        //        }
        //    }
        //    return steps;
        //}

        /// <summary>
        /// Recursively loops throught the Steps, finding which one is the "current stage"
        /// Its the first one with a status of "reject" or "open", and any parallel stages.
        /// If none are found, then the steps are completed.
        /// </summary>
        /// <param name="steps">The steps to look through.</param>
        /// <returns>status of the current stage.  If value is ReviewStatus.Approved, then 
        /// the steps are all approved</returns>
        //bool isParentCurrentStage = false;
        public ReviewStatus setCurrentStage(ReviewSteps steps)
        {
            //1. First step (Step 1) is always open
            //2. If my previous step (say step 1) is approved, then I will be open to decisions
            //3. If my previous step (say step 1) told me to be open, I will be open to decisions.
            ReviewStatus reviewStatus = ReviewStatus.Open;
            bool isFirstStep;
            //bool hasChildren;
            bool isPreviousStepApproved = true;
            ReviewStep step = null;
            for (int index = 0; index < steps.Count; index++)
            {
                step = steps[index];
                // 1. First step is always open. So identify the first step.
                isFirstStep = (index == 0);
                if (isFirstStep)
                {
                    // child or parent, if it is the very first step & not yet approved, is open.
                    // 1. First step is always open. So identify the first step.                   
                    reviewStatus = step.Status;
                    step.StatusText = reviewStatus.ToString().ToLower();
                    step.IsCurrentStage = (step.Status != ReviewStatus.Approved);
                    isPreviousStepApproved = !step.IsCurrentStage;
                }
                else
                {
                    // if current step is approved, then it is not open
                    if (step.Status == ReviewStatus.Approved)
                    {
                        step.IsCurrentStage = false;
                        reviewStatus = step.Status;
                        step.StatusText = reviewStatus.ToString().ToLower();
                    }
                    else
                    {
                        // If the status is rejected
                        if (step.Status == ReviewStatus.Rejected)
                        {
                            reviewStatus = step.Status;
                            step.IsCurrentStage = true;
                            //break;
                        }
                        else
                        {
                            step.IsCurrentStage = false;
                            reviewStatus = step.Status;
                            step.StatusText = reviewStatus.ToString().ToLower();
                            // 2. If my previous step (say step 1) is approved, then I will be open to decisions
                            ReviewStep prevStep = steps[index - 1]; // since this is not first step, it won't go -ve
                            if (prevStep.IsNotNull())
                            {
                                isPreviousStepApproved = (prevStep.Status == ReviewStatus.Approved);
                                step.IsCurrentStage = isPreviousStepApproved;
                            }
                        }
                    }
                }
                // If there are children
                //hasChildren = (step.ChildSteps.IsNotNull() && step.ChildSteps.Count > 0);
                //if (hasChildren)
                //{
                //    // This step has children, so recurse with parent.
                //    // If all approved, returned review status will be approved.
                //    // In the recursion, if all steps are not approved, it will identify the current step(s)
                //    step.IsCurrentStage = isPreviousStepApproved;
                //    reviewStatus = setCurrentStage(step, step.ChildSteps);
                //    reviewStatus = getParentStatus(step.ChildSteps);
                //    step.Status = reviewStatus;
                //    step.StatusText = reviewStatus.ToString().ToLower();
                //    if (isPreviousStepApproved)
                //    {
                //        step.IsCurrentStage = (reviewStatus != ReviewStatus.Approved);
                //    }
                //}
            }

            return reviewStatus;
        }

        private MATVersion changeStatus(string changeStatusStoredProcedure, string userId, int id)
        {
            MATVersion result = new MATVersion();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, changeStatusStoredProcedure);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newVersion(reader);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private bool createSnapshots(int id, string storedProcedure)
        {
            bool retVal = true;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, storedProcedure);
                dataAccess.AddInputParameter("@VersionId", id);
                dataAccess.Execute();
            }
            catch (Exception ex)
            {
                retVal = false;
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }

            return retVal;
        }
        private DataTable createTableImport(MATsImport entities)
        {
            var table = createTableImport();
            foreach (var entity in entities)
            {
                var row = table.NewRow();
                populateRow(row, entity);
                table.Rows.Add(row);
            }
            table.AcceptChanges();
            return table;
        }

        private DataTable createTableImport()
        {
            var result = new DataTable();
            result.Columns.Add("RecordNumber", typeof(int));
            result.Columns.Add("SsdId", typeof(string));
            result.Columns.Add("DesignId", typeof(string));
            result.Columns.Add("Scode", typeof(string));
            result.Columns.Add("CellRevision", typeof(string));
            result.Columns.Add("MajorProbeProgramRevision", typeof(string));
            result.Columns.Add("ProbeRevision", typeof(string));
            result.Columns.Add("BurnTapeRevision", typeof(string));
            result.Columns.Add("CustomTestingReqd", typeof(string));
            result.Columns.Add("CustomTestingReqd2", typeof(string));
            result.Columns.Add("ProductGrade", typeof(string));
            result.Columns.Add("PrbConvId", typeof(string));
            result.Columns.Add("FabExcrId", typeof(string));
            result.Columns.Add("FabConvId", typeof(string));
            result.Columns.Add("ReticleWaveId", typeof(string));
            result.Columns.Add("MediaIPN", typeof(string));
            result.Columns.Add("FabFacility", typeof(string));
            result.Columns.Add("MediaType", typeof(string));
            result.Columns.Add("DeviceName", typeof(string));

            return result;
        }

        private void populateRow(DataRow row, MATImport entity)
        {
            row["RecordNumber"] = entity.RecordNumber;
            row["SsdId"] = entity.SsdId.NullToDBNull();
            row["DesignId"] = entity.DesignId.NullToDBNull();
            row["Scode"] = entity.Scode.NullToDBNull();
            row["CellRevision"] = entity.CellRevision.NullToDBNull();
            row["MajorProbeProgramRevision"] = entity.MajorProbeProgramRevision.NullToDBNull();
            row["ProbeRevision"] = entity.ProbeRevision.NullToDBNull();
            row["BurnTapeRevision"] = entity.BurnTapeRevision.NullToDBNull();
            row["CustomTestingReqd"] = entity.CustomTestingReqd.NullToDBNull();
            row["CustomTestingReqd2"] = entity.CustomTestingReqd2.NullToDBNull();
            row["ProductGrade"] = entity.ProductGrade.NullToDBNull();
            row["PrbConvId"] = entity.PrbConvId.NullToDBNull();
            row["FabExcrId"] = entity.FabExcrId.NullToDBNull();
            row["FabConvId"] = entity.FabConvId.NullToDBNull();
            row["ReticleWaveId"] = entity.ReticleWaveId.NullToDBNull();
            row["MediaIPN"] = entity.MediaIPN.NullToDBNull();
            row["FabFacility"] = entity.FabFacility.NullToDBNull();
            row["MediaType"] = entity.MediaType.NullToDBNull();
            row["DeviceName"] = entity.DeviceName.NullToDBNull();
        }

        private MAT newMAT(IDataRecord record)
        {
            return new MAT()
            {
                Id = record["Id"].ToIntegerSafely(),
                MATSsdId = new IdAndName()
                {
                    Id = record["SsdNameId"].ToIntegerSafely(),
                    Name = record["SsdId"].ToStringSafely()
                },
                MATDesignId = new IdAndName()
                {
                    Id = record["ProductId"].ToIntegerSafely(),
                    Name = record["DesignId"].ToStringSafely()
                },
                Scode = record["Scode"].ToStringSafely(),
                MediaIPN = record["MediaIPN"].ToStringSafely(),
                MediaType = record["MediaType"].ToStringSafely(),
                DeviceName = record["DeviceName"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private MATVersion newVersion(IDataRecord record)
        {
            return new MATVersion()
            {
                Id = record["Id"].ToIntegerSafely(),
                Version = record["VersionNumber"].ToIntegerSafely(),
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                IsPOR = record["IsPOR"].ToStringSafely().ToBooleanSafely(),
                Status = new IdAndName()
                {
                    Id = record["StatusId"].ToIntegerSafely(),
                    Name = record["Status"].ToStringSafely()
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private MATAttribute newAttribute(IDataRecord record)
        {
            return new MATAttribute()
            {
                Id = record["Id"].ToIntegerSafely(),
                MATId = record["MATId"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                NameDisplay = record["NameDisplay"].ToStringSafely(),
                Value = record["Value"].ToStringSafely(),
                Operator = record["Operator"].ToStringSafely(),
                DataType = record["DataType"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private ImportMessage newMessage(IDataRecord record)
        {
            return new ImportMessage()
            {
                RecordNumber = record["RecordNumber"].ToIntegerSafely(),
                FieldName = record["FieldName"].ToStringSafely(),
                MessageType = record["MessageType"].ToStringSafely(),
                Message = record["Message"].ToStringSafely(),
            };
        }

        private IdAndName newIdAndName(IDataRecord record)
        {
            return new IdAndName()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["VersionNumber"].ToStringSafely(),
            };
        }

        /// <summary>
        /// Send the Notification emails.  This method expects three result sets from the query.
        /// The first result set should always be there (its the requestor and templates)
        /// The second and third may not be there, and that's ok.  Depends on where in the 
        /// review cycle we are.  These results come from the StoredProcedures.SP_REVIEWREQUEST
        /// in ReviewRequest() and StoredProcedures.SP_SAVEREQUEST in SaveRequest();
        /// </summary>
        /// <param name="dataAccess">The result sets</param>
        /// <param name="stageName">The name of the stage, included in the email text.</param>
        /// <param name="reviewURL">The url to the details to review.</param>
        private void sendTheSubmitterEmails(ISqlDataAccess dataAccess, string stageName, string reviewURL)
        {
            string submitterEmail = "";
            string submitterName = "";
            //List<string> additionalRequestorEmails = new List<string>();
            ITemplate template = new Template();
            string templateData = "";
            string filledinTemplateData = "";
            string id = "";
            string emailSubject = "";

            //First get the requestor and the templates
            if (dataAccess.DataReader.Read())
            {
                id = dataAccess.DataReader["VersionId"].ToStringSafely();
                submitterEmail = dataAccess.DataReader["SubmitterEmail"].ToStringSafely();
                submitterName = dataAccess.DataReader["SubmitterName"].ToStringSafely();

                template.TemplateText = dataAccess.DataReader["Body"].ToStringSafely();
                templateData = dataAccess.DataReader["Data"].ToStringSafely();
                emailSubject = string.Format(dataAccess.DataReader["Subject"].ToStringSafely(), Settings.BaseUrl, reviewURL + id, stageName, getFirstName(submitterName), "MAT");
                filledinTemplateData = string.Format(templateData, Settings.BaseUrl, reviewURL + id, stageName, getFirstName(submitterName), "MAT version");
                sendEmail(template, filledinTemplateData, submitterEmail, emailSubject);
            }

            ////Now get the additional requestors
            //string additionalEmail = "";
            //string additionalName = "";
            //dataAccess.DataReader.NextResult();
            //while (dataAccess.DataReader.Read())
            //{
            //    requestId = dataAccess.DataReader["RequestId"].ToGuidSafely();
            //    additionalEmail = dataAccess.DataReader["AdditionalRequestorEmail"].ToStringSafely();
            //    additionalName = dataAccess.DataReader["AdditionalRequestorName"].ToStringSafely();
            //    filledinTemplateData = string.Format(templateData, getFirstName(additionalName), requestURL + requestId.ToString(), stageName);
            //    sendEmail(template, filledinTemplateData, additionalEmail, emailSubject);
            //}
        }

        /// <summary>
        /// Send the emails to the reviewers.
        /// </summary>
        /// <param name="dataAccess">The result sets</param>
        /// <param name="stageName">The name of the stage, included in the email text.</param>
        private void sendTheReviewerEmails(ISqlDataAccess dataAccess, string stageName, string reviewURL)
        {
            ITemplate template = new Template();
            string templateData = "";
            string filledinTemplateData = "";
            string id = "";
            string reviewerEmail = "";
            string reviewerName = "";
            string emailSubject = "";

            //Get the Reviewer Email Template
            if (dataAccess.DataReader.Read())
            {
                //DataTable dt = dataAccess.DataReader.GetSchemaTable();
                //id = dataAccess.DataReader["VersionId"].ToStringSafely();
                template.TemplateText = dataAccess.DataReader["Body"].ToStringSafely();
                templateData = dataAccess.DataReader["Data"].ToStringSafely();
                emailSubject = string.Format(dataAccess.DataReader["Subject"].ToStringSafely(), Settings.BaseUrl, reviewURL + id, stageName, getFirstName(reviewerName), "MAT");
            }

            //Now get the reviewers
            dataAccess.DataReader.NextResult();

            while (dataAccess.DataReader.Read())
            {
                id = dataAccess.DataReader["VersionId"].ToStringSafely();
                reviewerEmail = dataAccess.DataReader["ReviewerEmail"].ToStringSafely();
                reviewerName = dataAccess.DataReader["ReviewerName"].ToStringSafely();
                filledinTemplateData = string.Format(templateData, Settings.BaseUrl, reviewURL + id, stageName, getFirstName(reviewerName), "MAT version");
                sendEmail(template, filledinTemplateData, reviewerEmail, emailSubject);
            }
        }

        /// <summary>
        /// Get the first name from the full name.  Look for comma and use second item.
        /// Or just use full name, if no comma found.
        /// </summary>
        /// <param name="fullName">The employee.name field.</param>
        /// <returns></returns>
        private string getFirstName(string fullName)
        {
            string[] split;
            string name = "";

            if (fullName.Contains(",")) {
                split = fullName.Split(',');
                if (split.Length > 1)
                    name= split[1];
                else
                    name = split[0];
            }
            else if(fullName.Contains(" "))
            {
                split = fullName.Split(' ');
                name = split[0];
                if (name.Length == 0)
                    name = fullName;
            }
            else
            {
                name = fullName;
            }

            return name;
        }

        /// <summary>
        /// Send the actual email.  Use the specified (filled in) template and template data. 
        /// Send to the specified recipient, and use the subject.
        /// </summary>
        /// <param name="template">The notification template</param>
        /// <param name="templateData">The specific data for this email</param>
        /// <param name="emailAddr">the "TO:" email recipient</param>
        /// <param name="emailSubject">Subject line</param>
        private void sendEmail(ITemplate template, string templateData, string emailAddr, string emailSubject)
        {
            //If you want to limit who gets emails, then make sure to add an appSetting to the web.config
            //<add key="EMAILONLYLIST" value="tim.coppernoll@domain.com"/>
            //This will only send the emails to the value (ie, tim.copper...)
            //List<string> emailOnlyList = new List<string>(Settings.EmailOnlyList);
            List<string> emailOnlyList = null;
            if ((emailOnlyList == null) || (emailOnlyList[0].Equals("")) || (emailOnlyList.Contains(emailAddr)))
            {
                if (template.TemplateText.IsNeitherNullNorEmpty() && templateData.IsNeitherNullNorEmpty())
                {
                    Transformer transformer = new Transformer();
                    string body = transformer.Transform(template.TemplateText, templateData);

                    //Change email address to come from web.config 
                    bool status = new MailBuilder(Settings.SystemEmailAddress, emailAddr)
                        .UsingTemplateText(template.TemplateText)
                        .UsingSmtpServer(Settings.SmtpServer)
                        .Subject(emailSubject)
                        .Body(body)
                        .Send();
                }
            }
        }

    }
}
