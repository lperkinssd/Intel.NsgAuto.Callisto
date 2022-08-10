using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers
{
    interface IPCNApproverFilter
    {

        ProductCodeName ProductCodeName { get; set; }

        AccountCustomer AccountCustomer { get; set; }
    }
}
