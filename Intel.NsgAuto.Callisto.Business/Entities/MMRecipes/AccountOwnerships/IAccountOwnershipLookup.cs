using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    interface IAccountOwnershipLookup
    {
        AccountClients AccountClients { get; set; }
        AccountCustomers AccountCustomers { get; set; }
        AccountSubsidiaries AccountSubsidiaries { get; set; }
        AccountProducts AccountProducts { get; set; }

     
        AccountRoles AccountRoles { get; set; }
     
    }
}
