using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class NonQualifiedMedia
    {
        public int ScenarioId { get; set; }
        public string MMNum { get; set; }
        public string OdmName { get; set; }
        public string DesignId { get; set; }
        public string SLots { get; set; }
        public int MatId { get; set; }
        public int PrfId { get; set; }
        public string OsatIpn { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
