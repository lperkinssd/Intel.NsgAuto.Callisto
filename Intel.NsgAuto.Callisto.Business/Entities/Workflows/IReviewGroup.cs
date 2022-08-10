namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public interface IReviewGroup
    {
        long Id { get; set; }
        long VersionId { get; set; }
        int ReviewStageId { get; set; }
        int ReviewGroupId { get; set; }
        string GroupName { get; set; }
        string DisplayName { get; set; }
        ReviewStatus ReviewStatus { get; set; }
        string ReviewStatusText { get; set; }
        bool IsCheckListCompleted { get; set; }
    }
}
