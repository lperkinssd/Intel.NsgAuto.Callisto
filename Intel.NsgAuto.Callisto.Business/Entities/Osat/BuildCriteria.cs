using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteria
    {
        public long Id { get; set; }
        public long BuildCriteriaSetId { get; set; }
        public int Ordinal { get; set; }
        public string Name { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public BuildCriteriaConditions Conditions { get; set; }
    }
}
