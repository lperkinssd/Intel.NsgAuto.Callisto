namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class MatRecord
    {
        public int RecordNumber { get; set; }
        public string WorkWeek { get; set; }
        public string SSDId { get; set; }
        public string DesignId { get; set; }
        public string Scode { get; set; }
        //public string Family { get; set; }
        //public string CMOS_Revision { get; set; }
        public string MPPR { get; set; }
        public string ProbeRevision { get; set; }
        public string BurnTapeRevision { get; set; }
        public string CellRevision { get; set; }
        public string CustomTestingRequired { get; set; }
        public string CustomTestingRequired2 { get; set; }
        public string ProductGrade { get; set; }
        public string PrbConvId { get; set; }
        public string FabConvId { get; set; }
        public string FabExcrId { get; set; }
        public string MediaType { get; set; }
        public string MediaIPN { get; set; }
        public string DeviceName { get; set; }
        public string ReticleWaveId { get; set; }
        public string FabFacility { get; set; }
        public bool Latest { get; set; }
        public string FileType { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
    }
}
