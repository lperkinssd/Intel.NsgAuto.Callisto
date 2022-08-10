using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder
{
    interface IApprover
    {
        string ContactName { get; set; }
        string RoleName { get; set; }

        string Email { get; set; }
    }
}
