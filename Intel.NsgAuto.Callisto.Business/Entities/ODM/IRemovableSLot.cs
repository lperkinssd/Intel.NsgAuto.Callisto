using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface IRemovableSLot
    {
        string MMNum { get; set; }
        string DesignId { get; set; }
        string MediaIPN { get; set; }
        string SLot { get; set; }
        DateTime CreateDate { get; set; }
        string IsRemovable { get; set; }

        string OdmName { get; set; }
        string SourceFileName { get; set; }
    }
}
