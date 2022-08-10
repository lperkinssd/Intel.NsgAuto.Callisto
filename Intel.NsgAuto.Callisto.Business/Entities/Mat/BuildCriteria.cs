using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
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
        public Design Design { get; set; }
        public IdAndName FabricationFacility { get; set; }
        public IdAndName Device { get; set; }
        public IdAndName ProductFamily { get; set; }
        public IdAndName Capacity { get; set; }
        public IdAndName Scode { get; set; }
        public IdAndName MediaIPN { get; set; }
        public BuildCriteriaConditions Conditions { get; set; }
        public DateTime? EffectiveOn { get; set; }
        public string Comments { get; set; }
    }
}
