namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaSetTemplate
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DesignFamily DesignFamily { get; set; }
        public BuildCriteriaTemplates Templates { get; set; }
    }
}
