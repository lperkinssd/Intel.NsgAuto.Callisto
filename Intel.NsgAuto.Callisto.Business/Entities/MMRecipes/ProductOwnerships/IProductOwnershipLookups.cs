using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    interface IProductOwnershipLookups
    {
        ProductTypes ProductTypes { get; set; }
        ProductPlatforms ProductPlatforms { get; set; }

        ProductCodeNames ProductCodeNames { get; set; }

        ProductBrandNames ProductBrandNames { get; set; }

        ProductLifeCycleStatuses ProductLifeCycleStatuses { get; set; }

        ProductContacts ProductContacts { get; set; }

        ProductRoles ProductRoles { get; set; }    

        ProductContactRoles ProductContactRoles { get; set; }
    }
}
