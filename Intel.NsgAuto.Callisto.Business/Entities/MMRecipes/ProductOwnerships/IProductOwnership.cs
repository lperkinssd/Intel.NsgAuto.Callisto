using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    interface IProductOwnership
    {
        int Id { get; set; }
        ProductType ProductType { get; set; }
        ProductPlatform ProductPlatform { get; set; }

        ProductCodeName ProductCodeName { get; set; }

        string ProductClassification { get; set; }
        ProductBrandName ProductBrandName { get; set; }
        ProductLifeCycleStatus ProductLifeCycleStatus { get; set; }
        string ProductLaunchDate { get; set; }

        string PME { get; set; }
        string PMT { get; set; }
        string TME { get; set; }
        string PDT { get; set; }
        string PQE { get; set; }
        string Others { get; set; }
        string PMEManager { get; set; }
        string PMEManagerBackup { get; set; }

        string PMTManager { get; set; }

        string PMTManagerBackup { get; set; }

        bool RecordChanged { get; set; }
        ProductContactRoles ProductContactRoles { get; set; }
        //ProductContactRole PME { get; set; }

        //ProductContactRole TME { get; set; }

        //ProductContactRole PMT { get; set; }

        //ProductContactRole PDT { get; set; }

        //ProductContactRole PQE { get; set; }

        //ProductContactRole Others { get; set; }

        //string Email { get; set; }
        bool IsActive { get; set; }

         string CreatedBy { get; set; }
         DateTime CreatedOn { get; set; }

         string UpdatedBy { get; set; }
         DateTime UpdatedOn { get; set; }
    }
}
