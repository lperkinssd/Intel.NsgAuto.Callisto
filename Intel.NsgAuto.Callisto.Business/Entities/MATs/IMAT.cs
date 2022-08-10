using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public interface IMAT
    {
        int Id { get; set; }
        IdAndName MATSsdId { get; set; }
        IdAndName MATDesignId { get; set; }
        string Scode { get; set; }
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
        string MediaIPN { get; set; }
        string FabFacility { get; set; }
        string MediaType { get; set; }
        string DeviceName { get; set; }
        MATAttributes Attributes { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
