namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class BuildCriteriaTemplate
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DesignFamily DesignFamily { get; set; }
        public BuildCriteriaTemplateConditions Conditions { get; set; }
    }
}
