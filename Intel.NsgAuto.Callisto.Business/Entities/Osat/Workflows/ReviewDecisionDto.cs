namespace Intel.NsgAuto.Callisto.Business.Entities.Osat.Workflows
{
    public class ReviewDecisionDto : Entities.Workflows.ReviewDecisionDto
    {
        public long? VersionIdCompare { get; set; }
        public bool Selected { get; set; }
    }
}
