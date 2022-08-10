namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterImportMessage
    {
        public long Id { get; set; }

        public int ImportId { get; set; }

        public string MessageType { get; set; }

        public string Message { get; set; }

        public int? GroupIndex { get; set; }

        public int? GroupSourceIndex { get; set; }

        public int? CriteriaIndex { get; set; }

        public int? CriteriaSourceIndex { get; set; }

        public int? GroupFieldIndex { get; set; }

        public int? GroupFieldSourceIndex { get; set; }

        public string GroupFieldName { get; set; }
    }
}
