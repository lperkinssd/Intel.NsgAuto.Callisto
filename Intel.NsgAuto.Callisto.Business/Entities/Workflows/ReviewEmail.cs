namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewEmail
    {
        public long VersionId { get; set; }
        public int EmailTemplateId { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public string Bcc { get; set; }
        public string RecipientName { get; set; }
        public string ReviewAtDescription { get; set; }
        public string VersionDescription { get; set; }
    }
}
