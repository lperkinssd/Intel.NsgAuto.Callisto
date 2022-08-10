namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    interface IReviewGroupReviewer
    {
        ReviewGroup ReviewGroup { get; set; }
        Reviewers Reviewers { get; set; }
    }
}
