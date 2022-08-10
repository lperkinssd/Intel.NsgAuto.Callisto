using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    interface IOsatMetaData 
    {

        Products Products { get; set; }
        VersionNames VersionNames { get; set; }

        Osats Osats { get; set; }

    }
}
