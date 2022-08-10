using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
   public class ProductOwnershipMetaData : IProductOwnershipMetaData
    {
       

        public ProductOwnershipLookup ProductOwnershipLookup { get; set; }
        public ProductOwnerships ProductOwnerships { get; set; }

        
    }
}
