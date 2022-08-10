namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCombinationUpdatePublishDto
    {
        public int? Id { get; set; }

        public bool? Enabled { get; set; }

        public int? DesignId { get; set; }

        public bool? PorBuildCriteriaSetExists { get; set; }
    }
}
