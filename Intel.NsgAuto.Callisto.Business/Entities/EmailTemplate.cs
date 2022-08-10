namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class EmailTemplate : IReadOnlyEmailTemplate
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsHtml { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public EmailTemplateBodyXsl BodyXsl { get; set; }
        string IReadOnlyEmailTemplate.BodyXsl
        {
            get
            {
                if (BodyXsl == null) return null;
                return BodyXsl.Value;
            }
        }
        public string BodyXml { get; set; }
    }
}
