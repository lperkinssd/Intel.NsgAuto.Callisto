using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    public class ProductContactRole : IProductContactRole
    {
        public int ContactId { get; set; }

        public int ProductOwnershipId { get; set; }

        public string ContactName { get; set; }

        public string RoleName { get; set; }

        public string Email { get; set; }

        public string AlternateEmail { get; set; }

        public string WWID { get; set; }

        public string idSid { get; set; }
    }
}
