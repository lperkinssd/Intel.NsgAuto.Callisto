using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    interface IEmailRecord
    {
        string AccountName { get; set; }
        string Email { get; set; }
        string RoleName { get; set; }
        string Type { get; set; }

        string Product { get; set; }
    }
}
