using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    interface IVersionName
    {
        int Osatid { get; set; }
        int Id { get; set; }
        string Name { get; set; }
        string VName { get; set; }
    }
}
