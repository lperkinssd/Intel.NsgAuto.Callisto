namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaTemplateCondition
    {
        public int Id { get; set; }
        public int TemplateId { get; set; }
        public int SetTemplateId { get; set; }
        public AttributeType AttributeType { get; set; }
        public ComparisonOperation ComparisonOperation { get; set; }
        public string Value { get; set; }
    }
}
