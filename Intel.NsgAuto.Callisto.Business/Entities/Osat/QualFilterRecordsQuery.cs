namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterRecordsQuery : QualFilterRecordsQueryBase
    {
        public int? DesignId { get; set; }

        public int? OsatId { get; set; }
        public int? StatusId { get; set; }
        public int? VersionId { get; set; }
        public int? ImportId { get; set; }
        public string CreatedBy { get; set; }
        public bool? IsPOR { get; set; }
    }
}
