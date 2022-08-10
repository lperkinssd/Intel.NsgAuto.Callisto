using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    interface IAccountOwnershipContact
    {
        int AccountOwnershipsContactId { get; set; }
        int AccountOwnershipId { get; set; }
        string AccountName { get; set; }
        string RoleName { get; set; }
        string WWID { get; set; }
        string idSid { get; set; }

        string Email { get; set; }

        string AlternateEmail { get; set; }
    }
}
