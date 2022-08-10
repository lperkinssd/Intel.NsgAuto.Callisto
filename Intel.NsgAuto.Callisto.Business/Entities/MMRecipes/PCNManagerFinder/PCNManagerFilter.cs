using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder
{
   public class PCNManagerFilter : IPCNManagerFilter
    {
       public ProductCodeName ProductCodeName { get; set; }

        public AccountCustomer AccountCustomer { get; set; }

        public PCNManagerRole PCNManagerRole { get; set; }
    }
}
