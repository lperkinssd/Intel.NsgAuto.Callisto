namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class OdmWip
    {
        public int Version { get; set; }
        public string MediaLotId { get; set; }
        public string SubConName { get; set; }
        public string IntelPartNumber { get; set; }
        public string LocationType { get; set; }
        public string InventoryLocation { get; set; }
        public string Category { get; set; }
        public string MmNumber { get; set; }
        public System.DateTime TimeEntered { get; set; }
    }
}