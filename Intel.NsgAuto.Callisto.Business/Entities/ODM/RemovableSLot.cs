using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class RemovableSLot : IRemovableSLot
    {
        public string MMNum { get; set; }
        public string DesignId { get; set; }
        public string MediaIPN { get; set; }
        public string SLot { get; set; }
        public DateTime CreateDate { get; set; }
        public string IsRemovable { get; set; }
        public string OdmName { get; set; }
        public string SourceFileName { get; set; }
    }
}
