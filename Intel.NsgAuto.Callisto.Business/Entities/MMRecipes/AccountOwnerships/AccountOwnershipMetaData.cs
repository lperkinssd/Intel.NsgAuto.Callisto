using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    public class AccountOwnershipMetaData :IAccountOwnershipMetaData
    {
        public AccountOwnershipLookup AccountOwnershipLookup { get; set; }
        public AccountOwnerships AccountOwnerships { get; set; }
    }
}
