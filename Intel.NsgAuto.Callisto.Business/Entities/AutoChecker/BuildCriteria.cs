using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCriteria
    {
        public long Id { get; set; }
        public int Version { get; set; }
        public bool IsPOR { get; set; }
        public bool IsActive { get; set; }
        public Status Status { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByUserName { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedByUserName { get; set; }
        public DateTime UpdatedOn { get; set; }
        public Product Design { get; set; }
        public FabricationFacility FabricationFacility { get; set; }
        public TestFlow TestFlow { get; set; }
        public ProbeConversion ProbeConversion { get; set; }
        public DateTime? EffectiveOn { get; set; }
        public BuildCriteriaComments Comments { get; set; }
        public BuildCriteriaConditions Conditions { get; set; }
    }
}
