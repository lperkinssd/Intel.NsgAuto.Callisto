using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewDecision : IReviewDecision
    {
        public long Id { get; set; }
        public long SnapshotReviewerId { get; set; }
        public long VersionId { get; set; }
        public int ReviewStageId { get; set; }
        public int ReviewGroupId { get; set; }
        public int ReviewerId { get; set; }
        public bool? IsApproved { get; set; }
        public string Comment { get; set; }
        public DateTime ReviewedOn { get; set; }
    }
}
