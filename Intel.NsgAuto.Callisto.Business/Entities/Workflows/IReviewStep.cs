namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public interface IReviewStep
    {
        ReviewStatus Status { get; set; }
        string StatusText { get; set; }
        bool IsCurrentStage { get; set; }
        ReviewStage ReviewStage { get; set; }
        ReviewGroupReviewers ReviewGroupReviewers { get; set; }
        ReviewSteps ChildSteps { get; set; }
    }
}
