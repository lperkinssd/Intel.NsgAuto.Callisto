using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers
{
   public class PCNApproverFilter : IPCNApproverFilter
    {
       public ProductCodeName ProductCodeName { get; set; }

        public AccountCustomer AccountCustomer { get; set; }
    }
}
