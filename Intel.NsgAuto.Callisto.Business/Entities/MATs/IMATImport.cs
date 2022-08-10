using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public interface IMATImport
    {
        int RecordNumber { get; set; }
        string SsdId { get; set; }
        string DesignId { get; set; }
        string Scode { get; set; }
        string MediaIPN { get; set; }
        string MediaType { get; set; }
        string DeviceName { get; set; }
        string CellRevision { get; set; }
        string MajorProbeProgramRevision { get; set; }
        string ProbeRevision { get; set; }
        string BurnTapeRevision { get; set; }
        string CustomTestingReqd { get; set; }
        string CustomTestingReqd2 { get; set; }
        string ProductGrade { get; set; }
        string PrbConvId { get; set; }
        string FabExcrId { get; set; }
        string FabConvId { get; set; }
        string ReticleWaveId { get; set; }
        string FabFacility { get; set; }
    }
}
