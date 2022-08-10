using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCombination
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Product Design { get; set; }
        public FabricationFacility FabricationFacility { get; set; }
        public TestFlow TestFlow { get; set; }
        public ProbeConversion ProbeConversion { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
