using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder
{
    interface IPCNRole
    {
        string Role { get; set; }
        string Name { get; set; }

        string Email { get; set; }
    }
}
