namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public interface IReviewStage
    {
        long Id { get; set; }
        long VersionId { get; set; }
        int ReviewStageId { get; set; }
        string StageName { get; set; }
        string DisplayName { get; set; }
    }
}
