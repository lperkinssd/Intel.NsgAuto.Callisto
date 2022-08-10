namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterRecordsQueryBase
    {
        public bool IncludePublishDisabled { get; set; }

        public bool IncludeStatusInReview { get; set; }

        public bool IncludeStatusSubmitted { get; set; }

        public bool IncludeStatusDraft { get; set; }
    }
}
