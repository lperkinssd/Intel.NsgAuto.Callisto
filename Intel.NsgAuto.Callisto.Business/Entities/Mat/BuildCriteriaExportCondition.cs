using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class BuildCriteriaExportCondition : BuildCriteriaCondition
    {
        public Design Design { get; set; }
        public IdAndName FabricationFacility { get; set; }
        public IdAndName Device { get; set; }
        public IdAndName ProductFamily { get; set; }
        public IdAndName Capacity { get; set; }
        public IdAndName Scode { get; set; }
        public IdAndName MediaIPN { get; set; }
    }
}
