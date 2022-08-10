using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ProductLabels;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using Intel.NsgAuto.Shared.Mail;
using System;
using System.Collections.Generic;
using System.Data;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class ProductLabelSetVersionsDataContext : IProductLabelSetVersionsDataContext
    {
        public ProductLabelSetVersion Get(string userId, int id)
        {
            var versions = getAll(userId, id: id);
            if (versions.Count > 0) return versions[0];
            return null;
        }

        public ProductLabelSetVersions GetAll(string userId, bool? isActive = null)
        {
            return getAll(userId, isActive: isActive);
        }

        public IdAndNames GetAllIdAndNamesOnly(string userId, bool? isActive = null)
        {
            return getAllIdAndNamesOnly(userId, isActive: isActive);
        }

        public ProductLabels GetProductLabels(string userId, int versionId)
        {
            return getProductLabels(userId, setVersionId: versionId, includeAttributes: true);
        }

        public ProductLabelSetVersion GetVersionDetails(string userId, int versionId)
        {
            return getVersionDetails(userId, setVersionId: versionId, includeAttributes: true);
        }

        public ProductLabelSetVersionImportResult Import(string userId, ProductLabelsImport records)
        {
            ProductLabelSetVersionImportResult result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                result = new ProductLabelSetVersionImportResult();
                result.ImportMessages = new ImportMessages();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_IMPORTPRODUCTLABELS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddTableValueParameter("@Records", UserDefinedTypes.PRODUCTLABELSIMPORT, createTableImport(records));
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // Note: purposely did not wrap Read() and NextResult() calls in if blocks below -> want an exception to be thrown if they fail
                    // Messages (e.g. errors)
                    while (reader.Read())
                    {
                        ImportMessage message = newMessage(reader);
                        result.ImportMessages.Add(message);
                    }

                    // Version
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

        public ProductLabelSetVersion Approve(string userId, int id)
        {
            return changeStatus(StoredProcedures.SP_UPDATEPRODUCTLABELSETVERSIONAPPROVED, userId, id);
        }

        public ProductLabelSetVersion Cancel(string userId, int id)
        {
            return changeStatus(StoredProcedures.SP_UPDATEPRODUCTLABELSETVERSIONCANCELED, userId, id);
        }

        public ProductLabelSetVersion Reject(string userId, int id)
        {
            return changeStatus(StoredProcedures.SP_UPDATEPRODUCTLABELSETVERSIONREJECTED, userId, id);
        }

        public ProductLabelSetVersion Submit(string userId, int id)
        {
            return changeStatus(StoredProcedures.SP_UPDATEPRODUCTLABELSETVERSIONSUBMITTED, userId, id);
        }

        // Multipurpose function that can optionally filter results based on optional parameters
        // If the corresponding parameter is null, no filter will occur
        // Any that are populated will filter results
        // Examples:
        // get(userId, id: 10);                 --> where Id = 10
        // get(userId, id: 10, isActive: true); --> where Id = 10 and IsActive = 1
        private ProductLabelSetVersions getAll(string userId, int? id = null, bool? isActive = null, bool? isPOR = null)
        {
            ProductLabelSetVersions result = new ProductLabelSetVersions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTLABELSETVERSIONS);
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
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTLABELSETVERSIONS);
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

        private ProductLabels getProductLabels(string userId, long? id = null, int? setVersionId = null, bool includeAttributes = false)
        {
            ProductLabels results = new ProductLabels();
            ISqlDataAccess dataAccess = null;
            try
            {
                ProductLabelAttributes attributes = new ProductLabelAttributes();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTLABELS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@SetVersionId", setVersionId.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeAttributes", includeAttributes);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add(newProductLabel(reader));
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
                foreach (ProductLabelAttribute attribute in attributes)
                {
                    ProductLabel label = results.Find(x => x.Id == attribute.ProductLabelId);
                    if (label != null)
                    {
                        if (label.Attributes == null) label.Attributes = new ProductLabelAttributes();
                        label.Attributes.Add(attribute);
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

        private ProductLabelSetVersion getVersionDetails(string userId, long? id = null, int? setVersionId = null, bool includeAttributes = false)
        {
            ProductLabelSetVersion version = new ProductLabelSetVersion();
            ProductLabels results = new ProductLabels();
            //ProductLabelReviewResponse response = new ProductLabelReviewResponse();
            //response.Status = true;
            //response.Messages = new ProductLabelReviewMessages();
            //response.Review = null;

            ISqlDataAccess dataAccess = null;
            try
            {
                ProductLabelAttributes attributes = new ProductLabelAttributes();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTLABELS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@SetVersionId", setVersionId.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeAttributes", includeAttributes);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add(newProductLabel(reader));
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
                foreach (ProductLabelAttribute attribute in attributes)
                {
                    ProductLabel label = results.Find(x => x.Id == attribute.ProductLabelId);
                    if (label != null)
                    {
                        if (label.Attributes == null) label.Attributes = new ProductLabelAttributes();
                        label.Attributes.Add(attribute);
                    }
                }

                //version.Review = setupReviewStages(reader);
                //TODO: Add response to version

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }

            return version;
        }

        //private ProductLabelReview setupReviewStages(IDataReader reader /*, RequestReviewCheckLists checkLists*/)
        //{
        //    ProductLabelReview review = new ProductLabelReview();
        //    ProductLabelReviewStep step = null;
        //    ProductLabelReviewStep tmpStep = null;
        //    ProductLabelReviewGroupReviewer tmpGroupReviewer = null;

        //    //Read in the stages first, for each one create
        //    //a step and add the stage.
        //    ProductLabelReviewStage stage = null;

        //    reader.NextResult();
        //    while (reader.Read())
        //    {
        //        stage = new ProductLabelReviewStage()
        //        {
        //            Id = reader["ReviewStageId"].ToIntegerSafely(),
        //            StageName = reader["StageName"].ToStringSafely(),
        //            DisplayName = reader["StageDisplayName"].ToStringSafely()
        //            //IsNextInParallel = (bool)dataAccess.DataReader["IsNextInParallel"].ToNullableBooleanSafely(),
        //            //StageSequence = dataAccess.DataReader["StageSequence"].ToIntegerSafely()
        //        };
        //        step = new ProductLabelReviewStep();
        //        step.ReviewStage = stage;
        //        review.ReviewSteps.Add(step);
        //    };

        //    //Get the groups next
        //    //for each group, set its IsCheckListCompleted using the CheckList method param
        //    //and then find the step it belongs to, and add it.
        //    reader.NextResult();
        //    ProductLabelReviewGroup group = null;
        //    ProductLabelReviewGroupReviewer groupReviewer = null;
        //    while (reader.Read())
        //    {
        //        group = new ProductLabelReviewGroup()
        //        {
        //            Id = reader["ReviewGroupId"].ToIntegerSafely(),
        //            GroupName = reader["GroupName"].ToStringSafely(),
        //            DisplayName = reader["GroupDisplayName"].ToStringSafely(),
        //            ReviewStageId = reader["ReviewStageId"].ToIntegerSafely()
        //        };

        //        //First get the step, using the StageId
        //        tmpStep = (ProductLabelReviewStep)review.ReviewSteps.GetStepByStageId(group.ReviewStageId);
        //        //group.IsCheckListCompleted = checkLists.GetByStageGroup(tmpStep.RequestReviewStage.StageName, group.GroupName);

        //        //Create the RequestReviewGroupReviewer and add the new group to it.
        //        //Then add the RequestReviewGroupReviewer to its step
        //        //Find the step by the stage id
        //        groupReviewer = new ProductLabelReviewGroupReviewer();
        //        groupReviewer.ReviewGroup = group;
        //        tmpStep.ReviewGroupReviewers.Add(groupReviewer);

        //    };

        //    //Now get the reviewers
        //    //Find the step this review belongs to, then find the group in that step
        //    //then add the reviewer to the correct step/group
        //    reader.NextResult();
        //    ProductLabelReviewReviewer reviewer = null;
        //    while (reader.Read())
        //    {
        //        reviewer = new ProductLabelReviewReviewer()
        //        {
        //            Id = reader["ReviewReviewerId"].ToIntegerSafely(),
        //            ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
        //            ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
        //            idsid = reader["Idsid"].ToStringSafely(),
        //            wwid = reader["wwid"].ToStringSafely(),
        //            Employee = new Shared.DirectoryServices.Employee()
        //            {
        //                Name = reader["Name"].ToStringSafely(),
        //                Idsid = reader["Idsid"].ToStringSafely(),
        //                WWID = reader["wwid"].ToStringSafely(),
        //                Email = reader["Email"].ToStringSafely()
        //            },
        //        };
        //        //Get the step, based on stage
        //        tmpStep = (ProductLabelReviewStep)review.ReviewSteps.GetStepByStageId(reviewer.ReviewStageId);
        //        //Get the ReviewGroupReviewer, based on the groupId
        //        //tmpGroupReviewer = tmpStep.ReviewGroupReviewers
        //        tmpGroupReviewer = (ProductLabelReviewGroupReviewer)tmpStep.ReviewGroupReviewers.GetById(reviewer.ReviewGroupId);
        //        //Add the new RequestReviewReviewer to the list of RequestReviewReviewers
        //        tmpGroupReviewer.ReviewReviewers.Add(reviewer);
        //    };

        //    //Now get the decisions
        //    //find the step this decision belongs to, the group and reviewer it belongs to
        //    //Then set the reviewers decision
        //    reader.NextResult();
        //    ProductLabelReviewDecision decision = null;
        //    while (reader.Read())
        //    {
        //        decision = new ProductLabelReviewDecision()
        //        {
        //            ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
        //            ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
        //            ReviewReviewerId = reader["ReviewReviewerId"].ToIntegerSafely(),
        //            IsApproved = reader["ReviewReviewerId"].ToNullableBooleanSafely(),
        //            Comment = reader["ReviewReviewerId"].ToStringSafely(),
        //            ReviewedOn = reader["ReviewReviewerId"].ToDateTimeSafely()
        //        };
        //        //Get the step, based on stage
        //        tmpStep = (ProductLabelReviewStep)review.ReviewSteps.GetStepByStageId(decision.ReviewStageId);
        //        //Get the RequestReviewGroupReviewer, based on the groupId
        //        tmpGroupReviewer = (ProductLabelReviewGroupReviewer)tmpStep.ReviewGroupReviewers.GetById(decision.ReviewGroupId);
        //        //Get the Reviewer
        //        reviewer = (ProductLabelReviewReviewer)tmpGroupReviewer.ReviewReviewers.GetById(decision.ReviewReviewerId);
        //        switch (decision.IsApproved)
        //        {
        //            case null: reviewer.ReviewStatus = ReviewStatus.Open; reviewer.ReviewStatusText = "open"; break;
        //            case true: reviewer.ReviewStatus = ReviewStatus.Approved; reviewer.ReviewStatusText = "approved"; break;
        //            case false: reviewer.ReviewStatus = ReviewStatus.Rejected; reviewer.ReviewStatusText = "rejected"; break;
        //        }
        //        reviewer.Comment = decision.Comment;
        //        reviewer.ReviewDate = decision.ReviewedOn;
        //    };

        //    //Set the Group Statuses
        //    setStatuses(review);

        //    //go create the children
        //    //review.ReviewSteps = createSteps(0, requestReview.RequestReviewSteps);

        //    //Set which stage is the current stage.  the method returns
        //    //the status of the "current stage".  If its approved, then its the last stage and
        //    //the steps (entire request) is approved, so set IsCompleted to true.
        //    //This method also sets "parent" stages status, so the UI can do its thing.
        //    // firstStepFound = false;
        //    if (setCurrentStage(review.ReviewSteps) == ReviewStatus.Approved)
        //        review.IsCompleted = true;

        //    return review;
        //}

        //private void setStatuses(ProductLabelSetVersionReview review)
        //{
        //    int numGroups = 0;
        //    int numGroupApprovals = 0;
        //    int numGroupRejects = 0;
        //    foreach (ReviewStep step in review.ReviewSteps)
        //    {
        //        numGroups = step.ReviewGroupReviewers.Count;
        //        numGroupApprovals = 0;
        //        numGroupRejects = 0;

        //        foreach (ReviewGroupReviewer groupReviewer in step.ReviewGroupReviewers)
        //        {
        //            int numReviewApproved = 0;
        //            int numReviewRejected = 0;

        //            //For the group to be "approved", Only ONE reviewer needs to approve
        //            //For the group to be "rejected", only ONE reviewer needs to reject.
        //            //Go through all of them, unless you see a reject, then can break out of loop
        //            foreach (ReviewReviewer reviewer in groupReviewer.ReviewReviewers)
        //            {
        //                if (reviewer.ReviewStatus == ReviewStatus.Rejected)
        //                {
        //                    numReviewRejected++;
        //                    break;
        //                }
        //                else if (reviewer.ReviewStatus == ReviewStatus.Approved)
        //                {
        //                    numReviewApproved++;
        //                }
        //            }//Reviewers

        //            //Reviewer statuses are counted, set the group status
        //            if (numReviewRejected > 0)
        //            {
        //                //If anyone rejected, entire group is rejected
        //                groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Rejected;
        //                groupReviewer.ReviewGroup.ReviewStatusText = "rejected";
        //                numGroupRejects++;
        //            }
        //            else if (numReviewApproved > 0)
        //            {
        //                //if no rejected, and at least one approval, group is approved
        //                groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Approved;
        //                groupReviewer.ReviewGroup.ReviewStatusText = "approved";
        //                numGroupApprovals++;
        //            }
        //            else
        //            {
        //                //If no rejects or approvals its still open
        //                groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Open;
        //                groupReviewer.ReviewGroup.ReviewStatusText = "open";
        //            }
        //        }//Groups

        //        //All groups have there status set, check the counts to set Step status
        //        //Parent Group with Children may not have any groups, account for that
        //        if (numGroups == numGroupApprovals && numGroups > 0)
        //        {
        //            //If all groups approved, step is approved
        //            step.Status = ReviewStatus.Approved;
        //            step.StatusText = "approved";
        //        }
        //        else if (numGroupRejects > 0)
        //        {
        //            //if any group rejected, step is rejected
        //            step.Status = ReviewStatus.Rejected;
        //            step.StatusText = "rejected";
        //        }
        //        else
        //        {
        //            //otherwise step is still open
        //            step.Status = ReviewStatus.Open;
        //            step.StatusText = "open";
        //        }
        //    }//Steps
        //}

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
        //bool isParentCurrentStage = false
        //public ReviewStatus setCurrentStage(ReviewSteps steps)
        //{
        //    //1. First step (Step 1) is always open
        //    //2. If my previous step (say step 1) is approved, then I will be open to decisions
        //    //3. If my previous step (say step 1) told me to be open, I will be open to decisions.
        //    ReviewStatus reviewStatus = ReviewStatus.Open;
        //    bool isFirstStep;
        //    //bool hasChildren;
        //    bool isPreviousStepApproved = true;
        //    ReviewStep step = null;
        //    for (int index = 0; index < steps.Count; index++)
        //    {
        //        step = steps[index];
        //        // 1. First step is always open. So identify the first step.
        //        isFirstStep = (index == 0);
        //        if (isFirstStep)
        //        {
        //            // child or parent, if it is the very first step & not yet approved, is open.
        //            // 1. First step is always open. So identify the first step.                   
        //            reviewStatus = step.Status;
        //            step.StatusText = reviewStatus.ToString().ToLower();
        //            step.IsCurrentStage = (step.Status != ReviewStatus.Approved);
        //            isPreviousStepApproved = !step.IsCurrentStage;
        //        }
        //        else
        //        {
        //            // if current step is approved, then it is not open
        //            if (step.Status == ReviewStatus.Approved)
        //            {
        //                step.IsCurrentStage = false;
        //                reviewStatus = step.Status;
        //                step.StatusText = reviewStatus.ToString().ToLower();
        //            }
        //            else
        //            {
        //                // If the status is rejected
        //                if (step.Status == ReviewStatus.Rejected)
        //                {
        //                    reviewStatus = step.Status;
        //                    step.IsCurrentStage = true;
        //                    //break;
        //                }
        //                else
        //                {
        //                    step.IsCurrentStage = false;
        //                    reviewStatus = step.Status;
        //                    step.StatusText = reviewStatus.ToString().ToLower();
        //                    // 2. If my previous step (say step 1) is approved, then I will be open to decisions
        //                    ReviewStep prevStep = steps[index - 1]; // since this is not first step, it won't go -ve
        //                    if (prevStep.IsNotNull())
        //                    {
        //                        isPreviousStepApproved = (prevStep.Status == ReviewStatus.Approved);
        //                        step.IsCurrentStage = isPreviousStepApproved;
        //                    }
        //                }
        //            }
        //        }
        //        // If there are children
        //        //hasChildren = (step.ChildSteps.IsNotNull() && step.ChildSteps.Count > 0);
        //        //if (hasChildren)
        //        //{
        //        //    // This step has children, so recurse with parent.
        //        //    // If all approved, returned review status will be approved.
        //        //    // In the recursion, if all steps are not approved, it will identify the current step(s)
        //        //    step.IsCurrentStage = isPreviousStepApproved;
        //        //    reviewStatus = setCurrentStage(step, step.ChildSteps);
        //        //    reviewStatus = getParentStatus(step.ChildSteps);
        //        //    step.Status = reviewStatus;
        //        //    step.StatusText = reviewStatus.ToString().ToLower();
        //        //    if (isPreviousStepApproved)
        //        //    {
        //        //        step.IsCurrentStage = (reviewStatus != ReviewStatus.Approved);
        //        //    }
        //        //}
        //    }

        //    return reviewStatus;
        //}

        private ProductLabelSetVersion changeStatus(string changeStatusStoredProcedure, string userId, int id)
        {
            ProductLabelSetVersion result = new ProductLabelSetVersion();
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

        private DataTable createTableImport(ProductLabelsImport entities)
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
            result.Columns.Add("ProductFamily", typeof(string));
            result.Columns.Add("Customer", typeof(string));
            result.Columns.Add("ProductionProductCode", typeof(string));
            result.Columns.Add("ProductFamilyNameSeries", typeof(string));
            result.Columns.Add("Capacity", typeof(string));
            result.Columns.Add("ModelString", typeof(string));
            result.Columns.Add("VoltageCurrent", typeof(string));
            result.Columns.Add("InterfaceSpeed", typeof(string));
            result.Columns.Add("OpalType", typeof(string));
            result.Columns.Add("KCCId", typeof(string));
            result.Columns.Add("CanadianStringClass", typeof(string));
            result.Columns.Add("DellPN", typeof(string));
            result.Columns.Add("DellPPIDRev", typeof(string));
            result.Columns.Add("DellEMCPN", typeof(string));
            result.Columns.Add("DellEMCPNRev", typeof(string));
            result.Columns.Add("HpePN", typeof(string));
            result.Columns.Add("HpeModelString", typeof(string));
            result.Columns.Add("HpeGPN", typeof(string));
            result.Columns.Add("HpeCTAssemblyCode", typeof(string));
            result.Columns.Add("HpeCTRev", typeof(string));
            result.Columns.Add("HpPN", typeof(string));
            result.Columns.Add("HpCTAssemblyCode", typeof(string));
            result.Columns.Add("HpCTRev", typeof(string));
            result.Columns.Add("LenovoFRU", typeof(string));
            result.Columns.Add("Lenovo8ScodePN", typeof(string));
            result.Columns.Add("Lenovo8ScodeBCH", typeof(string));
            result.Columns.Add("Lenovo11ScodePN", typeof(string));
            result.Columns.Add("Lenovo11ScodeRev", typeof(string));
            result.Columns.Add("Lenovo11ScodePN10", typeof(string));
            result.Columns.Add("OracleProductIdentifer", typeof(string));
            result.Columns.Add("OraclePN", typeof(string));
            result.Columns.Add("OraclePNRev", typeof(string));
            result.Columns.Add("OracleModel", typeof(string));
            result.Columns.Add("OraclePkgPN", typeof(string));
            result.Columns.Add("OracleMarketingPN", typeof(string));
            result.Columns.Add("CiscoPN", typeof(string));
            result.Columns.Add("FujistuCSL", typeof(string));
            result.Columns.Add("Fujitsu106PN", typeof(string));
            result.Columns.Add("HitachiModelName", typeof(string));

            return result;
        }

        private void populateRow(DataRow row, ProductLabelImport entity)
        {
            row["RecordNumber"] = entity.RecordNumber;
            row["ProductFamily"] = entity.ProductFamily.NullToDBNull();
            row["Customer"] = entity.Customer.NullToDBNull();
            row["ProductionProductCode"] = entity.ProductionProductCode.NullToDBNull();
            row["ProductFamilyNameSeries"] = entity.ProductFamilyNameSeries.NullToDBNull();
            row["Capacity"] = entity.Capacity.NullToDBNull();
            row["ModelString"] = entity.ModelString.NullToDBNull();
            row["VoltageCurrent"] = entity.VoltageCurrent.NullToDBNull();
            row["InterfaceSpeed"] = entity.InterfaceSpeed.NullToDBNull();
            row["OpalType"] = entity.OpalType.NullToDBNull();
            row["KCCId"] = entity.KCCId.NullToDBNull();
            row["CanadianStringClass"] = entity.CanadianStringClass.NullToDBNull();
            row["DellPN"] = entity.DellPN.NullToDBNull();
            row["DellPPIDRev"] = entity.DellPPIDRev.NullToDBNull();
            row["DellEMCPN"] = entity.DellEMCPN.NullToDBNull();
            row["DellEMCPNRev"] = entity.DellEMCPNRev.NullToDBNull();
            row["HpePN"] = entity.HpePN.NullToDBNull();
            row["HpeModelString"] = entity.HpeModelString.NullToDBNull();
            row["HpeGPN"] = entity.HpeGPN.NullToDBNull();
            row["HpeCTAssemblyCode"] = entity.HpeCTAssemblyCode.NullToDBNull();
            row["HpeCTRev"] = entity.HpeCTRev.NullToDBNull();
            row["HpPN"] = entity.HpPN.NullToDBNull();
            row["HpCTAssemblyCode"] = entity.HpCTAssemblyCode.NullToDBNull();
            row["HpCTRev"] = entity.HpCTRev.NullToDBNull();
            row["LenovoFRU"] = entity.LenovoFRU.NullToDBNull();
            row["Lenovo8ScodePN"] = entity.Lenovo8ScodePN.NullToDBNull();
            row["Lenovo8ScodeBCH"] = entity.Lenovo8ScodeBCH.NullToDBNull();
            row["Lenovo11ScodePN"] = entity.Lenovo11ScodePN.NullToDBNull();
            row["Lenovo11ScodeRev"] = entity.Lenovo11ScodeRev.NullToDBNull();
            row["Lenovo11ScodePN10"] = entity.Lenovo11ScodePN10.NullToDBNull();
            row["OracleProductIdentifer"] = entity.OracleProductIdentifer.NullToDBNull();
            row["OraclePN"] = entity.OraclePN.NullToDBNull();
            row["OraclePNRev"] = entity.OraclePNRev.NullToDBNull();
            row["OracleModel"] = entity.OracleModel.NullToDBNull();
            row["OraclePkgPN"] = entity.OraclePkgPN.NullToDBNull();
            row["OracleMarketingPN"] = entity.OracleMarketingPN.NullToDBNull();
            row["CiscoPN"] = entity.CiscoPN.NullToDBNull();
            row["FujistuCSL"] = entity.FujistuCSL.NullToDBNull();
            row["Fujitsu106PN"] = entity.Fujitsu106PN.NullToDBNull();
            row["HitachiModelName"] = entity.HitachiModelName.NullToDBNull();
        }

        internal static ProductLabel newProductLabel(IDataRecord record)
        {
            return new ProductLabel()
            {
                Id = record["Id"].ToLongSafely(),
                ProductionProductCode = record["ProductionProductCode"].ToStringSafely(),
                ProductFamily = new ProductFamily()
                {
                    Id = record["ProductFamilyId"].ToIntegerSafely(),
                    Name = record["ProductFamilyName"].ToStringSafely()
                },
                Customer = new Customer()
                {
                    Id = record["CustomerId"].ToIntegerSafely(),
                    Name = record["CustomerName"].ToStringSafely()
                },
                ProductFamilyNameSeries = new ProductFamilyNameSeries()
                {
                    Id = record["ProductFamilyNameSeriesId"].ToIntegerSafely(),
                    Name = record["ProductFamilyNameSeriesName"].ToStringSafely()
                },
                Capacity = record["Capacity"].ToStringSafely(),
                ModelString = record["ModelString"].ToStringSafely(),
                VoltageCurrent = record["VoltageCurrent"].ToStringSafely(),
                InterfaceSpeed = record["InterfaceSpeed"].ToStringSafely(),
                OpalType = new OpalType()
                {
                    Id = record["OpalTypeId"].ToIntegerSafely(),
                    Name = record["OpalTypeName"].ToStringSafely()
                },
                KCCId = record["KCCId"].ToStringSafely(),
                CanadianStringClass = record["CanadianStringClass"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private ProductLabelSetVersion newVersion(IDataRecord record)
        {
            return new ProductLabelSetVersion()
            {
                Id = record["Id"].ToIntegerSafely(),
                Version = record["Version"].ToIntegerSafely(),
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                IsPOR = record["IsPOR"].ToStringSafely().ToBooleanSafely(),
                Status = new Status()
                {
                    Id = record["StatusId"].ToIntegerSafely(),
                    Name = record["StatusName"].ToStringSafely(),
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        internal static ProductLabelAttribute newAttribute(IDataRecord record)
        {
            return new ProductLabelAttribute()
            {
                Id = record["Id"].ToLongSafely(),
                ProductLabelId = record["ProductLabelId"].ToLongSafely(),
                AttributeType = new ProductLabelAttributeType()
                {
                    Id = record["AttributeTypeId"].ToIntegerSafely(),
                    Name = record["AttributeTypeName"].ToStringSafely(),
                    NameDisplay = record["AttributeTypeNameDisplay"].ToStringSafely(),
                },
                Value = record["Value"].ToStringSafely(),
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
                RecordNumber = record["RecordNumber"].ToNullableIntSafely(),
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
                Name = record["Version"].ToStringSafely(),
            };
        }

        private ProductLabelSetVersion submit(string userId, int id)
        {
            ProductLabelSetVersion result = new ProductLabelSetVersion();
            //ProductLabelSetVersionReviewResponse response = new ProductLabelSetVersionReviewResponse();
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEPRODUCTLABELSETVERSIONSUBMITTED);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@VersionId", id);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {

                    if (reader.Read())
                    {
                        result = newVersion(reader);
                    }

                    string stageName = "";

                    reader.NextResult();
                    if (reader.Read())
                    {
                        stageName = reader["StageName"].ToStringSafely();
                    }

                    // Submitter email template
                    reader.NextResult();
                    sendTheSubmitterEmails(reader, stageName);

                    // Reviewers email template
                    reader.NextResult();
                    sendTheReviewerEmails(reader, stageName);

                    //response.Review = setupReviewStages(reader);
                    //TODO: Add response to version
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

        /// <summary>
        /// Send the Notification emails.  This method expects three result sets from the query.
        /// The first result set should always be there (its the requestor and templates)
        /// The second and third may not be there, and that's ok.  Depends on where in the 
        /// review cycle we are.  These results come from the StoredProcedures.SP_REVIEWREQUEST
        /// in ReviewRequest() and StoredProcedures.SP_SAVEREQUEST in SaveRequest();
        /// </summary>
        /// <param name="reader">The result sets</param>
        /// <param name="stageName">The name of the stage, included in the email text.</param>
        private void sendTheSubmitterEmails(IDataReader reader, string stageName)
        {

            //First get the requestor and the templates
            if (reader.Read())
            {
                ITemplate template = new Template();
                template.TemplateText = reader["Body"].ToStringSafely();

                int versionId = reader["VersionId"].ToIntegerSafely();
                string emailSubject = reader["Subject"].ToStringSafely();
                string submitterEmail = reader["SubmitterEmail"].ToStringSafely();
                string submitterName = reader["SubmitterName"].ToStringSafely();
                string baseURL = Settings.BaseUrl.Remove(Settings.BaseUrl.LastIndexOf('/'), 1);
                string reviewURL = baseURL + "/ProductLabelSetVersions/Details/" + versionId.ToStringSafely();
                string templateData = reader["Data"].ToStringSafely();
                string filledinTemplateData = string.Format(templateData, baseURL, reviewURL, stageName, getFirstName(submitterName));

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
        /// <param name="reader">The result sets</param>
        /// <param name="stageName">The name of the stage, included in the email text.</param>
        private void sendTheReviewerEmails(IDataReader reader, string stageName)
        {
            ITemplate template = new Template();
            string templateData = "";
            int versionId;
            string emailSubject = "";
            string reviewURL = "";

            //Get the Reviewer Email Template
            if (reader.Read())
            {
                versionId = reader["VersionId"].ToIntegerSafely();
                reviewURL = Settings.BaseUrl + "ProductLabelSetVersions/Details/" + versionId.ToStringSafely();
                emailSubject = reader["Subject"].ToStringSafely();
                template.TemplateText = reader["Body"].ToStringSafely();
                templateData = reader["Data"].ToStringSafely();
            }

            //Now get the reviewers
            reader.NextResult();
            while (reader.Read())
            {
                string email = reader["ReviewerEmail"].ToStringSafely();
                string emailName = reader["ReviewerName"].ToStringSafely();
                string filledinTemplateData = string.Format(templateData, getFirstName(emailName), reviewURL, stageName);
                sendEmail(template, filledinTemplateData, email, emailSubject);
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
            string[] split = fullName.Split(',');
            if (split.Length > 1)
                return split[1];
            else
                return split[0];
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
            List<string> emailOnlyList = new List<string>("jakex.murphy.douglas@domain.com;".Split(';'));
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
