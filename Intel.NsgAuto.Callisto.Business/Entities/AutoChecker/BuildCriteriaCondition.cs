using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCriteriaCondition
    {
        public long Id { get; set; }
        public long BuildCriteriaId { get; set; }
        public AttributeType AttributeType { get; set; }
        public LogicalOperation LogicalOperation { get; set; }
        public ComparisonOperation ComparisonOperation { get; set; }
        public string Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
