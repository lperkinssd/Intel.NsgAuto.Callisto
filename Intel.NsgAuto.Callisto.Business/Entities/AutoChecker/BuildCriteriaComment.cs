using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCriteriaComment
    {
        public long Id { get; set; }
        public long BuildCriteriaId { get; set; }
        public string Text { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByUserName { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedByUserName { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
