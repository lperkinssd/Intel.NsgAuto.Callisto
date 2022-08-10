using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.Mat;
using System;
using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class MatService
    {
        // Note: this service is currently for prototype purposes only
        // TODO: complete implementation with data context, etc.

        public BuildCriteria GetBuildCriteria(string userId, long id)
        {
            return new MatDataContext().GetBuildCriteria(userId, id);
        }

        public BuildCriterias GetBuildCriterias(string userId, bool? isPOR = null)
        {
            return new MatDataContext().GetBuildCriterias(userId, isPOR);
        }

        public BuildCriteriaDetails GetBuildCriteriaDetails(string userId, long id, long? idCompare = null)
        {
            return new MatDataContext().GetBuildCriteriaDetails(userId, id, idCompare);
        }

        public BuildCriteriaExportConditions GetBuildCriteriaExportConditions(string userId)
        {
            return new MatDataContext().GetBuildCriteriaExportConditions(userId);
        }

        public AttributeDataTypes GetAttributeDataTypes(string userId)
        {
            return new MatDataContext().GetAttributeDataTypes(userId);
        }

        public AttributeTypes GetAttributeTypes(string userId)
        {
            return new MatDataContext().GetAttributeTypes(userId);
        }

        public PrototypeConditions GetConditions(string userId)
        {
            return new MatDataContext().GetPrototypeConditions(userId);
        }

        public IdAndNames GetFabricationFacilities(string userId)
        {
            return new MatDataContext().GetFabricationFacilities(userId);
        }

        //public IdAndNames GetProbeConversionIds(string userId)
        //{
        //    return probeConversionIds;
        //}

        //public Products GetProducts(string userId)
        //{
        //    return products;
        //}

        //public IdAndNames GetTestFlows(string userId)
        //{
        //    return testFlows;
        //}
    }
}
