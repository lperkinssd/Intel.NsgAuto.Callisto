using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    public class AccountContactRole: IAccountContactRole
    {
       public string ContactId { get; set; }
        public string ContactName { get; set; }
        public string RoleName { get; set; }

       public string Email { get; set; }

        public string AlternateEmail { get; set; }
        public string WWID { get; set; }

        public string idSid { get; set; }
    }
}
