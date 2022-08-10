using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    public class AccountOwnershipLookup: IAccountOwnershipLookup
    {
       public AccountClients AccountClients { get; set; }


        public AccountCustomers AccountCustomers { get; set; }
        public AccountSubsidiaries AccountSubsidiaries { get; set; }
        public AccountProducts AccountProducts { get; set; }

  

        public AccountRoles AccountRoles { get; set; }
    }
}
