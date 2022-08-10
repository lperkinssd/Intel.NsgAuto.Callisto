namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaConditionCreateDto
    {
        public int BuildCriteriaOrdinal { get; set; }
        public string AttributeTypeName { get; set; }
        public string ComparisonOperationKey { get; set; }
        public string Value { get; set; }
    }
}
