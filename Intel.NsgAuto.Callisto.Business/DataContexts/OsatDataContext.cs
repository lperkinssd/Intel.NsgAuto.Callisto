using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.Osat;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using DevExpress.XtraSpreadsheet.Commands;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class OsatDataContext
    {
        #region attribute types
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
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEOSATATTRIBUTETYPEANDRETURNALL);
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
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public AttributeTypesManage GetAttributeTypesManage(string userId)
        {
            AttributeTypesManage result = new AttributeTypesManage();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATATTRIBUTETYPESMANAGE);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                ComparisonOperations comparisonOperations = new ComparisonOperations();
                AttributeDataTypeOperations dataTypeOperations = new AttributeDataTypeOperations();
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: attribute types
                    result.AttributeTypes = new AttributeTypes();
                    while (reader.Read())
                    {
                        result.AttributeTypes.Add(newAttributeType(reader));
                    }

                    // #2 result set: attribute data types
                    reader.NextResult();
                    result.AttributeDataTypes = new AttributeDataTypes();
                    while (reader.Read())
                    {
                        AttributeDataType dataType = newAttributeDataType(reader);
                        dataType.ComparisonOperations = new ComparisonOperations();
                        result.AttributeDataTypes.Add(dataType);
                    }

                    // #3 result set: comparison operations
                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisonOperations.Add(newComparisonOperation(reader));
                    }

                    // #4 result set: attribute data type operations
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
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATATTRIBUTETYPEANDRETURNALL);
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
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }
        #endregion

        #region build criterias
        public EntitySingleMessageResult<long?> CreateBuildCriteriaSet(string userId, BuildCriteriaSetCreateDto entity)
        {
            EntitySingleMessageResult<long?> result = new EntitySingleMessageResult<long?>()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                var tables = createTablesBuildCriterias(entity.BuildCriterias);
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEOSATBUILDCRITERIASET);
                dataAccess.AddOutputParameter("@Id", DbType.Int64);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@BuildCombinationId", entity.BuildCombinationId.NullToDBNull());
                dataAccess.AddTableValueParameter("@BuildCriterias", UserDefinedTypes.OSATBUILDCRITERIASCREATE, tables.BuildCriterias);
                dataAccess.AddTableValueParameter("@Conditions", UserDefinedTypes.OSATBUILDCRITERIACONDITIONSCREATE, tables.BuildCriteriaConditions);
                dataAccess.AddInputParameter("@Comment", entity.Comment.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader()) { }
                result.Entity = dataAccess.GetOutPutParameterValue("@Id").ToNullableIntSafely();
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
                if (result.Entity.HasValue) result.Succeeded = true;
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

        public EntitySingleMessageResult<BuildCriteriaSetComments> CreateBuildCriteriaSetComment(string userId, BuildCriteriaSetCommentCreateDto entity)
        {
            EntitySingleMessageResult<BuildCriteriaSetComments> result = new EntitySingleMessageResult<BuildCriteriaSetComments>()
            {
                Succeeded = false,
                Entity = new BuildCriteriaSetComments(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEOSATBUILDCRITERIASETCOMMENTRETURNALL);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@BuildCriteriaSetId", entity.BuildCriteriaSetId.NullToDBNull());
                dataAccess.AddInputParameter("@Text", entity.Text.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: all build criteria set comments
                    while (reader.Read())
                    {
                        result.Entity.Add(newBuildCriteriaSetComment(reader));
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public BuildCombinations GetBuildCombinations(string userId, int? designId = null, bool? porBuildCriteriaSetExists = null, int? osatId=null)
        {
            return getBuildCombinations(userId, designId: designId, porBuildCriteriaSetExists: porBuildCriteriaSetExists, osatId: osatId);
        }

        private BuildCombinations getBuildCombinations(string userId, int? id = null, int? designId = null, bool? porBuildCriteriaSetExists = null, int?osatId =null)
        {
            BuildCombinations result = new BuildCombinations();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCOMBINATIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", designId.NullToDBNull());
                dataAccess.AddInputParameter("@OsatId", osatId.NullToDBNull());
                dataAccess.AddInputParameter("@PorBuildCriteriaSetExists", porBuildCriteriaSetExists.NullToDBNull());
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
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public BuildCriteriaSet GetBuildCriteriaSet(string userId, long id)
        {
            BuildCriteriaSet result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIASET);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 result set: build criteria set
                        result = newBuildCriteriaSet(reader);

                        // #2 result set: build criterias
                        result.BuildCriterias = new BuildCriterias();
                        reader.NextResult();
                        while (reader.Read())
                        {
                            result.BuildCriterias.Add(newBuildCriteria(reader));
                        }

                        // #3 result set: build criteria conditions
                        reader.NextResult();
                        while (reader.Read())
                        {
                            BuildCriteriaCondition condition = newBuildCriteriaCondition(reader);
                            BuildCriteria buildCriteria = result.BuildCriterias.Find(x => x.Id == condition.BuildCriteriaId);
                            if (buildCriteria != null)
                            {
                                if (buildCriteria.Conditions == null) buildCriteria.Conditions = new BuildCriteriaConditions();
                                buildCriteria.Conditions.Add(condition);
                            }
                        }
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

        public BuildCriteriaSetAndVersions GetBuildCriteriaSetAndVersions(string userId, int buildCombinationId)
        {
            BuildCriteriaSetAndVersions result = new BuildCriteriaSetAndVersions();
            BuildCriteriaSets buildCriteriaSets = new BuildCriteriaSets();
            BuildCriterias buildCriterias = new BuildCriterias();
            BuildCriteriaConditions conditions = new BuildCriteriaConditions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIASETANDVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@BuildCombinationId", buildCombinationId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: build criterias sets matching the build combination id
                    while (reader.Read())
                    {
                        buildCriteriaSets.Add(newBuildCriteriaSet(reader));
                    }

                    // #2 result set: build criterias
                    reader.NextResult();
                    while (reader.Read())
                    {
                        buildCriterias.Add(newBuildCriteria(reader));
                    }

                    // #3 result set: build criteria conditions
                    reader.NextResult();
                    while (reader.Read())
                    {
                        conditions.Add(newBuildCriteriaCondition(reader));
                    }
                }
                result.Versions = new LongIdAndNames();
                foreach (BuildCriteriaSet buildCriteriaSet in buildCriteriaSets)
                {
                    result.Versions.Add(new LongIdAndName()
                    {
                        Id = buildCriteriaSet.Id,
                        Name = $"Version {buildCriteriaSet.Version}; {buildCriteriaSet.Status.Name}; {buildCriteriaSet.CreatedBy}",
                    });
                }
                if (buildCriteriaSets.Count > 0 && buildCriterias.Count > 0)
                {
                    long buildCriteriaSetId = buildCriterias[0].BuildCriteriaSetId;
                    result.BuildCriteriaSet = buildCriteriaSets.Find(x => x.Id == buildCriteriaSetId);
                    if (result.BuildCriteriaSet != null)
                    {
                        result.BuildCriteriaSet.BuildCriterias = buildCriterias;
                        foreach (BuildCriteriaCondition condition in conditions)
                        {
                            BuildCriteria buildCriteria = buildCriterias.Find(x => x.Id == condition.BuildCriteriaId);
                            if (buildCriteria != null)
                            {
                                if (buildCriteria.Conditions == null) buildCriteria.Conditions = new BuildCriteriaConditions();
                                buildCriteria.Conditions.Add(condition);
                            }
                        }
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

        public BuildCombinationAndBuildCriteriaSets GetBuildCombinationAndBuildCriteriaSets(string userId, int buildCombinationId)
        {
            BuildCombinationAndBuildCriteriaSets result = new BuildCombinationAndBuildCriteriaSets();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCOMBINATIONANDBUILDCRITERIASETS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@BuildCombinationId", buildCombinationId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: build combination record
                    if (reader.Read())
                    {
                        result.BuildCombination = newBuildCombination(reader);
                    }

                    // #2 result set: build criteria sets
                    reader.NextResult();
                    result.BuildCriteriaSets = new BuildCriteriaSets();
                    while (reader.Read())
                    {
                        result.BuildCriteriaSets.Add(newBuildCriteriaSet(reader));
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

        public BuildCriteriaSetCreate GetBuildCriteriaSetCreate(string userId, long? id, int? buildCombinationId)
        {
            BuildCriteriaSetCreate result = new BuildCriteriaSetCreate();
            ISqlDataAccess dataAccess = null;
            try
            {
                ComparisonOperations comparisonOperations = new ComparisonOperations();
                AttributeDataTypeOperations dataTypeOperations = new AttributeDataTypeOperations();
                BuildCriteriaSets buildCriteriaSets = new BuildCriteriaSets();
                BuildCriterias buildCriterias = new BuildCriterias();
                BuildCriteriaConditions conditions = new BuildCriteriaConditions();
                BuildCriteriaTemplates templates = new BuildCriteriaTemplates();
                BuildCriteriaTemplateConditions templateConditions = new BuildCriteriaTemplateConditions();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIASETCREATE);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@BuildCombinationId", buildCombinationId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: attribute types
                    result.AttributeTypes = new AttributeTypes();
                    while (reader.Read())
                    {
                        result.AttributeTypes.Add(newAttributeType(reader));
                    }

                    // #2 result set: attribute data types
                    reader.NextResult();
                    result.AttributeDataTypes = new AttributeDataTypes();
                    while (reader.Read())
                    {
                        AttributeDataType dataType = newAttributeDataType(reader);
                        dataType.ComparisonOperations = new ComparisonOperations();
                        result.AttributeDataTypes.Add(dataType);
                    }

                    // #3 result set: attribute type values
                    reader.NextResult();
                    result.AttributeTypeValues = new AttributeTypeValues();
                    while (reader.Read())
                    {
                        result.AttributeTypeValues.Add(newAttributeTypeValue(reader));
                    }

                    // #4 result set: comparison operations
                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisonOperations.Add(newComparisonOperation(reader));
                    }

                    // #5 result set: data type comparison operations
                    reader.NextResult();
                    while (reader.Read())
                    {
                        dataTypeOperations.Add(newAttributeDataTypeOperation(reader));
                    }

                    // #6 result set: designs (that are associated with at least one build combination)
                    reader.NextResult();
                    result.Designs = new Products();
                    while (reader.Read())
                    {
                        result.Designs.Add(newDesign(reader));
                    }

                    // #7 result set: build combinations; all that are associated with designId
                    reader.NextResult();
                    result.BuildCombinations = new BuildCombinations();
                    while (reader.Read())
                    {
                        result.BuildCombinations.Add(newBuildCombination(reader));
                    }

                    // #8 result set: build criteria set templates
                    reader.NextResult();
                    result.SetTemplates = new BuildCriteriaSetTemplates();
                    while (reader.Read())
                    {
                        BuildCriteriaSetTemplate setTemplate = newBuildCriteriaSetTemplate(reader);
                        setTemplate.Templates = new BuildCriteriaTemplates();
                        result.SetTemplates.Add(setTemplate);
                    }

                    // #9 result set: build criteria templates
                    reader.NextResult();
                    while (reader.Read())
                    {
                        BuildCriteriaTemplate template = newBuildCriteriaTemplate(reader);
                        template.Conditions = new BuildCriteriaTemplateConditions();
                        templates.Add(template);
                    }

                    // #10 result set: build criteria template conditions
                    reader.NextResult();
                    while (reader.Read())
                    {
                        templateConditions.Add(newBuildCriteriaTemplateCondition(reader));
                    }

                    reader.NextResult();
                    result.Osats = new Osats();
                    while (reader.Read())
                    {
                        result.Osats.Add(newOsat(reader));
                    }

                    if (reader.NextResult())
                    {
                        // #11 result set: build criteria sets (not just for id, but all matching buildCombinationId)
                        while (reader.Read())
                        {
                            buildCriteriaSets.Add(newBuildCriteriaSet(reader));
                        }

                        // #12 result set: build criterias; all that are associated with id
                        reader.NextResult();
                        while (reader.Read())
                        {
                            buildCriterias.Add(newBuildCriteria(reader));
                        }

                        // #13 result set: build criteria conditions; all that are associated with id
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

                foreach (BuildCriteriaTemplate template in templates)
                {
                    BuildCriteriaSetTemplate setTemplate = result.SetTemplates.Find(x => x.Id == template.SetTemplateId);
                    setTemplate?.Templates.Add(template);
                }

                foreach (BuildCriteriaTemplateCondition templateCondition in templateConditions)
                {
                    BuildCriteriaTemplate template = templates.Find(x => x.Id == templateCondition.TemplateId);
                    template?.Conditions.Add(templateCondition);
                }

                result.Versions = new LongIdAndNames();
                foreach (BuildCriteriaSet buildCriteriaSet in buildCriteriaSets)
                {
                    result.Versions.Add(new LongIdAndName()
                    {
                        Id = buildCriteriaSet.Id,
                        Name = $"Version {buildCriteriaSet.Version}; {buildCriteriaSet.Status.Name}; {buildCriteriaSet.CreatedBy}",
                    });
                }
                if (buildCriteriaSets.Count > 0 && buildCriterias.Count > 0)
                {
                    long buildCriteriaSetId = buildCriterias[0].BuildCriteriaSetId;
                    result.BuildCriteriaSet = buildCriteriaSets.Find(x => x.Id == buildCriteriaSetId);
                    if (result.BuildCriteriaSet != null)
                    {
                        result.BuildCriteriaSet.BuildCriterias = buildCriterias;
                        foreach (BuildCriteriaCondition condition in conditions)
                        {
                            BuildCriteria buildCriteria = buildCriterias.Find(x => x.Id == condition.BuildCriteriaId);
                            if (buildCriteria != null)
                            {
                                if (buildCriteria.Conditions == null) buildCriteria.Conditions = new BuildCriteriaConditions();
                                buildCriteria.Conditions.Add(condition);
                            }
                        }
                        if (result.BuildCriteriaSet.BuildCombination != null && result.BuildCombinations != null)
                        {
                            result.BuildCombination = result.BuildCombinations.Find(x => x.Id == result.BuildCriteriaSet.BuildCombination.Id);
                        }
                    }
                }
                if (result.BuildCriteriaSet == null && buildCombinationId.HasValue)
                {
                    result.BuildCombination = result.BuildCombinations.Find(x => x.Id == buildCombinationId.Value);
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

        public BuildCriteriaSetDetails GetBuildCriteriaSetDetails(string userId, long id, long? idCompare = null)
        {
            BuildCriteriaSetDetails result = new BuildCriteriaSetDetails();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIASETDETAILS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@IdCompare", idCompare.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #13 result sets
                        result = newBuildCriteriaSetDetails(reader);
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

        public BuildCriteriaSet GetBuildCriteriaSet(long id)
        {
            var result = new BuildCriteriaSet();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIASETS);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newBuildCriteriaSet(reader);
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

        public DesignSummary GetDesignSummary(string userId, int? designId, int? designFamilyId = null)
        {
            DesignSummary result = new DesignSummary();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATDESIGNSUMMARY);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", designId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignFamilyId", designFamilyId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: designs
                    result.Designs = new Products();
                    while (reader.Read())
                    {
                        result.Designs.Add(newDesign(reader));
                    }

                    // #2 result set: build combinations
                    reader.NextResult();
                    result.BuildCombinations = new BuildCombinations();
                    while (reader.Read())
                    {
                        result.BuildCombinations.Add(newBuildCombination(reader));
                    }

                    reader.NextResult();
                    result.Osats = new Osats();
                    while (reader.Read())
                    {
                        result.Osats.Add(newOsat(reader));
                    }
                }
                if (designId.HasValue) result.SelectedDesign = result.Designs.Find(x => x.Id == designId.Value);
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

        public EntitySingleMessageResult<BuildCriteriaSetDetails> ApproveBuildCriteriaSet(string userId, Entities.Osat.Workflows.ReviewDecisionDto decision,bool isBulk, bool sendEmail)
        {
            return approveOrRejectBuildCriteriaSet(StoredProcedures.SP_UPDATEOSATBUILDCRITERIASETAPPROVEDRETURNDETAILS, userId, decision, isBulk, sendEmail);
        }

        public EntitySingleMessageResult<BuildCriteriaSetDetails> CancelBuildCriteriaSet(string userId, Entities.Osat.Workflows.DraftDecisionDto decision, bool isBulk, bool sendEmail)
        {
            return submitOrCancelBuildCriteriaSet(StoredProcedures.SP_UPDATEOSATBUILDCRITERIASETCANCELEDRETURNDETAILS, userId, decision, isBulk, sendEmail, "");
        }

        public EntitySingleMessageResult<BuildCriteriaSetDetails> RejectBuildCriteriaSet(string userId, Entities.Osat.Workflows.ReviewDecisionDto decision, bool isBulk, bool sendEmail)
        {
            return approveOrRejectBuildCriteriaSet(StoredProcedures.SP_UPDATEOSATBUILDCRITERIASETREJECTEDRETURNDETAILS, userId, decision,isBulk,sendEmail);
        }

        public EntitySingleMessageResult<BuildCriteriaSetDetails> SubmitBuildCriteriaSet(string userId, Entities.Osat.Workflows.DraftDecisionDto decision, bool isBulk, bool sendEmail, string ReviewText)
        {
            return submitOrCancelBuildCriteriaSet(StoredProcedures.SP_UPDATEOSATBUILDCRITERIASETSUBMITTEDRETURNDETAILS, userId, decision, isBulk, sendEmail, ReviewText);
        }

        private EntitySingleMessageResult<BuildCriteriaSetDetails> submitOrCancelBuildCriteriaSet(string storedProcedure, string userId, Entities.Osat.Workflows.DraftDecisionDto decision, bool isBulk, bool sendEmail, string ReviewText)
        {
            EntitySingleMessageResult<BuildCriteriaSetDetails> result = new EntitySingleMessageResult<BuildCriteriaSetDetails>()
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
                dataAccess.AddInputParameter("@IsBulk", isBulk.NullToDBNull());
                dataAccess.AddInputParameter("@Override", decision.Override.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #11 result sets
                        result.Entity = newBuildCriteriaSetDetails(reader);

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
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }

            if (!sendEmail)
                return result;

            if (isBulk)
            {
                sendEmailsBulkUpdate(emailTemplates, emails, decision.ImportId, ReviewText, userId);
            }
            else
            {
                sendEmails(emailTemplates, emails, decision.VersionId);
            }

            return result;
        }

        private EntitySingleMessageResult<BuildCriteriaSetDetails> approveOrRejectBuildCriteriaSet(string storedProcedure, string userId, Entities.Osat.Workflows.ReviewDecisionDto decision, bool isBulk, bool sendEmail)
        {
            EntitySingleMessageResult<BuildCriteriaSetDetails> result = new EntitySingleMessageResult<BuildCriteriaSetDetails>()
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
                dataAccess.AddInputParameter("@IsBulk", isBulk.NullToDBNull());
                dataAccess.AddInputParameter("@IdCompare", decision.VersionIdCompare.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #11 result sets
                        result.Entity = newBuildCriteriaSetDetails(reader);

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
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }

            if (!sendEmail)
                return result;

            sendEmails(emailTemplates, emails, decision.VersionId);
            return result;
        }

        public EntitySingleMessageResult<BuildCombinations> UpdateBuildCombinationPublish(string userId, BuildCombinationUpdatePublishDto entity)
        {
            string storedProcedure = entity?.Enabled == true ? StoredProcedures.SP_UPDATEOSATBUILDCOMBINATIONPUBLISHENABLEDRETURNALL : StoredProcedures.SP_UPDATEOSATBUILDCOMBINATIONPUBLISHDISABLEDRETURNALL;
            return updateBuildCombinationPublishEnabledOrDisabled(storedProcedure, userId, entity);
        }

        private EntitySingleMessageResult<BuildCombinations> updateBuildCombinationPublishEnabledOrDisabled(string storedProcedure, string userId, BuildCombinationUpdatePublishDto entity)
        {
            EntitySingleMessageResult<BuildCombinations> result = new EntitySingleMessageResult<BuildCombinations>()
            {
                Entity = new BuildCombinations(),
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, storedProcedure);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", entity.Id.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", entity.DesignId.NullToDBNull());
                dataAccess.AddInputParameter("@PorBuildCriteriaSetExists", entity.PorBuildCriteriaSetExists.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Entity.Add(newBuildCombination(reader));
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        //public EntitySingleMessageResult<long?> UpdateOsatBuildCriteriaSetForBulkUpdate(string userId, BuildCriteriaSetConditionsUpdateDto entity)
        //{
        //    EntitySingleMessageResult<long?> result = new EntitySingleMessageResult<long?>()
        //    {
        //        Succeeded = false,
        //    };
        //    ISqlDataAccess dataAccess = null;
        //    try
        //    {
        //        var buildCriteriaConditions = CreateTablesBuildCriteriasForBulkUpdate(entity.Conditions);
        //        dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATBUILDCRITERIASETFORBULKUPDATE);
        //        dataAccess.AddInputParameter("@BuildCriteriaSetId", entity.BuildCriteriaSetId.NullToDBNull());
        //        dataAccess.AddOutputParameter("@Message", DbType.String, 500);
        //        dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
        //        dataAccess.AddInputParameter("@BuildCombinationId", entity.BuildCombinationId.NullToDBNull());
        //        dataAccess.AddTableValueParameter("@UpdatedConditions", UserDefinedTypes.OSATBUILDCRITERIACONDITIONSUPDATE, buildCriteriaConditions);
        //        using (IDataReader reader = dataAccess.ExecuteReader()) { }
        //        result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
        //        if (result.Entity.HasValue) result.Succeeded = true;
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        dataAccess?.Close();
        //    }
        //    return result;
        //}


        #endregion





        #region pas
        public PasVersion GetPasVersion(string userId, int id)
        {
            return getPasVersions(userId, id: id).FirstOrDefault();
        }

        public PasVersionDetails GetPasVersionDetails(string userId, int id)
        {
            PasVersionDetails result = new PasVersionDetails();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATPASVERSIONDETAILS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 and #2 result sets
                        result = newPasVersionDetails(reader);
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

        public PasVersions GetPasVersions(string userId)
        {
            return getPasVersions(userId);
        }

        public EntitySingleMessageResult<PasVersion> ImportPasVersion(string userId, DataTable dataTable, PasVersionImport versionImport)
        {
            EntitySingleMessageResult<PasVersion> result = new EntitySingleMessageResult<PasVersion>();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_IMPORTOSATPASVERSIONRETURNVERSION);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@OsatId", versionImport.OsatId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignFamilyId", versionImport.DesignFamilyId.NullToDBNull());
                dataAccess.AddInputParameter("@OriginalFileName", versionImport.File.OriginalFileName.NullToDBNull());
                dataAccess.AddInputParameter("@FileLengthInBytes", versionImport.File.ContentLength.NullToDBNull());
                dataAccess.AddTableValueParameter("@Records", UserDefinedTypes.OSATPASVERSIONRECORDSIMPORT, dataTable);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result.Entity = newPasVersion(reader);
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public PasVersionsListAndImport GetPasVersionsListAndImport(string userId)
        {
            PasVersionsListAndImport result = new PasVersionsListAndImport();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATPASVERSIONSLISTANDIMPORT);
                dataAccess.AddInputParameter("@UserId", userId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set: versions
                    result.Versions = new PasVersions();
                    while (reader.Read())
                    {
                        result.Versions.Add(newPasVersion(reader));
                    }

                    // #2 result set: osats
                    reader.NextResult();
                    result.Osats = new Osats();
                    while (reader.Read())
                    {
                        result.Osats.Add(newOsat(reader));
                    }

                    // #3 result set: design families
                    reader.NextResult();
                    result.DesignFamilies = new DesignFamilies();
                    while (reader.Read())
                    {
                        result.DesignFamilies.Add(newDesignFamily(reader));
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

        private PasVersions getPasVersions(string userId, int? id = null, int? version = null, bool? isActive = null, bool? isPOR = null, int? statusId = null)
        {
            PasVersions result = new PasVersions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATPASVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@Version", version.NullToDBNull());
                dataAccess.AddInputParameter("@IsActive", isActive.NullToDBNull());
                dataAccess.AddInputParameter("@IsPOR", isPOR.NullToDBNull());
                dataAccess.AddInputParameter("@StatusId", statusId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newPasVersion(reader));
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

        public EntitySingleMessageResult<PasVersionDetails> CancelPasVersion(string userId, int id)
        {
            return submitOrCancelPasVersion(StoredProcedures.SP_UPDATEOSATPASVERSIONCANCELEDRETURNDETAILS, userId, id);
        }

        public EntitySingleMessageResult<PasVersionDetails> SubmitPasVersion(string userId, int id)
        {
            return submitOrCancelPasVersion(StoredProcedures.SP_UPDATEOSATPASVERSIONSUBMITTEDRETURNDETAILS, userId, id);
        }

        private EntitySingleMessageResult<PasVersionDetails> submitOrCancelPasVersion(string storedProcedure, string userId, int id)
        {
            EntitySingleMessageResult<PasVersionDetails> result = new EntitySingleMessageResult<PasVersionDetails>()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, storedProcedure);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 and #2 result sets
                        result.Entity = newPasVersionDetails(reader);
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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
        #endregion

        #region qual filters

        public OsatMetaData GetAll(string userId)
        {
            OsatMetaData results = new OsatMetaData();

            results.Products = new Products();
            results.VersionNames = new VersionNames();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GetOsatBulkUpdateMetaData);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Products.Add(newProduct(reader));
                    }
                    reader.NextResult();
                    while (reader.Read())
                    {
                        VersionName name = new VersionName();
                        name = newProductVersion(reader);
                        int index = results.VersionNames.FindIndex(item => item.VName == name.VName);
                        if (index == -1)
                            results.VersionNames.Add(name);
                    }

                    results.Osats = new Osats();
                    reader.NextResult();
                    while (reader.Read())
                    {
                        results.Osats.Add(newOsat(reader));
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

        private Product newProduct(IDataRecord record)
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
                MixType = new MixType()
                {
                    Id = record["MixTypeId"].ToNullableIntSafely(),
                    Name = record["MixTypeName"].ToStringSafely(),
                    Abbreviation = record["MixTypeAbbreviation"].ToStringSafely()
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
            };
        }


        private VersionName newProductVersion(IDataRecord record)
        {
            return new VersionName()
            {
                Id = record["Id"].ToIntegerSafely(),
                Osatid = record["OsatId"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                VName = record["VersionName"].ToStringSafely(),
                StatusId = record["StatusId"].ToIntegerSafely(),
                VersionId = record["VersionId"].ToIntegerSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                ImportId = record["ImportId"].ToIntegerSafely(),
            };
        }

        public Dictionary<int, string> GetDesignsInBulkUpdate(string userId)
        {
            ISqlDataAccess dataAccess = null;
            var result = new Dictionary<int, string>();
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETDESIGNSINBULKUPDATE);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(reader["Id"].ToIntegerSafely(), reader["Name"].ToStringSafely());
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


        public List<OsatImportedBuildCriteria> GetOsatBuildCriteriaSetStatusForBulkUpdateImport(DataSet dataSet, int osatId)
        {
            var results = new List<OsatImportedBuildCriteria>();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIASETSTATUSFORBULKUPDATEIMPORT);
                dataAccess.AddInputParameter("@OsatId", osatId.NullToDBNull());
                dataAccess.AddTableValueParameter("@Groups", UserDefinedTypes.OSATQFIMPORTGROUPS, dataSet.Tables["Groups"]);
                dataAccess.AddTableValueParameter("@Criterias", UserDefinedTypes.OSATQFIMPORTCRITERIAS, dataSet.Tables["Criterias"]);
                dataAccess.AddTableValueParameter("@Attributes", UserDefinedTypes.OSATQFIMPORTATTRIBUTES, dataSet.Tables["Attributes"]);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        results.Add(new OsatImportedBuildCriteria
                        {
                            BuildCombinationId = reader["BuildCombinationId"].ToIntegerSafely(),
                            BuildCriteriaName = reader["BuildCriteriaName"].ToStringSafely(),
                            DeviceName = reader["DeviceName"].ToStringSafely(),
                            PartNumberDecode = reader["PartNumberDecode"].ToStringSafely()
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                ;throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return results;
        }



        public EntitySingleMessageResult<int> CreateOsatBuildCriteriaSetBulkUpdateImports(string userId, int designId, string fileName, string currentFile, int fileLengthInBytes, DataSet dataSet, int osatid)
        {
            EntitySingleMessageResult<int> result = new EntitySingleMessageResult<int>()
            {
                Succeeded = false
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEOSATBUILDCRITERIASETBULKUPDATEIMPORT);
                dataAccess.AddOutputParameter("@Id", DbType.Int32);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", designId.NullToDBNull());
                dataAccess.AddInputParameter("@OsatId", osatid.NullToDBNull());
                dataAccess.AddInputParameter("@FileName", fileName.NullToDBNull());
                dataAccess.AddInputParameter("@CurrentFile", currentFile.NullToDBNull());
                dataAccess.AddInputParameter("@FileLengthInBytes", fileLengthInBytes.NullToDBNull());
                dataAccess.AddTableValueParameter("@Groups", UserDefinedTypes.OSATQFIMPORTGROUPS, dataSet.Tables["Groups"]);
                dataAccess.AddTableValueParameter("@GroupFields", UserDefinedTypes.OSATQFIMPORTGROUPFIELDS, dataSet.Tables["GroupFields"]);
                dataAccess.AddTableValueParameter("@Criterias", UserDefinedTypes.OSATQFIMPORTCRITERIAS, dataSet.Tables["Criterias"]);
                dataAccess.AddTableValueParameter("@Attributes", UserDefinedTypes.OSATQFIMPORTATTRIBUTES, dataSet.Tables["Attributes"]);
                
                if (dataAccess.Execute())
                {
                    result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                    result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
                    result.Entity = dataAccess.GetOutPutParameterValue("@Id").ToIntegerSafely();
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

        private OsatBuildCriteriaSetBulkUpdateImportRecord newOsatBuildCriteriaSetBulkUpdateImportRecord(IDataReader reader)
        {
            return new OsatBuildCriteriaSetBulkUpdateImportRecord()
            {
                Id = reader["Id"].ToIntegerSafely(),
                ImportId = reader["ImportId"].ToIntegerSafely(),
                BuildCriteriaSetId = reader["BuildCriteriaSetId"].ToIntegerSafely(),
                BuildCombinationId = reader["BuildCombinationId"].ToIntegerSafely(),
                Version = reader["Version"].ToIntegerSafely(),
                DesignId = reader["DesignId"].ToIntegerSafely(),
                DesignFamilyId = reader["DesignFamilyId"].ToIntegerSafely(),
                DeviceName = reader["DeviceName"].ToStringSafely(),
                PartNumberDecode = reader["PartNumberDecode"].ToStringSafely(),
                IntelLevel1PartNumber = reader["IntelLevel1PartNumber"].ToStringSafely(),
                IntelProdName = reader["IntelProdName"].ToStringSafely(),
                Attribute = reader["Attribute"].ToStringSafely(),
                NewValue = reader["NewValue"].ToStringSafely(),
                OldValue = reader["OldValue"].ToStringSafely()
            };
        }

        public EntitySingleMessageResult<QualFilterImport> CreateQualFilterImport(string userId, string filename, int fileLengthInBytes, DataSet dataset)
        {
            EntitySingleMessageResult<QualFilterImport> result = new EntitySingleMessageResult<QualFilterImport>()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEOSATQUALFILTERIMPORTANDRETURN);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@FileName", filename.NullToDBNull());
                dataAccess.AddInputParameter("@FileLengthInBytes", fileLengthInBytes.NullToDBNull());
                dataAccess.AddTableValueParameter("@Groups", UserDefinedTypes.OSATQFIMPORTGROUPS, dataset.Tables["Groups"]);
                dataAccess.AddTableValueParameter("@GroupFields", UserDefinedTypes.OSATQFIMPORTGROUPFIELDS, dataset.Tables["GroupFields"]);
                dataAccess.AddTableValueParameter("@Criterias", UserDefinedTypes.OSATQFIMPORTCRITERIAS, dataset.Tables["Criterias"]);
                dataAccess.AddTableValueParameter("@Attributes", UserDefinedTypes.OSATQFIMPORTATTRIBUTES, dataset.Tables["Attributes"]);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result.Entity = newQualFilterImport(reader);
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public List<OsatBuildCriteriaSetBulkUpdateChangeDTO> GetOsatBuildCriteriaSetBulkUpdateChanges(long buildCriteriaSetId, int importId)
        {
            var result = new List<OsatBuildCriteriaSetBulkUpdateChangeDTO>();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString,
                    StoredProcedures.SP_GETOSATBUILDCRITERIASETBULKUPDATECHANGES);
                dataAccess.AddInputParameter("@BuildCriteriaSetId", buildCriteriaSetId.NullToDBNull());
                dataAccess.AddInputParameter("@ImportId", importId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new OsatBuildCriteriaSetBulkUpdateChangeDTO
                        {
                            Id = reader["Id"].ToIntegerSafely(),
                            VersionId = reader["Version"].ToIntegerSafely(),
                            AttributeName = reader["Attribute"].ToStringSafely(),
                            NewValue = reader["NewValue"].ToStringSafely(),
                            OldValue = reader["OldValue"].ToStringSafely(),
                            BuildCombinationId = reader["BuildCombinationId"].ToIntegerSafely(),
                            BuildCriteriaSetId = reader["BuildCriteriaSetId"].ToIntegerSafely(),
                            BuildCriteriaOrdinal = reader["BuildCriteriaOrdinal"].ToIntegerSafely(),
                        });
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
        public QualFilter GetQualFilter(string userId, int? designId = null, int? osatId = null)
        {
            QualFilter result = new QualFilter();
            QualFilterRecords records;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATQUALFILTER);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", designId.NullToDBNull());
                dataAccess.AddInputParameter("@OsatId", osatId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set
                    result.Designs = new Products();
                    while (reader.Read())
                    {
                        result.Designs.Add(newDesign(reader));
                    }

                    // #2 result set
                    reader.NextResult();
                    result.Osats = new Osats();
                    while (reader.Read())
                    {
                        result.Osats.Add(newOsat(reader));
                    }

                    // #3 result set
                    reader.NextResult();
                    records = new QualFilterRecords();
                    while (reader.Read())
                    {
                        records.Add(newQualFilterRecord(reader));
                    }
                }
                if (designId.HasValue && result.Designs != null)
                {
                    result.Design = result.Designs.Find(x => x.Id == designId.Value);
                }
                if (osatId.HasValue && result.Osats != null)
                {
                    result.Osat = result.Osats.Find(x => x.Id == osatId.Value);
                }
                QualFilterData data = createQualFilterData(records);
                if (data != null && data.Files != null)
                {
                    result.File = data.Files.FirstOrDefault();
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

        public QualFilterExport GetQualFilterExport(string userId, int id)
        {
            QualFilterExport result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATQUALFILTEREXPORT);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newQualFilterExportFull(reader);
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

        public QualFilterExports GetQualFilterExports(string userId, int? id = null)
        {
            QualFilterExports result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATQUALFILTEREXPORTS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    result = new QualFilterExports();
                    while (reader.Read())
                    {
                        result.Add(newQualFilterExport(reader));
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

        public QualFilterFiles GetQualFilterFiles(string userId, QualFilterRecordsQuery entity)
        {
            return createQualFilterFiles(GetQualFilterRecords(userId, entity));
        }

        public QualFilterImport GetQualFilterImport(string userId, int id)
        {
            return GetQualFilterImports(userId, id: id).FirstOrDefault();
        }

        public QualFilterImportDetails GetQualFilterImportDetails(string userId, int id)
        {
            QualFilterImportDetails result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATQUALFILTERIMPORTDETAILS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newQualFilterImportDetails(reader);
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

        public QualFilterImports GetQualFilterImports(string userId, int? id = null)
        {
            QualFilterImports result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATQUALFILTERIMPORTS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    result = new QualFilterImports();
                    while (reader.Read())
                    {
                        result.Add(newQualFilterImport(reader));
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

        public OsatBuildCriteriaSetBulkImportInfo GetOsatBuildCriteriaSetBulkImportDesignAndVersion(int importId)
        {
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIASETBULKIMPORTDESIGNANDVERSION);
                dataAccess.AddInputParameter("@Id", importId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new OsatBuildCriteriaSetBulkImportInfo
                        {
                            DesignId = reader["DesignId"].ToIntegerSafely(),
                            VersionId = reader["Version"].ToIntegerSafely()
                        };
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

            return new OsatBuildCriteriaSetBulkImportInfo();
        }

        public QualFilterRecords GetQualFilterRecords(string userId, QualFilterRecordsQuery entity)
        {
            QualFilterRecords result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATQUALFILTERRECORDS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@DesignId", entity.DesignId.NullToDBNull());
                dataAccess.AddInputParameter("@OsatId", entity.OsatId.NullToDBNull());
                dataAccess.AddInputParameter("@IncludePublishDisabled", entity.IncludePublishDisabled.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeStatusInReview", entity.IncludeStatusInReview.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeStatusSubmitted", entity.IncludeStatusSubmitted.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeStatusDraft", entity.IncludeStatusDraft.NullToDBNull());
                if (entity.VersionId.HasValue)
                {
                    dataAccess.AddInputParameter("@VersionId", entity.VersionId.NullToDBNull());
                }
                if (entity.StatusId.HasValue)
                {
                    dataAccess.AddInputParameter("@StatusId", entity.StatusId.NullToDBNull());
                }
                if (entity.ImportId.GetValueOrDefault(0) > 0)
                {
                    dataAccess.AddInputParameter("@ImportId", entity.ImportId.NullToDBNull());
                }
                if (entity.IsPOR.HasValue)
                {
                    dataAccess.AddInputParameter("@IsPOR", entity.IsPOR.Value.NullToDBNull());
                }
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    result = new QualFilterRecords();
                    while (reader.Read())
                    {
                        result.Add(newQualFilterRecord(reader));
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


        public List<BuildCriteriaSetConditionsUpdateDto> GetOsatBuildCriteriaConditions(QualFilterRecordsQuery entity)
        {
            var results = new List<BuildCriteriaSetConditionsUpdateDto>();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATBUILDCRITERIACONDITIONS);
                dataAccess.AddInputParameter("@DesignId", entity.DesignId.NullToDBNull());
                dataAccess.AddInputParameter("@OsatId", entity.OsatId.NullToDBNull());
                dataAccess.AddInputParameter("@IncludePublishDisabled", entity.IncludePublishDisabled.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeStatusInReview", entity.IncludeStatusInReview.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeStatusSubmitted", entity.IncludeStatusSubmitted.NullToDBNull());
                dataAccess.AddInputParameter("@IncludeStatusDraft", entity.IncludeStatusDraft.NullToDBNull());
                var currentBuildCriteriaSetId = 0;
                var buildCriteriaSetConditionsUpdateDto = new BuildCriteriaSetConditionsUpdateDto();
                using (var reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read()) // the results are ordered by BuildCriteriaSetId
                    {
                        var buildCriteriaSetId = reader["BuildCriteriaSetId"].ToIntegerSafely();
                        if (currentBuildCriteriaSetId != buildCriteriaSetId)
                        {
                            currentBuildCriteriaSetId = buildCriteriaSetId;
                            if (buildCriteriaSetConditionsUpdateDto.BuildCriteriaSetId > 0)
                            {
                                results.Add(buildCriteriaSetConditionsUpdateDto.Clone());
                            }
                            buildCriteriaSetConditionsUpdateDto = new BuildCriteriaSetConditionsUpdateDto
                                {
                                    BuildCriteriaSetId = currentBuildCriteriaSetId,
                                    BuildCombinationId = reader["BuildCombinationId"].ToIntegerSafely(),
                                    BuildCriteriaId = reader["BuildCriteriaId"].ToIntegerSafely(),
                                    BuildCriteriaSetStatusId = reader["BuildCriteriaSetStatusId"].ToIntegerSafely(),
                                    PackageDieTypeName = reader["PackageDieTypeName"].ToStringSafely(),
                                    BuildCriteriaName = reader["BuildCriteriaName"].ToStringSafely(),
                                    PartNumberDecode = reader["PartNumberDecode"].ToStringSafely(),
                                    DeviceName = reader["DeviceName"].ToStringSafely()
                            };
                        }
                        var attributeId = reader["AttributeId"].ToLongSafely();
                        if (buildCriteriaSetConditionsUpdateDto.Conditions.All(x => x.Id != attributeId))
                        {
                            buildCriteriaSetConditionsUpdateDto.Conditions.Add(new BuildCriteriaCondition
                            {
                                Id = attributeId,
                                ComparisonOperation = new ComparisonOperation
                                {
                                    Id = reader["AttributeComparisonOperationId"].ToIntegerSafely(),
                                    Key = reader["AttributeComparisonOperationKey"].ToStringSafely()
                                },
                                Value = reader["AttributeValue"].ToStringSafely(),
                                AttributeType = new AttributeType
                                {
                                    Name = reader["AttributeTypeName"].ToStringSafely(),
                                    Id = reader["AttributeTypeId"].ToIntegerSafely()
                                }
                            });
                        }

                    }

                    if (results.All(x => x.BuildCriteriaSetId != buildCriteriaSetConditionsUpdateDto.BuildCriteriaSetId && buildCriteriaSetConditionsUpdateDto.BuildCriteriaSetId >0))
                    {
                        results.Add(buildCriteriaSetConditionsUpdateDto.Clone());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            {
                dataAccess?.Close();
            }
            return results;
        }
        
        public QualFilterExportsListAndPublish GetQualFilterExportsListAndPublish(string userId)
        {
            QualFilterExportsListAndPublish result = new QualFilterExportsListAndPublish();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETOSATQUALFILTERPUBLISH);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // #1 result set
                    result.Designs = new Products();
                    while (reader.Read())
                    {
                        result.Designs.Add(newDesign(reader));
                    }

                    // #2 result set
                    reader.NextResult();
                    result.Osats = new Osats();
                    while (reader.Read())
                    {
                        result.Osats.Add(newOsat(reader));
                    }

                    // #3 result set
                    reader.NextResult();
                    result.Exports = new QualFilterExports();
                    while (reader.Read())
                    {
                        result.Exports.Add(newQualFilterExport(reader));
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

        public EntitySingleMessageResult<QualFilterExport> CreateQualFilterExport(string userId, QualFilterRecordsQueryCustom recordsQuery = null)
        {
            EntitySingleMessageResult<QualFilterExport> result = new EntitySingleMessageResult<QualFilterExport>();
            DataTable designIds = newTableInts(recordsQuery?.DesignIds ?? new int[0]);
            DataTable osatIds = newTableInts(recordsQuery?.OsatIds ?? new int[0]);
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEOSATQUALFILTEREXPORTANDRETURN);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddTableValueParameter("@DesignIds", UserDefinedTypes.INTS, designIds);
                dataAccess.AddTableValueParameter("@OsatIds", UserDefinedTypes.INTS, osatIds);
                dataAccess.AddInputParameter("@Comprehensive", (recordsQuery == null).NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result.Entity = newQualFilterExportFull(reader);
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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





        public SingleMessageResult UpdateQualFilterExportDelivered(string userId, int id)
        {
            SingleMessageResult result = new SingleMessageResult()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATQUALFILTEREXPORTDELIVERED);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public SingleMessageResult UpdateQualFilterExportGenerated(string userId, int id, string filename, int fileLengthInBytes)
        {
            SingleMessageResult result = new SingleMessageResult()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATQUALFILTEREXPORTGENERATED);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@FileName", filename.NullToDBNull());
                dataAccess.AddInputParameter("@FileLengthInBytes", fileLengthInBytes.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public SingleMessageResult UpdateQualFilterImportCanceled(string userId, int id)
        {
            SingleMessageResult result = new SingleMessageResult()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATQUALFILTERIMPORTCANCELED);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public EntitySingleMessageResult<QualFilterImportDetails> UpdateQualFilterImportCanceledReturnDetails(string userId, int id)
        {
            EntitySingleMessageResult<QualFilterImportDetails> result = new EntitySingleMessageResult<QualFilterImportDetails>()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATQUALFILTERIMPORTCANCELEDRETURNDETAILS);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result.Entity = newQualFilterImportDetails(reader);
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public SingleMessageResult UpdateQualFilterImportPor(string userId, int id)
        {
            SingleMessageResult result = new SingleMessageResult()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATQUALFILTERIMPORTPOR);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public EntitySingleMessageResult<QualFilterImportDetails> UpdateQualFilterImportPorReturnDetails(string userId, int id)
        {
            EntitySingleMessageResult<QualFilterImportDetails> result = new EntitySingleMessageResult<QualFilterImportDetails>()
            {
                Succeeded = false,
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEOSATQUALFILTERIMPORTPORRETURNDETAILS);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result.Entity = newQualFilterImportDetails(reader);
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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
        #endregion

        #region entity data binders
        private DataTable createTableBuildCriterias()
        {
            var result = new DataTable();
            result.Columns.Add("Index", typeof(int));
            result.Columns.Add("Name", typeof(string));
            return result;
        }

        private void populateRowBuildCriterias(DataRow row, BuildCriteriaCreateDto entity, int index)
        {
            row["Index"] = index;
            row["Name"] = entity.Name.NullToDBNull();
        }

        private DataTable CreateTablesBuildCriteriasForBulkUpdate(BuildCriteriaConditions conditions)
        {
            var buildCriteriaConditions = CreateTableConditionsForBulkUpdate();
            if (conditions == null) return buildCriteriaConditions;
            foreach (var condition in conditions)
            {
                var rowCondition = buildCriteriaConditions.NewRow();
                PopulateRowConditionsForBulkUpdate(rowCondition, condition);
                buildCriteriaConditions.Rows.Add(rowCondition);
            }
            buildCriteriaConditions.AcceptChanges();
            return buildCriteriaConditions;
        }

        private static DataTable CreateTableConditionsForBulkUpdate()
        {
            var result = new DataTable();
            result.Columns.Add("Id", typeof(int));
            result.Columns.Add("AttributeTypeName", typeof(string));
            result.Columns.Add("ComparisonOperationKey", typeof(string));
            result.Columns.Add("Value", typeof(string));
            return result;
        }

        private static void PopulateRowConditionsForBulkUpdate(DataRow row, BuildCriteriaCondition entity)
        {
            row["Id"] = entity.Id;
            row["AttributeTypeName"] = entity.AttributeType.Name.NullToDBNull();
            row["ComparisonOperationKey"] = entity.ComparisonOperation.Key.NullToDBNull();
            row["Value"] = entity.Value.NullToDBNull();
        }

        private (DataTable BuildCriterias, DataTable BuildCriteriaConditions) createTablesBuildCriterias(BuildCriteriasCreateDto entities)
        {
            DataTable buildCriterias = createTableBuildCriterias();
            DataTable buildCriteriaConditions = createTableConditions();
            if (entities != null)
            {
                int buildCriteriaIndex = 0;
                int buildCriteriaConditionIndex = 0;
                foreach (var entity in entities)
                {
                    var row = buildCriterias.NewRow();
                    populateRowBuildCriterias(row, entity, ++buildCriteriaIndex);
                    buildCriterias.Rows.Add(row);
                    if (entity.Conditions != null)
                    {
                        foreach (var condition in entity.Conditions)
                        {
                            var rowCondition = buildCriteriaConditions.NewRow();
                            populateRowConditions(rowCondition, condition, ++buildCriteriaConditionIndex, buildCriteriaIndex);
                            buildCriteriaConditions.Rows.Add(rowCondition);
                        }
                    }
                }
                buildCriterias.AcceptChanges();
                buildCriteriaConditions.AcceptChanges();
            }
            return (buildCriterias, buildCriteriaConditions);
        }

        private DataTable createTableConditions()
        {
            var result = new DataTable();
            result.Columns.Add("Index", typeof(int));
            result.Columns.Add("BuildCriteriaIndex", typeof(int));
            result.Columns.Add("AttributeTypeName", typeof(string));
            result.Columns.Add("ComparisonOperationKey", typeof(string));
            result.Columns.Add("Value", typeof(string));
            return result;
        }

        private void populateRowConditions(DataRow row, BuildCriteriaConditionCreateDto entity, int conditionIndex, int buildCriteriaIndex)
        {
            row["Index"] = conditionIndex;
            row["BuildCriteriaIndex"] = buildCriteriaIndex.NullToDBNull();
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

        private BuildCombination newBuildCombination(IDataRecord record, string prefix = null)
        {
            return new BuildCombination()
            {
                Id = record["Id".AddPrefix(prefix)].ToIntegerSafely(),
                IsActive = record["IsActive".AddPrefix(prefix)].ToStringSafely().ToBooleanSafely(),
                Design = new Product()
                {
                    Id = record["DesignId".AddPrefix(prefix)].ToIntegerSafely(),
                    Name = record["DesignName".AddPrefix(prefix)].ToStringSafely(),
                    DesignFamily = new DesignFamily()
                    {
                        Id = record["DesignFamilyId".AddPrefix(prefix)].ToIntegerSafely(),
                        Name = record["DesignFamilyName".AddPrefix(prefix)].ToStringSafely()
                    },
                    IsActive = record["DesignIsActive".AddPrefix(prefix)].ToStringSafely().ToBooleanSafely(),
                    CreatedBy = record["DesignCreatedBy".AddPrefix(prefix)].ToStringSafely(),
                    CreatedOn = record["DesignCreatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["DesignUpdatedBy".AddPrefix(prefix)].ToStringSafely(),
                    UpdatedOn = record["DesignUpdatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc()
                },
                PartUseType = new PartUseType()
                {
                    Id = record["DesignId".AddPrefix(prefix)].ToIntegerSafely(),
                    Name = record["PartUseTypeName".AddPrefix(prefix)].ToStringSafely(),
                    Abbreviation = record["PartUseTypeAbbreviation".AddPrefix(prefix)].ToStringSafely(),
                },
                MaterialMasterField = record["MaterialMasterField".AddPrefix(prefix)].ToStringSafely(),
                IntelLevel1PartNumber = record["IntelLevel1PartNumber".AddPrefix(prefix)].ToStringSafely(),
                IntelProdName = record["IntelProdName".AddPrefix(prefix)].ToStringSafely(),
                IntelMaterialPn = record["IntelMaterialPn".AddPrefix(prefix)].ToStringSafely(),
                AssyUpi = record["AssyUpi".AddPrefix(prefix)].ToStringSafely(),
                DeviceName = record["DeviceName".AddPrefix(prefix)].ToStringSafely(),
                PorBuildCriteriaSetId = record["PorBuildCriteriaSetId".AddPrefix(prefix)].ToNullableLongSafely(),
                Mpp = record["Mpp".AddPrefix(prefix)].ToStringSafely(),
                CreatedBy = record["CreatedBy".AddPrefix(prefix)].ToStringSafely(),
                CreatedOn = record["CreatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy".AddPrefix(prefix)].ToStringSafely(),
                UpdatedOn = record["UpdatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc(),
                IsPublishable = record["IsPublishable".AddPrefix(prefix)].ToStringSafely().ToBooleanSafely(),
                PublishDisabledBy = record["PublishDisabledBy".AddPrefix(prefix)].ToStringSafely(),
                PublishDisabledOn = record["PublishDisabledOn".AddPrefix(prefix)].ToNullableDateTimeSafely().SpecifyKindUtc(),
                OsatId = record["OsatId".AddPrefix(prefix)].ToIntegerSafely(),
                OsatName = record["OsatName".AddPrefix(prefix)].ToStringSafely(),
            };
        }

        private BuildCriteriaSet newBuildCriteriaSet(IDataRecord record, string prefix = null)
        {
            return new BuildCriteriaSet()
            {
                Id = record["Id".AddPrefix(prefix)].ToLongSafely(),
                Version = record["Version".AddPrefix(prefix)].ToIntegerSafely(),
                IsPOR = record["IsPOR".AddPrefix(prefix)].ToStringSafely().ToBooleanSafely(),
                IsActive = record["IsActive".AddPrefix(prefix)].ToStringSafely().ToBooleanSafely(),
                Status = new Status()
                {
                    Id = record["StatusId".AddPrefix(prefix)].ToIntegerSafely(),
                    Name = record["StatusName".AddPrefix(prefix)].ToStringSafely(),
                },
                CreatedBy = record["CreatedBy".AddPrefix(prefix)].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName".AddPrefix(prefix)].ToStringSafely(),
                CreatedOn = record["CreatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy".AddPrefix(prefix)].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName".AddPrefix(prefix)].ToStringSafely(),
                UpdatedOn = record["UpdatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc(),
                EffectiveOn = record["EffectiveOn".AddPrefix(prefix)].ToNullableDateTimeSafely().SpecifyKindUtc(),
                BuildCombination = newBuildCombination(record, prefix: "BuildCombination".AddPrefix(prefix)),
            };
        }

        private BuildCriteria newBuildCriteria(IDataRecord record, string prefix = null)
        {
            return new BuildCriteria()
            {
                Id = record["Id".AddPrefix(prefix)].ToLongSafely(),
                BuildCriteriaSetId = record["BuildCriteriaSetId".AddPrefix(prefix)].ToLongSafely(),
                Ordinal = record["Ordinal".AddPrefix(prefix)].ToIntegerSafely(),
                Name = record["Name".AddPrefix(prefix)].ToStringSafely(),
                CreatedBy = record["CreatedBy".AddPrefix(prefix)].ToStringSafely(),
                CreatedOn = record["CreatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy".AddPrefix(prefix)].ToStringSafely(),
                UpdatedOn = record["UpdatedOn".AddPrefix(prefix)].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private BuildCriteriaSetDetails newBuildCriteriaSetDetails(IDataReader reader)
        {
            BuildCriteriaSetDetails result = new BuildCriteriaSetDetails();

            // #1 result set: build criteria set
            result.BuildCriteriaSet = newBuildCriteriaSet(reader);

            // #2 result set: build criterias
            result.BuildCriteriaSet.BuildCriterias = new BuildCriterias();
            reader.NextResult();
            while (reader.Read())
            {
                result.BuildCriteriaSet.BuildCriterias.Add(newBuildCriteria(reader));
            }

            // #3 result set: build criteria conditions
            reader.NextResult();
            while (reader.Read())
            {
                BuildCriteriaCondition condition = newBuildCriteriaCondition(reader);
                BuildCriteria buildCriteria = result.BuildCriteriaSet.BuildCriterias.Find(x => x.Id == condition.BuildCriteriaId);
                if (buildCriteria != null)
                {
                    if (buildCriteria.Conditions == null) buildCriteria.Conditions = new BuildCriteriaConditions();
                    buildCriteria.Conditions.Add(condition);
                }
            }

            // #4 result set: build criteria set comments
            result.BuildCriteriaSet.Comments = new BuildCriteriaSetComments();
            reader.NextResult();
            while (reader.Read())
            {
                result.BuildCriteriaSet.Comments.Add(newBuildCriteriaSetComment(reader));
            }

            // #5 result set: build criteria sets for comparison purposes
            result.BuildCriteriaSetsCompare = new BuildCriteriaSets();
            reader.NextResult();
            while (reader.Read())
            {
                result.BuildCriteriaSetsCompare.Add(newBuildCriteriaSet(reader));
            }

            // #6 result set: comparison results
            result.ComparisonResults = new BuildCriteriaSetComparisonResults();
            reader.NextResult();
            while (reader.Read())
            {
                result.ComparisonResults.Add(newBuildCriteriaComparisonResult(reader));
            }

            // #7 result set: build criteria set compared against
            reader.NextResult();
            if (reader.Read())
            {
                result.BuildCriteriaSetCompare = newBuildCriteriaSet(reader);
                result.BuildCriteriaSetCompare.BuildCriterias = new BuildCriterias();
            }

            // #8 result set: build criterias compared against
            reader.NextResult();
            if (result.BuildCriteriaSetCompare != null)
            {
                while (reader.Read())
                {
                    result.BuildCriteriaSetCompare.BuildCriterias.Add(newBuildCriteria(reader));
                }
            }

            // #9 result set: build criteria conditions compared against
            reader.NextResult();
            if (result.BuildCriteriaSetCompare != null)
            {
                while (reader.Read())
                {
                    BuildCriteriaCondition condition = newBuildCriteriaCondition(reader);
                    BuildCriteria buildCriteria = result.BuildCriteriaSetCompare.BuildCriterias.Find(x => x.Id == condition.BuildCriteriaId);
                    if (buildCriteria != null)
                    {
                        if (buildCriteria.Conditions == null) buildCriteria.Conditions = new BuildCriteriaConditions();
                        buildCriteria.Conditions.Add(condition);
                    }
                }
            }

            // #10 through #13 result sets
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

        private BuildCriteriaSetComparisonResult newBuildCriteriaComparisonResult(IDataRecord record)
        {
            return new BuildCriteriaSetComparisonResult()
            {
                EntityType = record["EntityType"].ToStringSafely(),
                BuildCombinationId = record["BuildCombinationId"].ToNullableIntSafely(),
                BuildCriteriaOrdinal = record["BuildCriteriaOrdinal"].ToNullableIntSafely(),
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

        private BuildCriteriaSetComment newBuildCriteriaSetComment(IDataRecord record)
        {
            return new BuildCriteriaSetComment()
            {
                Id = record["Id"].ToLongSafely(),
                BuildCriteriaSetId = record["BuildCriteriaSetId"].ToIntegerSafely(),
                Text = record["Text"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private BuildCriteriaSetTemplate newBuildCriteriaSetTemplate(IDataRecord record)
        {
            return new BuildCriteriaSetTemplate()
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

        private BuildCriteriaTemplate newBuildCriteriaTemplate(IDataRecord record)
        {
            return new BuildCriteriaTemplate()
            {
                Id = record["Id"].ToIntegerSafely(),
                SetTemplateId = record["SetTemplateId"].ToIntegerSafely(),
                Ordinal = record["Ordinal"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            };
        }

        private BuildCriteriaTemplateCondition newBuildCriteriaTemplateCondition(IDataRecord record)
        {
            return new BuildCriteriaTemplateCondition()
            {
                Id = record["Id"].ToIntegerSafely(),
                TemplateId = record["TemplateId"].ToIntegerSafely(),
                SetTemplateId = record["SetTemplateId"].ToIntegerSafely(),
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

        private DesignFamily newDesignFamily(IDataRecord record)
        {
            return new DesignFamily()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            };
        }

        private PasVersionImportMessage newPasVersionImportMessage(IDataRecord record)
        {
            string fieldName = record["FieldName"].ToStringSafely();
            string fieldNameDisplay = ImportSpecifications.OsatPas.Field(fieldName)?.DisplayName ?? fieldName;
            return new PasVersionImportMessage()
            {
                Id = record["Id"].ToLongSafely(),
                VersionId = record["VersionId"].ToIntegerSafely(),
                RecordId = record["RecordId"].ToLongSafely(),
                RecordNumber = record["RecordNumber"].ToNullableIntSafely(),
                MessageType = record["MessageType"].ToStringSafely(),
                FieldName = fieldNameDisplay,
                Message = record["Message"].ToStringSafely(),
            };
        }

        private PasVersion newPasVersion(IDataRecord record)
        {
            return new PasVersion()
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
                Combination = new PasCombination()
                {
                    Id = record["CombinationId"].ToIntegerSafely(),
                    Osat = new Osat()
                    {
                        Id = record["CombinationOsatId"].ToIntegerSafely(),
                        Name = record["CombinationOsatName"].ToStringSafely(),
                        CreatedBy = record["CombinationOsatCreatedBy"].ToStringSafely(),
                        CreatedOn = record["CombinationOsatCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                        UpdatedBy = record["CombinationOsatUpdatedBy"].ToStringSafely(),
                        UpdatedOn = record["CombinationOsatUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    },
                    DesignFamily = new DesignFamily()
                    {
                        Id = record["CombinationDesignFamilyId"].ToIntegerSafely(),
                        Name = record["CombinationDesignFamilyName"].ToStringSafely(),
                    },
                    CreatedBy = record["CombinationCreatedBy"].ToStringSafely(),
                    CreatedOn = record["CombinationCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["CombinationUpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["CombinationUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                OriginalFileName = record["OriginalFileName"].ToStringSafely(),
                FileLengthInBytes = record["FileLengthInBytes"].ToIntegerSafely(),
            };
        }

        private PasVersionDetails newPasVersionDetails(IDataReader reader)
        {
            PasVersionDetails result = new PasVersionDetails();

            // #1 result set: version
            result.Version = newPasVersion(reader);
            result.Version.Records = new PasVersionRecords();
            result.ImportMessages = new PasVersionImportMessages();

            // #2 result set: version records
            reader.NextResult();
            while (reader.Read())
            {
                result.Version.Records.Add(newPasVersionRecord(reader));
            }

            // #3 result set: import messages
            reader.NextResult();
            while (reader.Read())
            {
                result.ImportMessages.Add(newPasVersionImportMessage(reader));
            }

            return result;
        }

        private Osat newOsat(IDataRecord record)
        {
            return new Osat()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private PasVersionRecord newPasVersionRecord(IDataRecord record)
        {
            return new PasVersionRecord()
            {
                Id = record["Id"].ToLongSafely(),
                RecordNumber = record["RecordNumber"].ToIntegerSafely(),
                ProductGroup = record["ProductGroup"].ToStringSafely(),
                Project = record["Project"].ToStringSafely(),
                IntelProdName = record["IntelProdName"].ToStringSafely(),
                IntelLevel1PartNumber = record["IntelLevel1PartNumber"].ToStringSafely(),
                Line1TopSideMarking = record["Line1TopSideMarking"].ToStringSafely(),
                CopyrightYear = record["CopyrightYear"].ToStringSafely(),
                SpecNumberField = record["SpecNumberField"].ToStringSafely(),
                MaterialMasterField = record["MaterialMasterField"].ToStringSafely(),
                MaxQtyPerMedia = record["MaxQtyPerMedia"].ToStringSafely(),
                Media = record["Media"].ToStringSafely(),
                RoHsCompliant = record["RoHsCompliant"].ToStringSafely(),
                LotNo = record["LotNo"].ToStringSafely(),
                FullMediaReqd = record["FullMediaReqd"].ToStringSafely(),
                SupplierPartNumber = record["SupplierPartNumber"].ToStringSafely(),
                IntelMaterialPn = record["IntelMaterialPn"].ToStringSafely(),
                TestUpi = record["TestUpi"].ToStringSafely(),
                PgTierAndSpeedInfo = record["PgTierAndSpeedInfo"].ToStringSafely(),
                AssyUpi = record["AssyUpi"].ToStringSafely(),
                DeviceName = record["DeviceName"].ToStringSafely(),
                Mpp = record["Mpp"].ToStringSafely(),
                SortUpi = record["SortUpi"].ToStringSafely(),
                ReclaimUpi = record["ReclaimUpi"].ToStringSafely(),
                ReclaimMm = record["ReclaimMm"].ToStringSafely(),
                ProductNaming = record["ProductNaming"].ToStringSafely(),
                TwoDidApproved = record["TwoDidApproved"].ToStringSafely(),
                TwoDidStartedWw = record["TwoDidStartedWw"].ToStringSafely(),
                Did = record["Did"].ToStringSafely(),
                Group = record["Group"].ToStringSafely(),
                Note = record["Note"].ToStringSafely(),
            };
        }

        private QualFilterImport newQualFilterImport(IDataRecord record)
        {
            return new QualFilterImport()
            {
                Id = record["Id"].ToIntegerSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                FileName = record["FileName"].ToStringSafely(),
                FileLengthInBytes = record["FileLengthInBytes"].ToIntegerSafely(),
                MessageErrorsExist = record["MessageErrorsExist"].ToStringSafely().ToBooleanSafely(),
                AllowBuildCriteriaActions = record["AllowBuildCriteriaActions"].ToStringSafely().ToBooleanSafely(),
                Design = new Product()
                {
                    Id = record["DesignId"].ToIntegerSafely(),
                    Name = record["DesignName"].ToStringSafely(),
                    DesignFamily = new DesignFamily()
                    {
                        Id = record["DesignFamilyId"].ToIntegerSafely(),
                        Name = record["DesignFamilyName"].ToStringSafely(),
                    },
                    IsActive = record["DesignIsActive"].ToStringSafely().ToBooleanSafely(),
                    MixType = new MixType()
                    {
                        Id = record["DesignMixTypeId"].ToIntegerSafely(),
                        Name = record["DesignMixTypeName"].ToStringSafely(),
                        Abbreviation = record["DesignMixTypeAbbreviation"].ToStringSafely(),
                    },
                    CreatedBy = record["CreatedBy"].ToStringSafely(),
                    CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                }
            };
        }

        private QualFilterImportBuildCriteria newQualFilterImportBuildCriteria(IDataRecord record)
        {
            return new QualFilterImportBuildCriteria()
            {
                Id = record["Id"].ToLongSafely(),
                ImportId = record["ImportId"].ToIntegerSafely(),
                GroupIndex = record["GroupIndex"].ToNullableIntSafely(),
                GroupSourceIndex = record["GroupSourceIndex"].ToNullableIntSafely(),
                CriteriaIndex = record["CriteriaIndex"].ToNullableIntSafely(),
                CriteriaSourceIndex = record["CriteriaSourceIndex"].ToNullableIntSafely(),
                BuildCriteria = newBuildCriteria(record, prefix: "BuildCriteria"),
                BuildCriteriaSet = newBuildCriteriaSet(record, prefix: "BuildCriteriaSet"),
            };
        }

        private QualFilterImportDetails newQualFilterImportDetails(IDataReader reader)
        {
            QualFilterImportDetails result = new QualFilterImportDetails();

            // #1 result set: import
            result.Import = newQualFilterImport(reader);

            // #2 result set: import build criterias
            reader.NextResult();
            result.BuildCriterias = new QualFilterImportBuildCriterias();
            while (reader.Read())
            {
                result.BuildCriterias.Add(newQualFilterImportBuildCriteria(reader));
            }

            // #3 result set: import messages
            reader.NextResult();
            result.Messages = new QualFilterImportMessages();
            while (reader.Read())
            {
                result.Messages.Add(newQualFilterImportMessage(reader));
            }

            return result;
        }

        private QualFilterImportMessage newQualFilterImportMessage(IDataRecord record)
        {
            return new QualFilterImportMessage()
            {
                Id = record["Id"].ToIntegerSafely(),
                ImportId = record["ImportId"].ToIntegerSafely(),
                MessageType = record["MessageType"].ToStringSafely(),
                Message = record["Message"].ToStringSafely(),
                GroupIndex = record["GroupIndex"].ToNullableIntSafely(),
                GroupSourceIndex = record["GroupSourceIndex"].ToNullableIntSafely(),
                CriteriaIndex = record["CriteriaIndex"].ToNullableIntSafely(),
                CriteriaSourceIndex = record["CriteriaSourceIndex"].ToNullableIntSafely(),
                GroupFieldIndex = record["GroupFieldIndex"].ToNullableIntSafely(),
                GroupFieldSourceIndex = record["GroupFieldSourceIndex"].ToNullableIntSafely(),
                GroupFieldName = record["GroupFieldName"].ToStringSafely(),
            };
        }

        private QualFilterExport newQualFilterExport(IDataRecord record)
        {
            return new QualFilterExport()
            {
                Id = record["Id"].ToIntegerSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                GeneratedOn = record["GeneratedOn"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                DeliveredOn = record["DeliveredOn"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                FileName = record["FileName"].ToStringSafely(),
                FileLengthInBytes = record["FileLengthInBytes"].ToNullableIntSafely(),
            };
        }

        private QualFilterExport newQualFilterExportFull(IDataReader reader)
        {
            // #1 result set: export
            var result = newQualFilterExport(reader);

            // #2 result set: files
            result.Files = new QualFilterFiles();
            reader.NextResult();
            while (reader.Read())
            {
                result.Files.Add(newQualFilterFile(reader));
            }

            // #3 result set: records
            var records = new QualFilterRecords();
            reader.NextResult();
            while (reader.Read())
            {
                records.Add(newQualFilterRecord(reader));
            }

            foreach (var file in result.Files)
            {
                var fileRecords = records.Where(x => x.ExportFileId == file.Id);
                file.Sheets = createQualFilterSheets(fileRecords);
            }

            return result;
        }

        private QualFilterFile newQualFilterFile(IDataRecord record)
        {
            return new QualFilterFile()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                Osat = new Osat()
                {
                    Id = record["OsatId"].ToIntegerSafely(),
                    Name = record["OsatName"].ToStringSafely(),
                    CreatedBy = record["OsatCreatedBy"].ToStringSafely(),
                    CreatedOn = record["OsatCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["OsatUpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["OsatUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                },
                Design = new Product()
                {
                    Id = record["DesignId"].ToIntegerSafely(),
                    Name = record["DesignName"].ToStringSafely(),
                    IsActive = record["DesignIsActive"].ToStringSafely().ToBooleanSafely(),
                    DesignFamily = new DesignFamily()
                    {
                        Id = record["DesignFamilyId"].ToIntegerSafely(),
                        Name = record["DesignFamilyName"].ToStringSafely(),
                    },
                    CreatedBy = record["DesignCreatedBy"].ToStringSafely(),
                    CreatedOn = record["DesignCreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                    UpdatedBy = record["DesignUpdatedBy"].ToStringSafely(),
                    UpdatedOn = record["DesignUpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedByUserName = record["CreatedByUserName"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedByUserName = record["UpdatedByUserName"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private QualFilterRecord newQualFilterRecord(IDataRecord record)
        {
            return new QualFilterRecord()
            {
                Id = record["Id"].ToLongSafely(),
                ExportId = record["ExportId"].ToIntegerSafely(),
                ExportFileId = record["ExportFileId"].ToIntegerSafely(),
                BuildCombinationIsPublishable = record["BuildCombinationIsPublishable"].ToStringSafely().ToBooleanSafely(),
                BuildCriteriaId = record["BuildCriteriaId"].ToLongSafely(),
                BuildCriteriaSetId = record["BuildCriteriaSetId"].ToLongSafely(),
                BuildCriteriaSetStatus = new Status()
                {
                    Id = record["BuildCriteriaSetStatusId"].ToIntegerSafely(),
                    Name = record["BuildCriteriaSetStatusName"].ToStringSafely(),
                },
                BuildCriteriaOrdinal = record["BuildCriteriaOrdinal"].ToIntegerSafely(),
                OsatId = record["OsatId"].ToIntegerSafely(),
                OsatName = record["OsatName"].ToStringSafely(),
                DesignId = record["DesignId"].ToIntegerSafely(),
                DesignName = record["DesignName"].ToStringSafely(),
                DesignFamilyId = record["DesignFamilyId"].ToIntegerSafely(),
                DesignFamilyName = record["DesignFamilyName"].ToStringSafely(),
                PackageDieTypeId = record["PackageDieTypeId"].ToIntegerSafely(),
                PackageDieTypeName = record["PackageDieTypeName"].ToStringSafely(),
                FilterDescription = record["FilterDescription"].ToStringSafely(),
                DeviceName = record["DeviceName"].ToStringSafely(),
                PartNumberDecode = record["PartNumberDecode"].ToStringSafely(),
                IntelLevel1PartNumber = record["IntelLevel1PartNumber"].ToStringSafely(),
                IntelProdName = record["IntelProdName"].ToStringSafely(),
                MaterialMasterField = record["MaterialMasterField"].ToStringSafely(),
                AssyUpi = record["AssyUpi"].ToStringSafely(),
                IsEngineeringSample = record["IsEngineeringSample"].ToStringSafely().ToBooleanSafely(),
                AttributeValues = new QualFilterAttributeValues()
                {
                    apo_number = record["av_apo_number"].ToStringSafely(),
                    app_restriction = record["av_app_restriction"].ToStringSafely(),
                    ate_tape_revision = record["av_ate_tape_revision"].ToStringSafely(),
                    burn_flow = record["av_burn_flow"].ToStringSafely(),
                    burn_tape_revision = record["av_burn_tape_revision"].ToStringSafely(),
                    cell_revision = record["av_cell_revision"].ToStringSafely(),
                    cmos_revision = record["av_cmos_revision"].ToStringSafely(),
                    country_of_assembly = record["av_country_of_assembly"].ToStringSafely(),
                    custom_testing_reqd = record["av_custom_testing_reqd"].ToStringSafely(),
                    design_id = record["av_design_id"].ToStringSafely(),
                    device = record["av_device"].ToStringSafely(),
                    fab_conv_id = record["av_fab_conv_id"].ToStringSafely(),
                    fab_excr_id = record["av_fab_excr_id"].ToStringSafely(),
                    fabrication_facility = record["av_fabrication_facility"].ToStringSafely(),
                    lead_count = record["av_lead_count"].ToStringSafely(),
                    major_probe_prog_rev = record["av_major_probe_prog_rev"].ToStringSafely(),
                    marketing_speed = record["av_marketing_speed"].ToStringSafely(),
                    non_shippable = record["av_non_shippable"].ToStringSafely(),
                    num_array_decks = record["av_num_array_decks"].ToStringSafely(),
                    num_flash_ce_pins = record["av_num_flash_ce_pins"].ToStringSafely(),
                    num_io_channels = record["av_num_io_channels"].ToStringSafely(),
                    number_of_die_in_pkg = record["av_number_of_die_in_pkg"].ToStringSafely(),
                    pgtier = record["av_pgtier"].ToStringSafely(),
                    prb_conv_id = record["av_prb_conv_id"].ToStringSafely(),
                    product_grade = record["av_product_grade"].ToStringSafely(),
                    reticle_wave_id = record["av_reticle_wave_id"].ToStringSafely(),
                }
            };
        }
        #endregion

        #region datatables
        private static DataTable newTableInts()
        {
            var result = new DataTable();
            result.Columns.Add("Value", typeof(int));
            return result;
        }

        private static DataTable newTableInts(int[] values)
        {
            var result = newTableInts();
            populateTableInts(result, values);
            return result;
        }

        private static void populateTableInts(DataTable table, int[] values)
        {
            foreach (var value in values)
            {
                var row = table.NewRow();
                populateRowInt(row, value);
                table.Rows.Add(row);
            }
            table.AcceptChanges();
        }

        private static void populateRowInt(DataRow row, int value)
        {
            row["Value"] = value;
        }
        #endregion

        #region helpers
        private QualFilterData createQualFilterData(QualFilterRecords records)
        {
            return new QualFilterData()
            {
                Files = createQualFilterFiles(records)
            };
        }

        private static QualFilterFiles createQualFilterFiles(QualFilterRecords records)
        {
            var result = new QualFilterFiles();
            if (records != null)
            {
                foreach (var fileGroup in records.Select(x => new { x.OsatId, x.OsatName, x.DesignFamilyId, x.DesignFamilyName, x.DesignId, x.DesignName }).Distinct())
                {
                    var file = new QualFilterFile()
                    {
                        Name = string.Format("{0}_{1}_QF_{2}_{3}.xlsx", fileGroup.DesignFamilyName, fileGroup.DesignName, fileGroup.OsatName, DateTime.UtcNow.ToString("yyyyMMddHHmmss")),
                        Osat = new Osat()
                        {
                            Id = fileGroup.OsatId,
                            Name = fileGroup.OsatName,
                        },
                        Design = new Product()
                        {
                            Id = fileGroup.DesignId,
                            Name = fileGroup.DesignName,
                            DesignFamily = new DesignFamily()
                            {
                                Id = fileGroup.DesignFamilyId,
                                Name = fileGroup.DesignFamilyName,
                            },
                        },
                    };
                    result.Add(file);

                    var fileRecords = records.Where(x => x.OsatId == fileGroup.OsatId && x.DesignFamilyId == fileGroup.DesignFamilyId && x.DesignId == fileGroup.DesignId);
                    file.Sheets = createQualFilterSheets(fileRecords, file?.Design.Name);
                }
            }
            return result;
        }

        private static QualFilterSheets createQualFilterSheets(IEnumerable<QualFilterRecord> records, string designName = null)
        {
            var result = new QualFilterSheets();
            foreach (var sheetGroup in records.Select(x => new { x.PackageDieTypeId, x.PackageDieTypeName, x.AttributeValues.number_of_die_in_pkg }).Distinct())
            {
                var name = sheetGroup.PackageDieTypeName;
                int.TryParse(sheetGroup.number_of_die_in_pkg, out int count);
                if (designName != null) name = designName + " " + name;
                var sheet = new QualFilterSheet()
                {
                    Name = name,
                    PackageDieType = new PackageDieType()
                    {
                        Id = sheetGroup.PackageDieTypeId,
                        Name = sheetGroup.PackageDieTypeName,
                        Count = count,
                    },
                    Records = new QualFilterRecords(),
                };
                sheet.Records.AddRange(records.Where(x => x.PackageDieTypeId == sheet.PackageDieType.Id));
                result.Add(sheet);
            }
            return result;
        }

        private void sendEmails(EmailTemplates emailTemplates, ReviewEmails emails, long id)
        {
            if (!Settings.OsatCriteriaEmailsDisabled && emailTemplates != null && emails != null && emailTemplates.Count > 0 && emails.Count > 0)
            {
                string baseUrl = Settings.BaseUrl;
                if (baseUrl.EndsWith(@"/")) baseUrl = baseUrl.Substring(0, baseUrl.Length - 1); // remove trailing "/" character
                string itemUrl = baseUrl + $"/Osat/BuildCriteriaSetDetails/{id}";
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
                            string VersionDescription = email.VersionDescription.Replace("&lt;br&gt;", "<br>");
                            VersionDescription = VersionDescription.Replace("lt;br&gt;", "<br>");
                            sender.Send(to, baseUrl, itemUrl, email.ReviewAtDescription, email.RecipientName, "OSAT Build Criteria Set", VersionDescription);
                        }
                        catch { }
                    }
                }
            }
        }
        private void sendEmailsBulkUpdate(EmailTemplates emailTemplates, ReviewEmails emails, long id,  string ReviewText, string userId)
        {
            if (!Settings.OsatCriteriaEmailsDisabled && emailTemplates != null && emails != null && emailTemplates.Count > 0 && emails.Count > 0)
            {
                string baseUrl = Settings.BaseUrl;
                if (baseUrl.EndsWith(@"/")) baseUrl = baseUrl.Substring(0, baseUrl.Length - 1); // remove trailing "/" character
                string itemUrl = baseUrl + $"/Osat/BulkUpdates?id={id}";
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
                            string VersionDescription = email.VersionDescription.Replace("&lt;br&gt;", "<br>");
                             VersionDescription = VersionDescription.Replace("lt;br&gt;", "<br>");
                            sender.Send(to, baseUrl, itemUrl, email.ReviewAtDescription, email.RecipientName, "OSAT Build Criteria Set Bulk Update", VersionDescription, (String.IsNullOrEmpty(ReviewText)? "<br> Initaited By: " + userId : "<p><b>Message for Approver(s):</b></p>" + ReviewText + "<br> Initaited By: " + userId ));
                        }
                        catch { }
                    }
                }
            }
        }
        #endregion
    }
}
