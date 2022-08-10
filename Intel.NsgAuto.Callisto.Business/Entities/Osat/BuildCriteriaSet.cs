using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaSet
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
        public BuildCombination BuildCombination { get; set; }
        public DateTime? EffectiveOn { get; set; }
        public BuildCriteriaSetComments Comments { get; set; }
        public BuildCriterias BuildCriterias { get; set; }
    }
}
