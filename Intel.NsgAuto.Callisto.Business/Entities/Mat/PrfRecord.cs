namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class PrfRecord
    {
        public string WorkWeek { get; set; }
        public string ODMDescription { get; set; }
        public string SSDFamilyName { get; set; }
        public string MMNumber { get; set; }
        public string ProductCode { get; set; }
        public string SSDName { get; set; }
        public System.DateTime CreateDate { get; set; }
        public string Latest_Record { get; set; }
        public string FileType { get; set; }
        public long Total { get; }
    }
}
