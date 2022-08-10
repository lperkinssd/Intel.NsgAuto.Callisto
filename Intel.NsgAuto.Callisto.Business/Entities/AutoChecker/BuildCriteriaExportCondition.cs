using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCriteriaExportCondition : BuildCriteriaCondition
    {
        public Product Design { get; set; }
        public FabricationFacility FabricationFacility { get; set; }
        public TestFlow TestFlow { get; set; }
        public ProbeConversion ProbeConversion { get; set; }
    }
}
