using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder
{
    interface IPCNManagerMetaData
    {

        ProductCodeNames ProductCodeNames { get; set; }

        AccountCustomers AccountCustomers { get; set; }

        PCNManagerRoles PCNManagerRoles { get; set; }
    }
}
