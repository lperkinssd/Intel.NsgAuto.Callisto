namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class ImportMessage
    {
        public int? RecordNumber { get; set; }
        public string FieldName { get; set; }
        public string MessageType { get; set; }
        public string Message { get; set; }
    }
}
