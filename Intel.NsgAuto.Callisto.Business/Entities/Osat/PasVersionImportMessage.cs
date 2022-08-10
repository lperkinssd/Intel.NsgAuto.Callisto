namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class PasVersionImportMessage : ImportMessage
    {
        public long Id { get; set; }
        public int VersionId { get; set; }
        public long RecordId { get; set; }
    }
}
