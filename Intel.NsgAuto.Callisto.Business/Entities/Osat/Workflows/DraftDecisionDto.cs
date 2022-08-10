namespace Intel.NsgAuto.Callisto.Business.Entities.Osat.Workflows
{
    public class DraftDecisionDto
    {
        public string DecisionType { get; set; }
        public long VersionId { get; set; }
        public long? VersionIdCompare { get; set; }
        public bool Selected { get; set; }
        public bool Override { get; set; }
        public long DesignId { get; set; }
        public int ImportId { get; set; }
    }
}
