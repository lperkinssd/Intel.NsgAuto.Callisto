using System;
using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class Reviewer : IReviewer
    {
        public long Id { get; set; }
        public long VersionId { get; set; }
        public int ReviewStageId { get; set; }
        public int ReviewGroupId { get; set; }
        public int ReviewerId { get; set; }
        public string Wwid { get; set; }
        public string Idsid { get; set; }
        public Employee Employee { get; set; }
        public ReviewStatus ReviewStatus { get; set; }
        public string ReviewStatusText { get; set; }
        public string Comment { get; set; }
        public DateTime ReviewDate { get; set; }

        public Reviewer()
        {
            ReviewStatus = ReviewStatus.Open;
            ReviewStatusText = "open";
            Comment = "";
        }
    }
}
