using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    public class ProductOwnershipLookup
    {
        public ProductTypes ProductTypes { get; set; }
        public ProductPlatforms ProductPlatforms { get; set; }

        public ProductCodeNames ProductCodeNames { get; set; }

        public ProductBrandNames ProductBrandNames { get; set; }

        public ProductLifeCycleStatuses ProductLifeCycleStatuses { get; set; }

        public ProductContacts ProductContacts { get; set; }

        public ProductRoles ProductRoles { get; set; }

        public ProductContactRoles ProductContactRoles { get; set; }
    }
}
