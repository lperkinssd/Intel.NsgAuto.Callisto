namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewResponse
    {
        public bool Status { get; set; }
        public ReviewMessages Messages { get; set; }
        public Review Review { get; set; }
    }
}
