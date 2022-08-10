namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface INonQualifiedPart
    {
        string MMNum { get; set; }
        string OdmName { get; set; }
        string DesignId { get; set; }
        string Media_IPN { get; set; }
        string SLots { get; set; }
        string CreateDate { get; set; }
    }
}
