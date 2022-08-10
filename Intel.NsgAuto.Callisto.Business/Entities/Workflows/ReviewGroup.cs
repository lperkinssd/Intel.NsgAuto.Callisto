namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewGroup : IReviewGroup
    {
        public long Id { get; set; }
        public long VersionId { get; set; }
        public int ReviewStageId { get; set; }
        public int ReviewGroupId { get; set; }
        public string GroupName { get; set; }
        public string DisplayName { get; set; }
        public ReviewStatus ReviewStatus { get; set; }
        public string ReviewStatusText { get; set; }
        public bool IsCheckListCompleted { get; set; }

        public ReviewGroup()
        {
            ReviewStatus = ReviewStatus.Open;
            ReviewStatusText = "open";
            IsCheckListCompleted = false;
        }
    }
}
