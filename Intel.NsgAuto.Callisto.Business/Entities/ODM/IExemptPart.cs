namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface IExemptPart
    {
        string OdmName { get; set; }
        string ScodeMm { get; set; }
        string MediaIpn { get; set; }
        string SLot { get; set; }
        string SSD_Id { get; set; }
        string Design_Id { get; set; }
        string Device_Name { get; set; }
        string Media_Type { get; set; }
    }
}
