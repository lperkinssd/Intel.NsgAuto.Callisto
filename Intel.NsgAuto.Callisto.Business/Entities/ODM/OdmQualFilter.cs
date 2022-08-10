using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class OdmQualFilter
    {
        public int QualId { get; set; }
        public string MMNum { get; set; }
        public string OdmName { get; set; }
        public string DesignId { get; set; }
        public string SLots { get; set; }
        public string OsatIpn { get; set; }
        public int MatId { get; set; }
        public int PrfId { get; set; }
        public DateTime CreateDate { get; set; }
        public string UserId { get; set; }
        public string Latest { get; set; }
    }
}
