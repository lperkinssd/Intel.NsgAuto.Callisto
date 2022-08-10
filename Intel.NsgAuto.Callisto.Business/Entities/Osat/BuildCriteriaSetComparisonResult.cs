namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaSetComparisonResult
    {
        public string EntityType { get; set; }
        public int? BuildCombinationId { get; set; }
        public int? BuildCriteriaOrdinal { get; set; }
        public int? AttributeTypeId { get; set; }
        public int? ComparisonOperationId { get; set; }
        public int? MissingFrom { get; set; }
        public long? Id1 { get; set; }
        public long? Id2 { get; set; }
        public string Field { get; set; }
        public bool Different { get; set; }
        public string Value1 { get; set; }
        public string Value2 { get; set; }
    }
}
