using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    public class ProductOwnership :IProductOwnership
    {
        public int Id { get; set; }
        public ProductType ProductType { get; set; }
        public ProductPlatform ProductPlatform { get; set; }

        public ProductCodeName ProductCodeName { get; set; }

        public string ProductClassification { get; set; }
        public ProductBrandName ProductBrandName { get; set; }
        public ProductLifeCycleStatus ProductLifeCycleStatus { get; set; }
        public string ProductLaunchDate { get; set; }

       public string PME { get; set; }
        public string PMT { get; set; }
        public string TME { get; set; }
        public string PDT { get; set; }
        public string PQE { get; set; }
        public string Others { get; set; }
        public string PMEManager { get; set; }
        public string PMEManagerBackup { get; set; }

        public string PMTManager { get; set; }
         
        public string PMTManagerBackup { get; set; }

        public bool RecordChanged { get; set; }
        public ProductContactRoles ProductContactRoles { get; set; }
     

        public string Email { get; set; }
        public bool IsActive { get; set; }

        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }

        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }

    }
}
