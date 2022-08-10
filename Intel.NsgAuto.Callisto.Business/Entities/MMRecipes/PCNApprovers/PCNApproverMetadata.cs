using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers
{
    public class PCNApproverMetadata: IPCNApproverMetaData
    {
        public ProductCodeNames ProductCodeNames { get; set; }

       public AccountCustomers AccountCustomers { get; set; }
    }
}
