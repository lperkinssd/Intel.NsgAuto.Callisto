using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    public class AccountOwnershipContact :IAccountOwnershipContact
    {
        public int AccountOwnershipsContactId { get; set; }
        public int AccountOwnershipId { get; set; }
        public string AccountName { get; set; }
        public string RoleName { get; set; }
        public string WWID { get; set; }
        public string idSid { get; set; }

        public string Email { get; set; }

       public string AlternateEmail { get; set; }
    }
}
