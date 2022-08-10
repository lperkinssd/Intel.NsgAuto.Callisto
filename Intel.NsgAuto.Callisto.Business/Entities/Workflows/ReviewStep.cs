namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewStep : IReviewStep
    {
        public ReviewStatus Status { get; set; }
        public string StatusText { get; set; }
        public bool IsCurrentStage { get; set; }
        public ReviewStage ReviewStage { get; set; }
        public ReviewGroupReviewers ReviewGroupReviewers { get; set; }
        public ReviewSteps ChildSteps { get; set; }
        public ReviewStep()
        {
            Status = ReviewStatus.Open;
            StatusText = "open";
            IsCurrentStage = false;
            ReviewGroupReviewers = new ReviewGroupReviewers();
        }
    }
}
