using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public class MATImport: IMATImport
    {
        public int RecordNumber { get; set; }
        public string SsdId { get; set; }
        public string DesignId { get; set; }
        public string Scode { get; set; }
        public string MediaIPN { get; set; }
        public string MediaType { get; set; }
        public string DeviceName { get; set; }
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
        public string FabFacility { get; set; }
    }
}
