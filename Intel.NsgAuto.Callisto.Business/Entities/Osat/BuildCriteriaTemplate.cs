namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaTemplate
    {
        public int Id { get; set; }
        public int SetTemplateId { get; set; }
        public int Ordinal { get; set; }
        public string Name { get; set; }
        public BuildCriteriaTemplateConditions Conditions { get; set; }
    }
}
