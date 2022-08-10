using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface IDisposition
    {
        int Id { get; set; }
        int Version { get; set; }
        string SLot { get; set; }
        string IntelPartNumber { get; set; }       
        LotDispositionReason Reason { get; set; }
        LotDispositionAction Action { get; set; }
        string Notes { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
