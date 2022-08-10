namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class OsatBuildCriteriaSetBulkUpdateChangeDTO
    {
        public long Id { get; set; }
        public long VersionId { get; set; }
        public string AttributeName { get; set; }
        public string NewValue { get; set; }
        public string OldValue { get; set; }
        public int BuildCombinationId { get; set; }
        public int BuildCriteriaSetId { get; set; }
        public int BuildCriteriaOrdinal { get; set; }
    }
}
