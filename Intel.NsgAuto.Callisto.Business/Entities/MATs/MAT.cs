using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public class MAT: IMAT
    {
        public int Id { get; set; }
        public IdAndName MATSsdId { get; set; }
        public IdAndName MATDesignId { get; set; }
        public string Scode { get; set; }
        public string CellRevision { get; set; }
        public string MajorProbeProgramRevision { get; set; }
        public string ProbeRevision { get; set; }
        public string BurnTapeRevision { get; set; }
        public string CustomTestingReqd { get; set; }
        public string CustomTestingReqd2 { get; set; }
        public string ProductGrade { get; set; }
        public string PrbConvId { get; set; }
        public string FabExcrId { get; set; }
        public string FabConvId { get; set; }
        public string ReticleWaveId { get; set; }
        public string MediaIPN { get; set; }
        public string FabFacility { get; set; }
        public string MediaType { get; set; }
        public MATAttributes Attributes { get; set; }
        public string DeviceName { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
