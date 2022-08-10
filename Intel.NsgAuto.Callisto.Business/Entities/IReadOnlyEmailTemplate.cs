namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public interface IReadOnlyEmailTemplate
    {
        int Id { get; }
        string Name { get; }
        bool IsHtml { get; }
        string Subject { get; }
        string Body { get; }
        string BodyXsl { get; }
        string BodyXml { get; }
    }
}
