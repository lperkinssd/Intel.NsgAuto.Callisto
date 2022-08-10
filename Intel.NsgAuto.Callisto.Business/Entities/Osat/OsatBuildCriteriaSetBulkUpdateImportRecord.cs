namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
	public class OsatBuildCriteriaSetBulkUpdateImportRecord
    {
        public long Id { get; set; }
        public int ImportId { get; set; }
        public int BuildCriteriaSetId { get; set; }
        public int BuildCombinationId { get; set; }
        public int Version { get; set; }
        public int? DesignId { get; set; }
        public int? DesignFamilyId { get; set; }
        public string DeviceName { get; set; }
        public string PartNumberDecode { get; set; }
        public string IntelLevel1PartNumber { get; set; }
        public string IntelProdName { get; set; }
        public string Attribute { get; set; }
        public string NewValue { get; set; }
        public string OldValue { get; set; }
    }
}
