using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class Disposition : IDisposition
    {
        public int Id { get; set; }
        public int Version { get; set; }
        public string SLot { get; set; }
        public string IntelPartNumber { get; set; }         
        public LotDispositionReason Reason { get; set; }
        public LotDispositionAction Action { get; set; }
        public string Notes { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
