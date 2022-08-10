namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewDecisionDto
    {
        public long SnapshotReviewerId { get; set; }
        public long VersionId { get; set; }
        public bool IsApproved { get; set; }
        public string Comment { get; set; }
    }
}
