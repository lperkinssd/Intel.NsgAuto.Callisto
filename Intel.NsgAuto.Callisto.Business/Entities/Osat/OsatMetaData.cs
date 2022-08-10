using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class OsatMetaData:IOsatMetaData
    {
        public Products Products { get; set; }
        public VersionNames VersionNames { get; set; }

        public Osats Osats { get; set; }
    }
}
