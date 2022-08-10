namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewGroupReviewer : IReviewGroupReviewer
    {
        public ReviewGroup ReviewGroup { get; set; }
        public Reviewers Reviewers { get; set; }

        public ReviewGroupReviewer()
        {
            Reviewers = new Reviewers();
        }
    }
}
