namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
  public class QualFilterBulkUpdateAttributeChange
    {
        public int BuildCriteriaSetId { get; set; }
        public string AttributeName { get; set; }
        public string NewValue { get; set; }
        public string OldValue { get; set; }
        public int BuildCombinationId { get; set; }
        public int Version { get; set; }
        public int BuildCriteriaOrdinal { get; set; }
    }
}
