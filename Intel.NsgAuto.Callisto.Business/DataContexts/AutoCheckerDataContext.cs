using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.AutoChecker;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Data;
using System.Linq;
using log4net;
using Intel.NsgAuto.Callisto.Business.Logging;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class AutoCheckerDataContext
    {

        #region AttributeTypes
        public EntitySingleMessageResult<AttributeTypes> CreateAttributeType(string userId, AttributeTypeCreateDto entity)
        {
            
            
            EntitySingleMessageResult<AttributeTypes> result = new EntitySingleMessageResult<AttributeTypes>()
            {
                Succeeded = false,
                Entity = new AttributeTypes(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEACATTRIBUTETYPEANDRETURNALL);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Name", entity.Name.NullToDBNull());
                dataAccess.AddInputParameter("@NameDisplay", entity.NameDisplay.NullToDBNull());
                dataAccess.AddInputParameter("@DataTypeId", entity.DataTypeId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Entity.Add(newAttributeType(reader));
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error(ex);

                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public AttributeTypesMetadata GetAttributeTypesMetadata(string userId)
        {
            AttributeTypesMetadata result = new AttributeTypesMetadata();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACATTRIBUTETYPESMETADATA);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                ComparisonOperations comparisonOperations = new ComparisonOperations();
                AttributeDataTypeOperations dataTypeOperations = new AttributeDataTypeOperations();
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    result.AttributeTypes = new AttributeTypes();
                    while (reader.Read())
                    {
                        result.AttributeTypes.Add(newAttributeType(reader));
                    }

                    reader.NextResult();
                    result.AttributeDataTypes = new AttributeDataTypes();
                    while (reader.Read())
                    {
                        AttributeDataType dataType = newAttributeDataType(reader);
                        dataType.ComparisonOperations = new ComparisonOperations();
                        result.AttributeDataTypes.Add(dataType);
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisonOperations.Add(newComparisonOperation(reader));
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        dataTypeOperations.Add(newAttributeDataTypeOperation(reader));
                    }
                }
                foreach (AttributeDataTypeOperation dataTypeOperation in dataTypeOperations)
                {
                    AttributeDataType dataType = result.AttributeDataTypes.Find(x => x.Id == dataTypeOperation.AttributeDataTypeId);
                    ComparisonOperation comparisonOperation = comparisonOperations.Find(x => x.Id == dataTypeOperation.ComparisonOperationId);
                    if (dataType != null && comparisonOperation != null)
                    {
                        dataType.ComparisonOperations.Add(comparisonOperation);
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public EntitySingleMessageResult<AttributeTypes> UpdateAttributeType(string userId, AttributeTypeUpdateDto entity)
        {
            EntitySingleMessageResult<AttributeTypes> result = new EntitySingleMessageResult<AttributeTypes>()
            {
                Succeeded = false,
                Entity = new AttributeTypes(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEACATTRIBUTETYPEANDRETURNALL);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", entity.Id.NullToDBNull());
                dataAccess.AddInputParameter("@Name", entity.Name.NullToDBNull());
                dataAccess.AddInputParameter("@NameDisplay", entity.NameDisplay.NullToDBNull());
                dataAccess.AddInputParameter("@DataTypeId", entity.DataTypeId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Entity.Add(newAttributeType(reader));
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }
        #endregion

        #region BuildCriterias
        public EntitySingleMessageResult<long?> CreateBuildCriteria(string userId, BuildCriteriaCreateDto entity)
        {
            EntitySingleMessageResult<long?> result = new EntitySingleMessageResult<long?>()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEACBUILDCRITERIA);
                dataAccess.AddOutputParameter("@Id", DbType.Int64);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", entity.DesignId.NullToDBNull());
                dataAccess.AddInputParameter("@FabricationFacilityId", entity.FabricationFacilityId.NullToDBNull());
                dataAccess.AddInputParameter("@TestFlowId", entity.TestFlowId.NullToDBNull());
                dataAccess.AddInputParameter("@ProbeConversionId", entity.ProbeConversionId.NullToDBNull());
                dataAccess.AddTableValueParameter("@Conditions", UserDefinedTypes.ACBUILDCRITERIACONDITIONSCREATE, createTableConditions(entity.Conditions));
                dataAccess.AddInputParameter("@Comment", entity.Comment.NullToDBNull());
                dataAccess.AddInputParameter("@RestrictToExistingCombinations", entity.RestrictToExistingCombinations.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader()) { }
                result.Entity = dataAccess.GetOutPutParameterValue("@Id").ToNullableIntSafely();
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
                if (result.Entity.HasValue) result.Succeeded = true;
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public EntitySingleMessageResult<BuildCriteriaComments> CreateBuildCriteriaComment(string userId, BuildCriteriaCommentCreateDto entity)
        {
            EntitySingleMessageResult<BuildCriteriaComments> result = new EntitySingleMessageResult<BuildCriteriaComments>()
            {
                Succeeded = false,
                Entity = new BuildCriteriaComments(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEACBUILDCRITERIACOMMENTRETURNALL);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@BuildCriteriaId", entity.BuildCriteriaId.NullToDBNull());
                dataAccess.AddInputParameter("@Text", entity.Text.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: all build criteria comments
                    while (reader.Read())
                    {
                        result.Entity.Add(newBuildCriteriaComment(reader));
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCombinations GetBuildCombinations(string userId)
        {
            return getBuildCombinations(userId);
        }

        private BuildCombinations getBuildCombinations(string userId, int? id = null, int? designId = null, int? fabricationFacilityId = null, bool? testFlowIdIsNull = null, int? testFlowId = null, bool? probeConversionIdIsNull = null, int? probeConversionId = null)
        {
            BuildCombinations result = new BuildCombinations();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACBUILDCOMBINATIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", designId.NullToDBNull());
                dataAccess.AddInputParameter("@FabricationFacilityId", fabricationFacilityId.NullToDBNull());
                dataAccess.AddInputParameter("@TestFlowIdIsNull", testFlowIdIsNull.NullToDBNull());
                dataAccess.AddInputParameter("@TestFlowId", testFlowId.NullToDBNull());
                dataAccess.AddInputParameter("@ProbeConversionIdIsNull", probeConversionIdIsNull.NullToDBNull());
                dataAccess.AddInputParameter("@ProbeConversionId", probeConversionId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newBuildCombination(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCriteria GetBuildCriteria(string userId, long id)
        {
            BuildCriteria result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACBUILDCRITERIA);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newBuildCriteria(reader);
                        result.Conditions = new BuildCriteriaConditions();

                        reader.NextResult();
                        while (reader.Read())
                        {
                            result.Conditions.Add(newBuildCriteriaExportCondition(reader));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCriteriaExportConditions GetBuildCriteriaExportConditions(string userId)
        {
            BuildCriteriaExportConditions result = new BuildCriteriaExportConditions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACBUILDCRITERIAEXPORTCONDITIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@BuildCriteriaIsPOR", true);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newBuildCriteriaExportCondition(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCriteriaAndVersions GetBuildCriteriaAndVersions(string userId, int designId, int fabricationFacilityId, int? testFlowId, int? probeConversionId)
        {
            BuildCriteriaAndVersions result = new BuildCriteriaAndVersions();
            BuildCriterias buildCriterias = new BuildCriterias();
            BuildCriteriaConditions conditions = new BuildCriteriaConditions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACBUILDCRITERIAANDVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", designId.NullToDBNull());
                dataAccess.AddInputParameter("@FabricationFacilityId", fabricationFacilityId.NullToDBNull());
                dataAccess.AddInputParameter("@TestFlowId", testFlowId.NullToDBNull());
                dataAccess.AddInputParameter("@ProbeConversionId", probeConversionId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        buildCriterias.Add(newBuildCriteria(reader));
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        conditions.Add(newBuildCriteriaCondition(reader));
                    }
                }
                result.Versions = new LongIdAndNames();
                foreach (BuildCriteria buildCriteria in buildCriterias)
                {
                    result.Versions.Add(new LongIdAndName()
                    {
                        Id = buildCriteria.Id,
                        Name = $"Version {buildCriteria.Version}; {buildCriteria.Status.Name}; {buildCriteria.CreatedBy}",
                    });
                }
                if (buildCriterias.Count > 0 && conditions.Count > 0)
                {
                    long buildCriteriaId = conditions[0].BuildCriteriaId;
                    result.BuildCriteria = buildCriterias.Find(x => x.Id == buildCriteriaId);
                    if (result.BuildCriteria != null)
                    {
                        result.BuildCriteria.Conditions = conditions;
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCriterias GetBuildCriterias(string userId, bool? isPOR = null)
        {
            BuildCriterias result = new BuildCriterias();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACBUILDCRITERIAS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@IsPOR", isPOR.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newBuildCriteria(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public Products GetDesigns(string userId)
        {
            Products result = new Products();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newDesign(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCriteriaCreate GetBuildCriteriaCreate(string userId, long? id)
        {
            BuildCriteriaCreate result = new BuildCriteriaCreate();
            ISqlDataAccess dataAccess = null;
            try
            {
                ComparisonOperations comparisonOperations = new ComparisonOperations();
                AttributeDataTypeOperations dataTypeOperations = new AttributeDataTypeOperations();
                BuildCriterias buildCriterias = new BuildCriterias();
                BuildCriteriaConditions conditions = new BuildCriteriaConditions();
                BuildCriteriaTemplateConditions templateConditions = new BuildCriteriaTemplateConditions();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACBUILDCRITERIACREATE);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set
                    result.AttributeTypes = new AttributeTypes();
                    while (reader.Read())
                    {
                        result.AttributeTypes.Add(newAttributeType(reader));
                    }

                    // #2 result set
                    reader.NextResult();
                    result.AttributeDataTypes = new AttributeDataTypes();
                    while (reader.Read())
                    {
                        AttributeDataType dataType = newAttributeDataType(reader);
                        dataType.ComparisonOperations = new ComparisonOperations();
                        result.AttributeDataTypes.Add(dataType);
                    }

                    // #3 result set
                    reader.NextResult();
                    result.AttributeTypeValues = new AttributeTypeValues();
                    while (reader.Read())
                    {
                        result.AttributeTypeValues.Add(newAttributeTypeValue(reader));
                    }

                    // #4 result set
                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisonOperations.Add(newComparisonOperation(reader));
                    }

                    // #5 result set
                    reader.NextResult();
                    while (reader.Read())
                    {
                        dataTypeOperations.Add(newAttributeDataTypeOperation(reader));
                    }

                    // #6 result set
                    reader.NextResult();
                    result.Designs = new Products();
                    while (reader.Read())
                    {
                        result.Designs.Add(newDesign(reader));
                    }

                    // #7 result set
                    reader.NextResult();
                    result.FabricationFacilities = new FabricationFacilities();
                    while (reader.Read())
                    {
                        result.FabricationFacilities.Add(newFabricationFacility(reader));
                    }

                    // #8 result set
                    reader.NextResult();
                    result.TestFlows = new TestFlows();
                    while (reader.Read())
                    {
                        result.TestFlows.Add(newTestFlow(reader));
                    }

                    // #9 result set
                    reader.NextResult();
                    result.ProbeConversions = new ProbeConversions();
                    while (reader.Read())
                    {
                        result.ProbeConversions.Add(newProbeConversion(reader));
                    }

                    // #10 result set
                    reader.NextResult();
                    result.BuildCombinations = new BuildCombinations();
                    while (reader.Read())
                    {
                        result.BuildCombinations.Add(newBuildCombination(reader));
                    }

                    // #11 result set
                    reader.NextResult();
                    result.Templates = new BuildCriteriaTemplates();
                    while (reader.Read())
                    {
                        BuildCriteriaTemplate template = newBuildCriteriaTemplate(reader);
                        template.Conditions = new BuildCriteriaTemplateConditions();
                        result.Templates.Add(template);
                    }

                    // #12 result set
                    reader.NextResult();
                    while (reader.Read())
                    {
                        templateConditions.Add(newBuildCriteriaTemplateCondition(reader));
                    }

                    if (reader.NextResult())
                    {
                        // #13 result set
                        while (reader.Read())
                        {
                            buildCriterias.Add(newBuildCriteria(reader));
                        }

                        // #14 result set
                        reader.NextResult();
                        while (reader.Read())
                        {
                            conditions.Add(newBuildCriteriaCondition(reader));
                        }
                    }
                }
                foreach (AttributeDataTypeOperation dataTypeOperation in dataTypeOperations)
                {
                    AttributeDataType dataType = result.AttributeDataTypes.Find(x => x.Id == dataTypeOperation.AttributeDataTypeId);
                    ComparisonOperation comparisonOperation = comparisonOperations.Find(x => x.Id == dataTypeOperation.ComparisonOperationId);
                    if (dataType != null && comparisonOperation != null)
                    {
                        dataType.ComparisonOperations.Add(comparisonOperation);
                    }
                }

                foreach (BuildCriteriaTemplateCondition templateCondition in templateConditions)
                {
                    BuildCriteriaTemplate template = result.Templates.Find(x => x.Id == templateCondition.TemplateId);
                    template.Conditions.Add(templateCondition);
                }

                result.Versions = new LongIdAndNames();
                foreach (BuildCriteria buildCriteria in buildCriterias)
                {
                    result.Versions.Add(new LongIdAndName()
                    {
                        Id = buildCriteria.Id,
                        Name = $"Version {buildCriteria.Version}; {buildCriteria.Status.Name}; {buildCriteria.CreatedBy}",
                    });
                }
                if (buildCriterias.Count > 0 && conditions.Count > 0)
                {
                    long buildCriteriaId = conditions[0].BuildCriteriaId;
                    result.BuildCriteria = buildCriterias.Find(x => x.Id == buildCriteriaId);
                    if (result.BuildCriteria != null)
                    {
                        result.BuildCriteria.Conditions = conditions;
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCriteriaDetails GetBuildCriteriaDetails(string userId, long id, long? idCompare = null)
        {
            BuildCriteriaDetails result = new BuildCriteriaDetails();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACBUILDCRITERIADETAILS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@IdCompare", idCompare.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #11 result sets
                        result = newBuildCriteriaDetails(reader);
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> ApproveBuildCriteria(string userId, Entities.AutoChecker.Workflows.ReviewDecisionDto decision)
        {
            return approveOrRejectBuildCriteria(StoredProcedures.SP_UPDATEACBUILDCRITERIAAPPROVEDRETURNDETAILS, userId, decision);
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> CancelBuildCriteria(string userId, Entities.AutoChecker.Workflows.DraftDecisionDto decision)
        {
            return submitOrCancelBuildCriteria(StoredProcedures.SP_UPDATEACBUILDCRITERIACANCELEDRETURNDETAILS, userId, decision);
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> RejectBuildCriteria(string userId, Entities.AutoChecker.Workflows.ReviewDecisionDto decision)
        {
            return approveOrRejectBuildCriteria(StoredProcedures.SP_UPDATEACBUILDCRITERIAREJECTEDRETURNDETAILS, userId, decision);
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> SubmitBuildCriteria(string userId, Entities.AutoChecker.Workflows.DraftDecisionDto decision)
        {
            return submitOrCancelBuildCriteria(StoredProcedures.SP_UPDATEACBUILDCRITERIASUBMITTEDRETURNDETAILS, userId, decision);
        }

        private EntitySingleMessageResult<BuildCriteriaDetails> submitOrCancelBuildCriteria(string storedProcedure, string userId, Entities.AutoChecker.Workflows.DraftDecisionDto decision)
        {
            EntitySingleMessageResult<BuildCriteriaDetails> result = new EntitySingleMessageResult<BuildCriteriaDetails>()
            {
                Succeeded = false,
            };
            ReviewEmails emails = null;
            EmailTemplates emailTemplates = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, storedProcedure);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", decision.VersionId.NullToDBNull());
                dataAccess.AddInputParameter("@IdCompare", decision.VersionIdCompare.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #11 result sets
                        result.Entity = newBuildCriteriaDetails(reader);

                        if (reader.NextResult())
                        {
                            // #12 result set
                            emailTemplates = reader.NewEmailTemplates();

                            // #13 result set
                            reader.NextResult();
                            emails = reader.NewReviewEmails();
                        }
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            sendEmails(emailTemplates, emails, decision.VersionId);
            return result;
        }

        private EntitySingleMessageResult<BuildCriteriaDetails> approveOrRejectBuildCriteria(string storedProcedure, string userId, Entities.AutoChecker.Workflows.ReviewDecisionDto decision)
        {
            EntitySingleMessageResult<BuildCriteriaDetails> result = new EntitySingleMessageResult<BuildCriteriaDetails>()
            {
                Succeeded = false,
            };
            ReviewEmails emails = null;
            EmailTemplates emailTemplates = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, storedProcedure);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", decision.VersionId.NullToDBNull());
                dataAccess.AddInputParameter("@SnapshotReviewerId", decision.SnapshotReviewerId.NullToDBNull());
                dataAccess.AddInputParameter("@Comment", decision.Comment.NullToDBNull());
                dataAccess.AddInputParameter("@IdCompare", decision.VersionIdCompare.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #11 result sets
                        result.Entity = newBuildCriteriaDetails(reader);

                        if (reader.NextResult())
                        {
                            // #12 result set
                            emailTemplates = reader.NewEmailTemplates();

                            // #13 result set
                            reader.NextResult();
                            emails = reader.NewReviewEmails();
                        }
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            sendEmails(emailTemplates, emails, decision.VersionId);
            return result;
        }
        #endregion

        #region entity data binders
        private DataTable createTableConditions(BuildCriteriaConditionsCreateDto entities)
        {
            DataTable table = createTableConditions();
            int index = 0;
            if (entities != null)
            {
                foreach (var entity in entities)
                {
                    var row = table.NewRow();
                    populateRowConditions(row, entity, ++index);
                    table.Rows.Add(row);
                }
                table.AcceptChanges();
            }
            return table;
        }

        private DataTable createTableConditions()
        {
            var result = new DataTable();
            result.Columns.Add("Index", typeof(int));
            result.Columns.Add("AttributeTypeName", typeof(string));
            result.Columns.Add("ComparisonOperationKey", typeof(string));
            result.Columns.Add("Value", typeof(string));
            return result;
        }

        private void populateRowConditions(DataRow row, BuildCriteriaConditionCreateDto entity, int index)
        {
            row["Index"] = index;
            row["AttributeTypeName"] = entity.AttributeTypeName.NullToDBNull();
            row["ComparisonOperationKey"] = entity.ComparisonOperationKey.NullToDBNull();
            row["Value"] = entity.Value.NullToDBNull();
        }

        private AttributeDataType newAttributeDataType(IDataRecord record)
        {
            return new AttributeDataType()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                NameDisplay = record["NameDisplay"].ToStringSafely(),
            };
        }

        private AttributeDataTypeOperation newAttributeDataTypeOperation(IDataRecord record)
        {
            return new AttributeDataTypeOperation()
            {
                AttributeDataTypeId = record["AttributeDataTypeId"].ToIntegerSafely(),
                ComparisonOperationId = record["ComparisonOperationId"].ToIntegerSafely(),
            };
        }

        private AttributeType newAttributeType(IDataRecord record)
        {
            return new AttributeType()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                NameDisplay = record["NameDisplay"].ToStringSafely(),
                DataType = new AttributeDataType()
                {
                    Id = record["DataTypeId"].ToIntegerSafely(),
                    Name = record["DataTypeName"].ToStringSafely(),
                    NameDisplay = record["DataTypeNameDisplay"].ToStringSafely(),
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private AttributeTypeValue newAttributeTypeValue(IDataRecord record)
        {
            return new AttributeTypeValue()
            {
                Id = record["Id"].ToIntegerSafely(),
                AttributeTypeId = record["AttributeTypeId"].ToIntegerSafely(),
                Value = record["Value"].ToStringSafely(),
                ValueDisplay = record["ValueDisplay"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private BuildCombination newBuildCombination(IDataRecord record)
        {
            int? testFlowId = record["TestFlowId"].ToNullableIntSafely();
            int? probeConversionId = record["ProbeConversionId"].ToNullableIntSafely();
            return new BuildCombination()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                Design = new Product()
                {
                    Id = record["DesignId"].ToIntegerSafely(),
                    Name = record["DesignName"].ToStringSafely(),
                    DesignFamily = new DesignFamily()
                    {
                        Id = record["DesignFamilyId"].ToIntegerSafely(),
                        Name = record["DesignFamilyName"].ToStringSafely()
                    },
                    IsActive = record["DesignIsActive"].ToStringSafely().ToBooleanSafely(),
                    CreatedBy = record["DesignCreatedBy"].ToStringSafely(),
                    CreatedOn = record["DesignCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["DesignUpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["DesignUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
                },
                FabricationFacility = new FabricationFacility()
                {
                    Id = record["FabricationFacilityId"].ToIntegerSafely(),
                    Name = record["FabricationFacilityName"].ToStringSafely(),
                },
                TestFlow = testFlowId == null ? null : new TestFlow()
                {
                    Id = record["TestFlowId"].ToIntegerSafely(),
                    Name = record["TestFlowName"].ToStringSafely(),
                },
                ProbeConversion = probeConversionId == null ? null : new ProbeConversion()
                {
                    Id = record["ProbeConversionId"].ToIntegerSafely(),
                    Name = record["ProbeConversionName"].ToStringSafely(),
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private BuildCriteria newBuildCriteria(IDataRecord record)
        {
            int? testFlowId = record["TestFlowId"].ToNullableIntSafely();
            int? probeConversionId = record["ProbeConversionId"].ToNullableIntSafely();
            return new BuildCriteria()
            {
                Id = record["Id"].ToLongSafely(),
                Version = record["Version"].ToIntegerSafely(),
                IsPOR = record["IsPOR"].ToStringSafely().ToBooleanSafely(),
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                Status = new Status()
                {
                    Id = record["StatusId"].ToIntegerSafely(),
                    Name = record["StatusName"].ToStringSafely(),
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                Design = new Product()
                {
                    Id = record["DesignId"].ToIntegerSafely(),
                    Name = record["DesignName"].ToStringSafely(),
                    DesignFamily = new DesignFamily()
                    {
                        Id = record["DesignFamilyId"].ToIntegerSafely(),
                        Name = record["DesignFamilyName"].ToStringSafely()
                    },
                    IsActive = record["DesignIsActive"].ToStringSafely().ToBooleanSafely(),
                    CreatedBy = record["DesignCreatedBy"].ToStringSafely(),
                    CreatedOn = record["DesignCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["DesignUpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["DesignUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
                },
                FabricationFacility = new FabricationFacility()
                {
                    Id = record["FabricationFacilityId"].ToIntegerSafely(),
                    Name = record["FabricationFacilityName"].ToStringSafely(),
                },
                TestFlow = testFlowId == null ? null : new TestFlow()
                {
                    Id = record["TestFlowId"].ToIntegerSafely(),
                    Name = record["TestFlowName"].ToStringSafely(),
                },
                ProbeConversion = probeConversionId == null ? null : new ProbeConversion()
                {
                    Id = record["ProbeConversionId"].ToIntegerSafely(),
                    Name = record["ProbeConversionName"].ToStringSafely(),
                },
                EffectiveOn = record["EffectiveOn"].ToNullableDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private BuildCriteriaDetails newBuildCriteriaDetails(IDataReader reader)
        {
            BuildCriteriaDetails result = new BuildCriteriaDetails();

            // #1 result set: build criteria
            result.BuildCriteria = newBuildCriteria(reader);

            // #2 result set: build criteria export conditions
            result.BuildCriteria.Conditions = new BuildCriteriaConditions();
            reader.NextResult();
            while (reader.Read())
            {
                result.BuildCriteria.Conditions.Add(newBuildCriteriaExportCondition(reader));
            }

            // #3 result set: build criteria comments
            result.BuildCriteria.Comments = new BuildCriteriaComments();
            reader.NextResult();
            while (reader.Read())
            {
                result.BuildCriteria.Comments.Add(newBuildCriteriaComment(reader));
            }

            // #4 result set: build criterias for comparison purposes
            result.BuildCriteriasCompare = new BuildCriterias();
            reader.NextResult();
            while (reader.Read())
            {
                result.BuildCriteriasCompare.Add(newBuildCriteria(reader));
            }

            // #5 result set: comparison results
            result.ComparisonResults = new BuildCriteriaComparisonResults();
            reader.NextResult();
            while (reader.Read())
            {
                result.ComparisonResults.Add(newBuildCriteriaComparisonResult(reader));
            }

            // #6 result set: build criteria compared against
            reader.NextResult();
            if (reader.Read())
            {
                result.BuildCriteriaCompare = newBuildCriteria(reader);
                result.BuildCriteriaCompare.Conditions = new BuildCriteriaConditions();
            }

            // #7 result set: build criteria export conditions to compare against
            reader.NextResult();
            if (result.BuildCriteriaCompare != null)
            {
                while (reader.Read())
                {
                    result.BuildCriteriaCompare.Conditions.Add(newBuildCriteriaExportCondition(reader));
                }
            }

            // #8 through #11 result sets
            reader.NextResult();
            result.Review = reader.NewReview();

            return result;
        }

        private T newBuildCriteriaConditionGeneric<T>(IDataRecord record) where T : BuildCriteriaCondition, new()
        {
            return new T()
            {
                Id = record["Id"].ToLongSafely(),
                BuildCriteriaId = record["BuildCriteriaId"].ToLongSafely(),
                AttributeType = new AttributeType()
                {
                    Id = record["AttributeTypeId"].ToIntegerSafely(),
                    Name = record["AttributeTypeName"].ToStringSafely(),
                    NameDisplay = record["AttributeTypeNameDisplay"].ToStringSafely(),
                    DataType = new AttributeDataType()
                    {
                        Id = record["AttributeTypeDataTypeId"].ToIntegerSafely(),
                        Name = record["AttributeTypeDataTypeName"].ToStringSafely(),
                        NameDisplay = record["AttributeTypeDataTypeNameDisplay"].ToStringSafely(),
                    },
                    CreatedBy = record["AttributeTypeCreatedBy"].ToStringSafely(),
                    CreatedOn = record["AttributeTypeCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["AttributeTypeUpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["AttributeTypeUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                },
                LogicalOperation = new LogicalOperation() // currently only allow AND
                {
                    Id = 1,
                    Key = "and",
                    Name = "AND",
                },
                ComparisonOperation = new ComparisonOperation()
                {
                    Id = record["ComparisonOperationId"].ToIntegerSafely(),
                    Key = record["ComparisonOperationKey"].ToStringSafely(),
                    KeyTreadstone = record["ComparisonOperationKeyTreadstone"].ToStringSafely(),
                    Name = record["ComparisonOperationName"].ToStringSafely(),
                    OperandType = new OperandType()
                    {
                        Id = record["ComparisonOperationOperandTypeId"].ToIntegerSafely(),
                        Name = record["ComparisonOperationOperandTypeName"].ToStringSafely(),
                    },
                },
                Value = record["Value"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private BuildCriteriaComparisonResult newBuildCriteriaComparisonResult(IDataRecord record)
        {
            return new BuildCriteriaComparisonResult()
            {
                EntityType = record["EntityType"].ToStringSafely(),
                BuildCombinationId = record["BuildCombinationId"].ToNullableIntSafely(),
                AttributeTypeId = record["AttributeTypeId"].ToNullableIntSafely(),
                ComparisonOperationId = record["ComparisonOperationId"].ToNullableIntSafely(),
                MissingFrom = record["MissingFrom"].ToNullableIntSafely(),
                Id1 = record["Id1"].ToNullableIntSafely(),
                Id2 = record["Id2"].ToNullableIntSafely(),
                Field = record["Field"].ToStringSafely(),
                Different = record["Different"].ToStringSafely().ToBooleanSafely(),
                Value1 = record["Value1"].ToStringSafely(),
                Value2 = record["Value2"].ToStringSafely(),
            };
        }

        private BuildCriteriaCondition newBuildCriteriaCondition(IDataRecord record)
        {
            return newBuildCriteriaConditionGeneric<BuildCriteriaCondition>(record);
        }

        private BuildCriteriaExportCondition newBuildCriteriaExportCondition(IDataRecord record)
        {
            BuildCriteriaExportCondition result = newBuildCriteriaConditionGeneric<BuildCriteriaExportCondition>(record);
            result.Design = new Product()
            {
                Id = record["DesignId"].ToIntegerSafely(),
                Name = record["DesignName"].ToStringSafely(),
                DesignFamily = new DesignFamily()
                {
                    Id = record["DesignFamilyId"].ToIntegerSafely(),
                    Name = record["DesignFamilyName"].ToStringSafely()
                },
                IsActive = record["DesignIsActive"].ToStringSafely().ToBooleanSafely(),
                CreatedBy = record["DesignCreatedBy"].ToStringSafely(),
                CreatedOn = record["DesignCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["DesignUpdatedBy"].ToStringSafely(),
                UpdatedOn = record["DesignUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
            };
            result.FabricationFacility = new FabricationFacility()
            {
                Id = record["FabricationFacilityId"].ToIntegerSafely(),
                Name = record["FabricationFacilityName"].ToStringSafely(),
            };
            int? testFlowId = record["TestFlowId"].ToNullableIntSafely();
            if (testFlowId.HasValue)
            {
                result.TestFlow = new TestFlow()
                {
                    Id = testFlowId.Value,
                    Name = record["TestFlowName"].ToStringSafely(),
                };
            }
            int? probeConversionId = record["ProbeConversionId"].ToNullableIntSafely();
            if (probeConversionId.HasValue)
            {
                result.ProbeConversion = new ProbeConversion()
                {
                    Id = probeConversionId.Value,
                    Name = record["ProbeConversionName"].ToStringSafely(),
                };
            }
            return result;
        }

        private BuildCriteriaComment newBuildCriteriaComment(IDataRecord record)
        {
            return new BuildCriteriaComment()
            {
                Id = record["Id"].ToLongSafely(),
                BuildCriteriaId = record["BuildCriteriaId"].ToIntegerSafely(),
                Text = record["Text"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private BuildCriteriaTemplate newBuildCriteriaTemplate(IDataRecord record)
        {
            return new BuildCriteriaTemplate()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                DesignFamily = new DesignFamily()
                {
                    Id = record["DesignFamilyId"].ToIntegerSafely(),
                    Name = record["DesignFamilyName"].ToStringSafely()
                },
            };
        }

        private BuildCriteriaTemplateCondition newBuildCriteriaTemplateCondition(IDataRecord record)
        {
            return new BuildCriteriaTemplateCondition()
            {
                Id = record["Id"].ToIntegerSafely(),
                TemplateId = record["TemplateId"].ToIntegerSafely(),
                AttributeType = new AttributeType()
                {
                    Id = record["AttributeTypeId"].ToIntegerSafely(),
                    Name = record["AttributeTypeName"].ToStringSafely(),
                    NameDisplay = record["AttributeTypeNameDisplay"].ToStringSafely(),
                    DataType = new AttributeDataType()
                    {
                        Id = record["AttributeTypeDataTypeId"].ToIntegerSafely(),
                        Name = record["AttributeTypeDataTypeName"].ToStringSafely(),
                        NameDisplay = record["AttributeTypeDataTypeNameDisplay"].ToStringSafely(),
                    },
                    CreatedBy = record["AttributeTypeCreatedBy"].ToStringSafely(),
                    CreatedOn = record["AttributeTypeCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["AttributeTypeUpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["AttributeTypeUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                },
                ComparisonOperation = new ComparisonOperation()
                {
                    Id = record["ComparisonOperationId"].ToIntegerSafely(),
                    Key = record["ComparisonOperationKey"].ToStringSafely(),
                    KeyTreadstone = record["ComparisonOperationKeyTreadstone"].ToStringSafely(),
                    Name = record["ComparisonOperationName"].ToStringSafely(),
                    OperandType = new OperandType()
                    {
                        Id = record["ComparisonOperationOperandTypeId"].ToIntegerSafely(),
                        Name = record["ComparisonOperationOperandTypeName"].ToStringSafely(),
                    },
                },
                Value = record["Value"].ToStringSafely(),
            };
        }

        private ComparisonOperation newComparisonOperation(IDataRecord record)
        {
            return new ComparisonOperation()
            {
                Id = record["Id"].ToIntegerSafely(),
                Key = record["Key"].ToStringSafely(),
                KeyTreadstone = record["KeyTreadstone"].ToStringSafely(),
                Name = record["Name"].ToStringSafely(),
                OperandType = new OperandType()
                {
                    Id = record["OperandTypeId"].ToIntegerSafely(),
                    Name = record["OperandTypeName"].ToStringSafely(),
                },
            };
        }

        private Product newDesign(IDataRecord record)
        {
            return new Product()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                DesignFamily = new DesignFamily()
                {
                    Id = record["DesignFamilyId"].ToIntegerSafely(),
                    Name = record["DesignFamilyName"].ToStringSafely()
                },
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
            };
        }

        private FabricationFacility newFabricationFacility(IDataRecord record)
        {
            return new FabricationFacility()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            };
        }

        private TestFlow newTestFlow(IDataRecord record)
        {
            return new TestFlow()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            };
        }

        private ProbeConversion newProbeConversion(IDataRecord record)
        {
            return new ProbeConversion()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            };
        }
        #endregion

        #region helpers
        private void sendEmails(EmailTemplates emailTemplates, ReviewEmails emails, long id)
        {
            if (emailTemplates != null && emails != null && emailTemplates.Count > 0 && emails.Count > 0)
            {
                string baseUrl = Settings.BaseUrl;
                if (baseUrl.EndsWith(@"/")) baseUrl = baseUrl.Substring(0, baseUrl.Length - 1); // remove trailing "/" character
                string itemUrl = baseUrl + $"/AutoChecker/BuildCriteriaDetails/{id}";
                foreach (EmailTemplate template in emailTemplates)
                {
                    EmailTemplateSender sender = new EmailTemplateSender(template);
                    foreach (ReviewEmail email in emails.Where(x => x.EmailTemplateId == template.Id))
                    {
                        /*
                            {0} = base url for the site without trailing "/" character (used for images)
                            {1} = url for the item being reviewed
                            {2} = review stage name
                            {3} = recipient name
                            {4} = type of item being reviewed
                            {5} = item description
                         */
                        try
                        {
                            string[] to = email.To.Split(';');
                            sender.Cc.Clear();
                            sender.Bcc.Clear();
                            if (email.Cc.IsNeitherNullNorEmpty())
                            {
                                sender.Cc.AddRange(email.Cc.Split(';'));
                            }
                            if (email.Bcc.IsNeitherNullNorEmpty())
                            {
                                sender.Bcc.AddRange(email.Bcc.Split(';'));
                            }
                            sender.Send(to, baseUrl, itemUrl, email.ReviewAtDescription, email.RecipientName, "Auto Checker Build Criteria", email.VersionDescription);
                        }
                        catch { }
                    }
                }
            }
        }
        #endregion
    }
}
