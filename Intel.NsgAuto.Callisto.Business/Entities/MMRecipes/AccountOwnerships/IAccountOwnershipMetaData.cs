using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    interface IAccountOwnershipMetaData
    {
        AccountOwnershipLookup AccountOwnershipLookup { get; set; }
        AccountOwnerships AccountOwnerships { get; set; }
    }
}
