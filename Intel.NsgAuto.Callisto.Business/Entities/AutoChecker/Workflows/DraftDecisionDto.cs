namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker.Workflows
{
    public class DraftDecisionDto
    {
        public string DecisionType { get; set; }
        public long VersionId { get; set; }
        public long? VersionIdCompare { get; set; }
    }
}
