using System;
using System.Collections.Generic;
using System.Linq;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.Mat;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class MatDataContext
    {

        public AttributeDataTypes GetAttributeDataTypes(string userId)
        {
            return attributeDataTypes;
        }

        public AttributeTypes GetAttributeTypes(string userId)
        {
            return attributeTypes;
        }

        public AttributeTypesMetadata GetAttributeTypesMetadata(string userId)
        {
            AttributeTypesMetadata result = new AttributeTypesMetadata();
            //ComparisonOperations comparisonOperations = new ComparisonOperations();
            //AttributeDataTypeOperations dataTypeOperations = new AttributeDataTypeOperations();

            result.AttributeTypes = attributeTypes;
            result.AttributeDataTypes = attributeDataTypes;

            foreach (AttributeDataTypeOperation dataTypeOperation in dataTypeOperations)
            {
                AttributeDataType dataType = result.AttributeDataTypes.Find(x => x.Id == dataTypeOperation.AttributeDataTypeId);
                ComparisonOperation comparisonOperation = comparisonOperations.Find(x => x.Id == dataTypeOperation.ComparisonOperationId);
                if (dataType != null && comparisonOperation != null)
                {
                    dataType.ComparisonOperations.Add(comparisonOperation);
                }
            }

            //comparisonOperations = 
            //ISqlDataAccess dataAccess = null;
            //try
            //{
            //    dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACATTRIBUTETYPESMETADATA);
            //    dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
            //    ComparisonOperations comparisonOperations = new ComparisonOperations();
            //    AttributeDataTypeOperations dataTypeOperations = new AttributeDataTypeOperations();
            //    using (IDataReader reader = dataAccess.ExecuteReader())
            //    {
            //        result.AttributeTypes = new AttributeTypes();
            //        while (reader.Read())
            //        {
            //            result.AttributeTypes.Add(newAttributeType(reader));
            //        }

            //        reader.NextResult();
            //        result.AttributeDataTypes = new AttributeDataTypes();
            //        while (reader.Read())
            //        {
            //            AttributeDataType dataType = newAttributeDataType(reader);
            //            dataType.ComparisonOperations = new ComparisonOperations();
            //            result.AttributeDataTypes.Add(dataType);
            //        }

            //        reader.NextResult();
            //        while (reader.Read())
            //        {
            //            comparisonOperations.Add(newComparisonOperation(reader));
            //        }

            //        reader.NextResult();
            //        while (reader.Read())
            //        {
            //            dataTypeOperations.Add(newAttributeDataTypeOperation(reader));
            //        }
            //    }
            //    foreach (AttributeDataTypeOperation dataTypeOperation in dataTypeOperations)
            //    {
            //        AttributeDataType dataType = result.AttributeDataTypes.Find(x => x.Id == dataTypeOperation.AttributeDataTypeId);
            //        ComparisonOperation comparisonOperation = comparisonOperations.Find(x => x.Id == dataTypeOperation.ComparisonOperationId);
            //        if (dataType != null && comparisonOperation != null)
            //        {
            //            dataType.ComparisonOperations.Add(comparisonOperation);
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{
            //    throw ex;
            //}
            //finally
            //{
            //    dataAccess?.Close();
            //}
            return result;
        }

        public BuildCriteria GetBuildCriteria(string userId, long id)
        {
            var result = buildCriterias.Find(x => x.Id == id);
            return result;
        }

        public BuildCriterias GetBuildCriterias(string userId, bool? isPOR = null)
        {
            BuildCriterias result;
            if (isPOR.HasValue)
            {
                result = new BuildCriterias();
                result.AddRange(buildCriterias.Where(x => x.IsPOR == isPOR.Value));
            }
            else
            {
                result = buildCriterias;
            }
            return result;
        }

        public BuildCriteriaDetails GetBuildCriteriaDetails(string userId, long id, long? idCompare = null)
        {
            BuildCriteriaDetails result = new BuildCriteriaDetails();
            result.BuildCriteria = GetBuildCriteria(userId, id);

            List<BuildCriteriaCondition> l = result.BuildCriteria.Conditions;

            BuildCriteriaDetails bcd = new BuildCriteriaDetails();
            bcd.BuildCriteria = new BuildCriteria();
            bcd.BuildCriteria.Id = result.BuildCriteria.Id;
            bcd.BuildCriteria.Version = result.BuildCriteria.Version;
            bcd.BuildCriteria.IsPOR = result.BuildCriteria.IsPOR;
            bcd.BuildCriteria.IsActive = result.BuildCriteria.IsActive;
            bcd.BuildCriteria.Status = result.BuildCriteria.Status;
            bcd.BuildCriteria.CreatedBy = result.BuildCriteria.CreatedBy;
            bcd.BuildCriteria.CreatedByUserName = result.BuildCriteria.CreatedByUserName;
            bcd.BuildCriteria.CreatedOn = result.BuildCriteria.CreatedOn;
            bcd.BuildCriteria.UpdatedBy = result.BuildCriteria.UpdatedBy;
            bcd.BuildCriteria.UpdatedByUserName = result.BuildCriteria.UpdatedByUserName;
            bcd.BuildCriteria.UpdatedOn = result.BuildCriteria.UpdatedOn;
            bcd.BuildCriteria.Capacity = result.BuildCriteria.Capacity;
            bcd.BuildCriteria.Design = result.BuildCriteria.Design;
            bcd.BuildCriteria.Device = result.BuildCriteria.Device;
            bcd.BuildCriteria.FabricationFacility = result.BuildCriteria.FabricationFacility;
            bcd.BuildCriteria.MediaIPN = result.BuildCriteria.MediaIPN;
            bcd.BuildCriteria.ProductFamily = result.BuildCriteria.ProductFamily;
            bcd.BuildCriteria.Scode = result.BuildCriteria.Scode;
            bcd.BuildCriteria.Conditions = new BuildCriteriaConditions();

            foreach (BuildCriteriaCondition c in l)
            {
                bcd.BuildCriteria.Conditions.Add(
                    new BuildCriteriaExportCondition()
                    {
                        Capacity = bcd.BuildCriteria.Capacity,
                        Device = bcd.BuildCriteria.Device,
                        Design = bcd.BuildCriteria.Design,
                        FabricationFacility = bcd.BuildCriteria.FabricationFacility,
                        Id = bcd.BuildCriteria.Id,
                        MediaIPN = bcd.BuildCriteria.MediaIPN,
                        ProductFamily = bcd.BuildCriteria.ProductFamily,
                        Scode = bcd.BuildCriteria.Scode,
                        AttributeType = c.AttributeType,
                        LogicalOperation = c.LogicalOperation,
                        ComparisonOperation = c.ComparisonOperation,
                        Value = c.Value
                    }
                );
            }

            return bcd;
            //return result;
        }

        public BuildCriteriaExportConditions GetBuildCriteriaExportConditions(string userId)
        {
            BuildCriteriaExportConditions result = new BuildCriteriaExportConditions();
            BuildCriterias list = GetBuildCriterias(userId, true);
            BuildCriteriaDetails d = new BuildCriteriaDetails();

            foreach(BuildCriteria b in list)
            {
                d = GetBuildCriteriaDetails(userId, b.Id);

                foreach(BuildCriteriaCondition bcd in d.BuildCriteria.Conditions)
                {
                    result.Add(new BuildCriteriaExportCondition()
                    {
                        AttributeType = bcd.AttributeType,
                        BuildCriteriaId = bcd.BuildCriteriaId,
                        Capacity= d.BuildCriteria.Capacity,
                        ComparisonOperation = bcd.ComparisonOperation,
                        CreatedBy = bcd.CreatedBy,
                        CreatedOn = bcd.CreatedOn,
                        Design = d.BuildCriteria.Design,
                        Device = d.BuildCriteria.Device,
                        FabricationFacility = d.BuildCriteria.FabricationFacility,
                        Id = bcd.Id,
                        LogicalOperation = bcd.LogicalOperation,
                        MediaIPN = d.BuildCriteria.MediaIPN,
                        ProductFamily = d.BuildCriteria.ProductFamily,
                        Scode = d.BuildCriteria.Scode,
                        UpdatedBy = bcd.UpdatedBy,
                        UpdatedOn = bcd.UpdatedOn,
                        Value = bcd.Value
                    });
                }
            }

            return result;
        }
        public IdAndNames GetCapacities(string userId)
        {
            return capacities;
        }

        public List<DesignFamily> GetDesignFamilies(string userId)
        {
            return designFamilies;
        }

        public Designs GetDesigns(string userId)
        {
            return designs;
        }

        public IdAndNames GetDevices(string userId)
        {
            return devices;
        }

        public IdAndNames GetFabricationFacilities(string userId)
        {
            return fabricationFacilities;
        }

        public IdAndNames GetMediaIPNs(string userId)
        {
            return mediaIPNs;
        }

        public PrototypeConditions GetPrototypeConditions(string userId)
        {
            return prototypeConditions;
        }

        public IdAndNames GetScodes(string userId)
        {
            return scodes;
        }

        public ManageAttributeTypes GetManageAttributeTypes(string userId)
        {
            var result = new ManageAttributeTypes()
            {
                AttributeTypes = attributeTypes,
                AttributeDataTypes = attributeDataTypes,
            };
            return result;
        }

        public ManageBuildCriteria GetManageBuildCriteria(string userId, long? id)
        {
            var result = new ManageBuildCriteria()
            {
                AttributeTypes = attributeTypes,
                Designs = designs,
                FabricationFacilities = fabricationFacilities,
                Devices = devices,
                Capacities = capacities,
                Scodes = scodes,
                MediaIPNs = mediaIPNs
            };
            if (id.HasValue) result.BuildCriteria = buildCriterias.Find(x => x.Id == id.Value);
            return result;
        }

        #region prototype
        private static readonly AttributeDataTypes attributeDataTypes;
        private static readonly AttributeTypes attributeTypes;
        private static readonly BuildCriterias buildCriterias;
        private static readonly PrototypeConditions prototypeConditions;
        private static readonly List<DesignFamily> designFamilies;
        private static readonly IdAndNames fabricationFacilities;
        private static readonly IdAndNames devices;
        private static readonly Designs designs;
        private static readonly IdAndNames capacities;
        private static readonly IdAndNames scodes;
        private static readonly IdAndNames mediaIPNs;
        private static readonly IdAndNames productFamilies;

        private static readonly ComparisonOperations comparisonOperations;
        private static readonly AttributeDataTypeOperations dataTypeOperations;
        private static readonly LogicalOperation logicalOperation;

        static MatDataContext()
        {
            attributeDataTypes = new AttributeDataTypes()
            {
                new AttributeDataType() { Id = 1, Name = "string", NameDisplay = "String" },
                new AttributeDataType() { Id = 2, Name = "number", NameDisplay = "Number" },
            };
            var dataTypeString = attributeDataTypes[0];
            var dataTypeNumber = attributeDataTypes[1];

            attributeTypes = new AttributeTypes()
            {
                new AttributeType() { Id = 1, Name = "cell_revision", NameDisplay = "Cell Revision", DataType = dataTypeNumber },
                new AttributeType() { Id = 2, Name = "major_probe_prog_rev", NameDisplay = "Major Prove Program Revision", DataType = dataTypeNumber },
                new AttributeType() { Id = 3, Name = "probe_revision", NameDisplay = "Probe Revision", DataType = dataTypeString },
                new AttributeType() { Id = 4, Name = "burn_tape_revision", NameDisplay = "Burn Tape Revision", DataType = dataTypeNumber },
                new AttributeType() { Id = 5, Name = "custom_testing_required", NameDisplay = "Custom Testing Required", DataType = dataTypeString },
                new AttributeType() { Id = 6, Name = "custom_testing_required2", NameDisplay = "Custom Testing Required2", DataType = dataTypeString },
                new AttributeType() { Id = 7, Name = "product_grade", NameDisplay = "Product Grade", DataType = dataTypeString },
                new AttributeType() { Id = 8, Name = "prb_conv_id", NameDisplay = "Prb Conv Id", DataType = dataTypeString },
                new AttributeType() { Id = 9, Name = "fab_conv_id", NameDisplay = "Fab Conv Id", DataType = dataTypeString },
                new AttributeType() { Id = 10, Name = "fab_excr_id", NameDisplay = "Fab Excr Id", DataType = dataTypeString },
                new AttributeType() { Id = 11, Name = "media_type", NameDisplay = "Media Type", DataType = dataTypeString },
                new AttributeType() { Id = 12, Name = "reticle_wave_id", NameDisplay = "Reticle Wave Id", DataType = dataTypeString },
            };

            designFamilies = new List<DesignFamily>()
            {
                new DesignFamily() { Id = 1, Name = "NAND" },
            };
            var nand = designFamilies[0];

            fabricationFacilities = new IdAndNames()
            {
                new IdAndName() { Id = 1, Name = "FAB 2"},
                new IdAndName() { Id = 2, Name = "FAB 10"},
                new IdAndName() { Id = 3, Name = "FAB 68"},
                new IdAndName() { Id = 4, Name = "FAB 68A"},
                new IdAndName() { Id = 5, Name = "FAB68A"},
            };

            capacities = new IdAndNames()
            {
                new IdAndName() { Id = 1, Name = "16GB 256GB"},
                new IdAndName() { Id = 2, Name = "32GB 512GB"},
                new IdAndName() { Id = 3, Name = "32GB 1024GB"},
                new IdAndName() { Id = 4, Name = "256GB"},
                new IdAndName() { Id = 5, Name = "512GB"},
                new IdAndName() { Id = 6, Name = "800GB"},
                new IdAndName() { Id = 7, Name = "960GB"},
                new IdAndName() { Id = 8, Name = "1024GB"},
                new IdAndName() { Id = 9, Name = "1600GB"},
                new IdAndName() { Id = 10, Name = "1920GB"},
                new IdAndName() { Id = 11, Name = "2048GB"},
                new IdAndName() { Id = 12, Name = "3200GB"},
                new IdAndName() { Id = 13, Name = "3840GB"},
                new IdAndName() { Id = 14, Name = "6400GB"},
                new IdAndName() { Id = 15, Name = "7680GB"},
                new IdAndName() { Id = 16, Name = "7.68TB"},
                new IdAndName() { Id = 17, Name = "15TB"},
                new IdAndName() { Id = 1, Name = "15.36TB"},
            };

            dataTypeOperations = new AttributeDataTypeOperations() 
            { 
                new AttributeDataTypeOperation() { AttributeDataTypeId = 1, ComparisonOperationId = 1},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 1, ComparisonOperationId = 6},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 1, ComparisonOperationId = 7},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 1, ComparisonOperationId = 8},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 1, ComparisonOperationId = 13},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 1, ComparisonOperationId = 15},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 2, ComparisonOperationId = 1},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 2, ComparisonOperationId = 6},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 2, ComparisonOperationId = 13},
                new AttributeDataTypeOperation() { AttributeDataTypeId = 2, ComparisonOperationId = 15},
            };

            comparisonOperations = new ComparisonOperations()
            {
                new ComparisonOperation() { Id = 1, Key = "=", KeyTreadstone = "=", Name = "Equals", OperandType = new OperandType() { Id = 2, Name = "Single Value"}},
                new ComparisonOperation() { Id = 6, Key = ">=", KeyTreadstone = ">=", Name = "Is greater than or equal to", OperandType = new OperandType() { Id = 2, Name = "Single Value"}},
                new ComparisonOperation() { Id = 7, Key = "contains", KeyTreadstone = "contains", Name = "Contains", OperandType = new OperandType() { Id = 2, Name = "Single Value"}},
                new ComparisonOperation() { Id = 8, Key = "does not contain", KeyTreadstone = "does not contain", Name = "Does not contain", OperandType = new OperandType() { Id = 2, Name = "Single Value"}},
                new ComparisonOperation() { Id = 13, Key = "in", KeyTreadstone = "in", Name = "Is in", OperandType = new OperandType() { Id = 3, Name = "List"}},
                new ComparisonOperation() { Id = 15, Key = "not in", KeyTreadstone = "not in", Name = "Is not in", OperandType = new OperandType() { Id = 3, Name = "List"}},
            };

            logicalOperation = new LogicalOperation()
            {
                Id = 1,
                Key = "and",
                Name = "AND"
            };

            devices = new IdAndNames()
            {
                new IdAndName() { Id = 1, Name = "29F01T2AMCTJ1"},
                new IdAndName() { Id = 2, Name = "29F02T2AMCQH1"},
                new IdAndName() { Id = 3, Name = "29F02T2AMCQH2"},
                new IdAndName() { Id = 4, Name = "29F02T2ANCTJ1"},
                new IdAndName() { Id = 5, Name = "29F02T4AMCQH1"},
                new IdAndName() { Id = 6, Name = "29F04T2ANCQH1"},
                new IdAndName() { Id = 7, Name = "29F04T2ANCQH2"},
                new IdAndName() { Id = 8, Name = "29F04T2AOCTJ1"},
                new IdAndName() { Id = 9, Name = "29F04T4ANCQH1"},
                new IdAndName() { Id = 10, Name = "29F08T2AOCQH1"},
                new IdAndName() { Id = 11, Name = "29F08T2AOCQH2"},
                new IdAndName() { Id = 12, Name = "29F08T2AWCTJ1"},
                new IdAndName() { Id = 13, Name = "29F08T4AOCQH1"},
                new IdAndName() { Id = 14, Name = "29F64B2ALCTJ1"},
                new IdAndName() { Id = 15, Name = "29P16B1ALDNF2"},
                new IdAndName() { Id = 16, Name = "29P16B1ALDNFA"},
                new IdAndName() { Id = 17, Name = "29P32B2AMDNF2"},
            };

            designs = new Designs()
            {
                new Design() { Id = 1, DesignFamily = nand, Name = "B16A" },
                new Design() { Id = 2, DesignFamily = nand, Name = "B17A" },
                new Design() { Id = 3, DesignFamily = nand, Name = "B27A" },
                new Design() { Id = 4, DesignFamily = nand, Name = "N18A" },
                new Design() { Id = 5, DesignFamily = nand, Name = "N28A" },

            };

            scodes = new IdAndNames()
            {
                new IdAndName() { Id = 1, Name = "976805"},
                new IdAndName() { Id = 2, Name = "976806"},
                new IdAndName() { Id = 3, Name = "976807"},
                new IdAndName() { Id = 4, Name = "979156"},
                new IdAndName() { Id = 5, Name = "979183"},
                new IdAndName() { Id = 6, Name = "980318"},
                new IdAndName() { Id = 7, Name = "980904"},
                new IdAndName() { Id = 8, Name = "980941"},
                new IdAndName() { Id = 9, Name = "980942"},
                new IdAndName() { Id = 10, Name = "983541"},
                new IdAndName() { Id = 11, Name = "985250"},
                new IdAndName() { Id = 12, Name = "999HAD"},
                new IdAndName() { Id = 13, Name = "999HAF"},
                new IdAndName() { Id = 14, Name = "999HAG"},
                new IdAndName() { Id = 15, Name = "999HAH"},
                new IdAndName() { Id = 16, Name = "999HAJ"},
                new IdAndName() { Id = 17, Name = "999HAL"},
                new IdAndName() { Id = 18, Name = "999HAN"},
                new IdAndName() { Id = 19, Name = "999HAP"},
                new IdAndName() { Id = 20, Name = "999HAR"},
            };

            mediaIPNs = new IdAndNames()
            {
                new IdAndName() { Id = 1, Name = "H36854-003"},
                new IdAndName() { Id = 2, Name = "J23297-002"},
                new IdAndName() { Id = 3, Name = "J63669-002"},
                new IdAndName() { Id = 4, Name = "J63675-002"},
                new IdAndName() { Id = 5, Name = "J63678-002"},
                new IdAndName() { Id = 6, Name = "J76530-004"},
                new IdAndName() { Id = 7, Name = "J76531-004"},
                new IdAndName() { Id = 8, Name = "J76532-004"},
                new IdAndName() { Id = 9, Name = "J76533-004"},
                new IdAndName() { Id = 10, Name = "J76534-004"},
                new IdAndName() { Id = 11, Name = "K20263-002"},
                new IdAndName() { Id = 12, Name = "K20264-002"},
                new IdAndName() { Id = 13, Name = "K20273-002"},
                new IdAndName() { Id = 14, Name = "K24998-001"},
                new IdAndName() { Id = 15, Name = "K36451-002"},
                new IdAndName() { Id = 16, Name = "K36455-002"},
                new IdAndName() { Id = 17, Name = "K36458-002"},
            };

            productFamilies = new IdAndNames()
            {
                new IdAndName() { Id = 1, Name = "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 2, Name = "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 3, Name = "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 4, Name = "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 5, Name = "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 6, Name = "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 7, Name = "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 8, Name = "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 9, Name = "BEAR COVE QUANTUM 960GB 2.5 SAS RI SSD"},
                new IdAndName() { Id = 10, Name = "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD"},
                new IdAndName() { Id = 11, Name = "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD"},
                new IdAndName() { Id = 12, Name = "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD"},
                new IdAndName() { Id = 13, Name = "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD"},
                new IdAndName() { Id = 14, Name = "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD"},
                new IdAndName() { Id = 15, Name = "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD"},
                new IdAndName() { Id = 16, Name = "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD"},
                new IdAndName() { Id = 17, Name = "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD"},

            };

            prototypeConditions = new PrototypeConditions();
            for (var i = 0; i < prototypeConditionsStringArray.GetLength(0); i++)
            {
                var prototypeCondition = new PrototypeCondition()
                {
                    Id = i + 1,
                    DesignId = prototypeConditionsStringArray[i, 0],
                    FabricationFacility = prototypeConditionsStringArray[i, 1],
                    Device = prototypeConditionsStringArray[i, 2],
                    ProductFamily = prototypeConditionsStringArray[i, 3],
                    Capacity = prototypeConditionsStringArray[i, 4],
                    Scode = prototypeConditionsStringArray[i, 5],
                    MediaIPN = prototypeConditionsStringArray[i, 6],
                    AttributeType = attributeTypes.Find(x => x.Name == prototypeConditionsStringArray[i, 7]),
                    LogicalOperation = logicalOperation, 
                    ComparisonOperation = comparisonOperations.Find(x => x.Key == prototypeConditionsStringArray[i, 9]),
                    Value = prototypeConditionsStringArray[i, 10],
                };
                prototypeConditions.Add(prototypeCondition);
            }

            buildCriterias = new BuildCriterias();
            var groupedItems = prototypeConditions.GroupBy(x => new { x.DesignId, x.FabricationFacility, x.Device, x.Scode, x.MediaIPN, x.Capacity, x.ProductFamily }, (key, group) => new { key.DesignId, key.FabricationFacility, key.Device, key.Scode, key.MediaIPN, key.Capacity, key.ProductFamily, Results = group.ToList() });
            int buildCriteriaId = 0;
            int buildCriteriaConditionId = 0;
            foreach (var item in groupedItems)
            {
                var criteria = new BuildCriteria()
                {
                    Id = ++buildCriteriaId,
                    Version = 1,
                    IsPOR = true,
                    IsActive = true,
                    Status = new Status() { Id = 6, Name = "Complete" },
                    CreatedBy = "bricschx",
                    CreatedOn = DateTime.UtcNow,
                    UpdatedBy = "bricschx",
                    UpdatedOn = DateTime.UtcNow,
                    Capacity = capacities.Find(x => x.Name == item.Capacity),
                    Design = designs.Find(x => x.Name == item.DesignId),
                    Device = devices.Find(x => x.Name == item.Device),
                    FabricationFacility = fabricationFacilities.Find(x => x.Name == item.FabricationFacility),
                    MediaIPN = mediaIPNs.Find(x => x.Name == item.MediaIPN),
                    ProductFamily = productFamilies.Find(x => x.Name == item.ProductFamily),
                    Scode = scodes.Find(x => x.Name == item.Scode),
                    Conditions = new BuildCriteriaConditions(),
                };
                foreach (var result in item.Results)
                {
                    var condition = new BuildCriteriaCondition()
                    {
                        Id = ++buildCriteriaConditionId,
                        AttributeType = result.AttributeType,
                        LogicalOperation = result.LogicalOperation,
                        ComparisonOperation = result.ComparisonOperation,
                        Value = result.Value,
                    };
                    criteria.Conditions.Add(condition);
                }
                buildCriterias.Add(criteria);
            }

            // now make a few adjustments to the build criterias to demonstrate versioning capabilities
            var criteriaReference = buildCriterias[0];
            var criteriaNew = new BuildCriteria()
            {
                Id = ++buildCriteriaId,
                Version = 2,
                IsPOR = false,
                IsActive = true,
                Status = new Status() { Id = 1, Name = "Draft" },
                CreatedBy = "bricschx",
                CreatedOn = DateTime.UtcNow,
                UpdatedBy = "bricschx",
                UpdatedOn = DateTime.UtcNow,
                Capacity = criteriaReference.Capacity,
                Design = criteriaReference.Design,
                Device = criteriaReference.Device,
                FabricationFacility = criteriaReference.FabricationFacility,
                MediaIPN = criteriaReference.MediaIPN,
                ProductFamily = criteriaReference.ProductFamily,
                Scode = criteriaReference.Scode,
                Conditions = new BuildCriteriaConditions(),
            };
            foreach (var conditionReference in criteriaReference.Conditions)
            {
                var condition = new BuildCriteriaCondition()
                {
                    Id = ++buildCriteriaConditionId,
                    AttributeType = conditionReference.AttributeType,
                    LogicalOperation = conditionReference.LogicalOperation,
                    ComparisonOperation = conditionReference.ComparisonOperation,
                    Value = conditionReference.Value,
                };
                criteriaNew.Conditions.Add(condition);
            }
            buildCriterias.Insert(0, criteriaNew);

            criteriaReference = buildCriterias[2];
            criteriaNew = new BuildCriteria()
            {
                Id = ++buildCriteriaId,
                Version = 2,
                IsPOR = false,
                IsActive = true,
                Status = new Status() { Id = 2, Name = "Canceled" },
                CreatedBy = "bricschx",
                CreatedOn = DateTime.UtcNow,
                UpdatedBy = "bricschx",
                UpdatedOn = DateTime.UtcNow,
                Capacity = criteriaReference.Capacity,
                Design = criteriaReference.Design,
                Device = criteriaReference.Device,
                FabricationFacility = criteriaReference.FabricationFacility,
                MediaIPN = criteriaReference.MediaIPN,
                ProductFamily = criteriaReference.ProductFamily,
                Scode = criteriaReference.Scode,
                Conditions = new BuildCriteriaConditions(),
            };
            foreach (var conditionReference in criteriaReference.Conditions)
            {
                var condition = new BuildCriteriaCondition()
                {
                    Id = ++buildCriteriaConditionId,
                    AttributeType = conditionReference.AttributeType,
                    LogicalOperation = conditionReference.LogicalOperation,
                    ComparisonOperation = conditionReference.ComparisonOperation,
                    Value = conditionReference.Value,
                };
                criteriaNew.Conditions.Add(condition);
            }
            buildCriterias.Insert(0, criteriaNew);

            criteriaReference = buildCriterias[4];
            criteriaNew = new BuildCriteria()
            {
                Id = ++buildCriteriaId,
                Version = 2,
                IsPOR = false,
                IsActive = true,
                Status = new Status() { Id = 3, Name = "Submitted" },
                CreatedBy = "bricschx",
                CreatedOn = DateTime.UtcNow,
                UpdatedBy = "bricschx",
                UpdatedOn = DateTime.UtcNow,
                Capacity = criteriaReference.Capacity,
                Design = criteriaReference.Design,
                Device = criteriaReference.Device,
                FabricationFacility = criteriaReference.FabricationFacility,
                MediaIPN = criteriaReference.MediaIPN,
                ProductFamily = criteriaReference.ProductFamily,
                Scode = criteriaReference.Scode,
                Conditions = new BuildCriteriaConditions(),
            };
            foreach (var conditionReference in criteriaReference.Conditions)
            {
                var condition = new BuildCriteriaCondition()
                {
                    Id = ++buildCriteriaConditionId,
                    AttributeType = conditionReference.AttributeType,
                    LogicalOperation = conditionReference.LogicalOperation,
                    ComparisonOperation = conditionReference.ComparisonOperation,
                    Value = conditionReference.Value,
                };
                criteriaNew.Conditions.Add(condition);
            }
            buildCriterias.Insert(0, criteriaNew);

            criteriaReference = buildCriterias[6];
            criteriaNew = new BuildCriteria()
            {
                Id = ++buildCriteriaId,
                Version = 2,
                IsPOR = false,
                IsActive = true,
                Status = new Status() { Id = 4, Name = "Rejected" },
                CreatedBy = "bricschx",
                CreatedOn = DateTime.UtcNow,
                UpdatedBy = "bricschx",
                UpdatedOn = DateTime.UtcNow,
                Capacity = criteriaReference.Capacity,
                Design = criteriaReference.Design,
                Device = criteriaReference.Device,
                FabricationFacility = criteriaReference.FabricationFacility,
                MediaIPN = criteriaReference.MediaIPN,
                ProductFamily = criteriaReference.ProductFamily,
                Scode = criteriaReference.Scode,
                Conditions = new BuildCriteriaConditions(),
            };
            foreach (var conditionReference in criteriaReference.Conditions)
            {
                var condition = new BuildCriteriaCondition()
                {
                    Id = ++buildCriteriaConditionId,
                    AttributeType = conditionReference.AttributeType,
                    LogicalOperation = conditionReference.LogicalOperation,
                    ComparisonOperation = conditionReference.ComparisonOperation,
                    Value = conditionReference.Value,
                };
                criteriaNew.Conditions.Add(condition);
            }
            buildCriterias.Insert(0, criteriaNew);

            criteriaReference = buildCriterias[8];
            criteriaNew = new BuildCriteria()
            {
                Id = ++buildCriteriaId,
                Version = 2,
                IsPOR = false,
                IsActive = true,
                Status = new Status() { Id = 5, Name = "In Review" },
                CreatedBy = "bricschx",
                CreatedOn = DateTime.UtcNow,
                UpdatedBy = "bricschx",
                UpdatedOn = DateTime.UtcNow,
                Capacity = criteriaReference.Capacity,
                Design = criteriaReference.Design,
                Device = criteriaReference.Device,
                FabricationFacility = criteriaReference.FabricationFacility,
                MediaIPN = criteriaReference.MediaIPN,
                ProductFamily = criteriaReference.ProductFamily,
                Scode = criteriaReference.Scode,
                Conditions = new BuildCriteriaConditions(),
            };
            foreach (var conditionReference in criteriaReference.Conditions)
            {
                var condition = new BuildCriteriaCondition()
                {
                    Id = ++buildCriteriaConditionId,
                    AttributeType = conditionReference.AttributeType,
                    LogicalOperation = conditionReference.LogicalOperation,
                    ComparisonOperation = conditionReference.ComparisonOperation,
                    Value = conditionReference.Value,
                };
                criteriaNew.Conditions.Add(condition);
            }
            buildCriterias.Insert(0, criteriaNew);
        }

        private static readonly string[,] prototypeConditionsStringArray = new string[,]
        {
            //{ "DesignID","FabFacility","DeviceName","ProductFamily","Capacity","Scode","MediaIPN","AttributeType","AND","ComparisonOperator","Value" },
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F08T2AWCTJ1", "BEAR COVE QUANTUM 15TB 2.5 SAS RI SSD", "15TB", "999HAR", "J76534-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76530-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1600GB 2.5 SAS RI SSD", "1600GB", "999HAF", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76530-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 1920GB 2.5 SAS RI SSD", "1920GB", "999HAL", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76531-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 3200GB 2.5 SAS RI SSD", "3200GB", "999HAG", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F64B2ALCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76530-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 3840GB 2.5 SAS RI SSD", "3840GB", "999HAN", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 6400GB 2.5 SAS RI SSD", "6400GB", "999HAH", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F02T2ANCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76532-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F04T2AOCTJ1", "BEAR COVE QUANTUM 7680GB 2.5 SAS RI SSD", "7680GB", "999HAP", "J76533-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB 68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "cell_revision", "AND", ">=", "9.4"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "major_probe_prog_rev", "AND", ">=", "51"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "probe_revision", "AND", ">=", "55A"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "burn_tape_revision", "AND", ">=", "013"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "product_grade", "AND", "=", "LEVEL 1"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "fab_conv_id", "AND", "=", "WAVE 01"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "fab_excr_id", "AND", "in", "EXCR000,EXCR124"},
            { "B27A", "FAB68A", "29F01T2AMCTJ1", "BEAR COVE QUANTUM 800GB 2.5 SAS RI SSD", "800GB", "999HAD", "J76531-004", "reticle_wave_id", "AND", "in", "WAVE014,WAVE015"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F08T2AOCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36458-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36451-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "K36455-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB 2.5 PCIE SSD", "15.36TB", "979183", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF18 PCIE SSD", "15.36TB", "980942", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F08T2AOCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63678-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 15.36TB EDSFF9 PCIE SSD", "15.36TB", "980941", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F04T2ANCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36455-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "major_probe_prog_rev", "AND", ">=", "27"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "custom_testing_required", "AND", "=", "PREMIUM"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "product_grade", "AND", "=", "LEVEL 1"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH2", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "K36451-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "CLIFFDALE REFRESH VE 7.68TB 2.5 PCIE SSD", "7.68TB", "979156", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 1024GB M.2 80MM PCIE CLIENT SSD", "1024GB", "976806", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F04T2ANCQH1", "NEPTUNE HARBOR 2048GB M.2 80MM PCIE CLIENT SSD", "2048GB", "976807", "J63675-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 256GB M.2 80MM PCIE CLIENT SSD", "256GB", "980904", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB68A", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "cell_revision", "AND", ">=", "9.4"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "major_probe_prog_rev", "AND", ">=", "26"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "probe_revision", "AND", ">=", "22"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "burn_tape_revision", "AND", ">=", "2018014"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "custom_testing_required", "AND", "=", "FULL"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "product_grade", "AND", "in", "LEVEL 1,LEVEL 2"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_conv_id", "AND", "in", "WAVE 01,WAVE 02"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "fab_excr_id", "AND", "in", "EXCR000,EXCR125,EXCR127,EXCR134,EXCR136,EXCR137,EXCR140"},
            { "N18A", "FAB 10", "29F02T2AMCQH1", "NEPTUNE HARBOR 512GB M.2 80MM PCIE CLIENT SSD", "512GB", "976805", "J63669-002", "reticle_wave_id", "AND", "=", "WAVE002"},
        };

        #endregion
    }
}

