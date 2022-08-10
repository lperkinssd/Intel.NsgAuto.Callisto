namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewStage : IReviewStage
    {
        public long Id { get; set; }
        public long VersionId { get; set; }
        public int ReviewStageId { get; set; }
        public string StageName { get; set; }
        public string DisplayName { get; set; }
        public int ParentStageId { get; set; }
        public bool IsNextInParallel { get; set; }
        public int Sequence { get; set; }
    }
}
