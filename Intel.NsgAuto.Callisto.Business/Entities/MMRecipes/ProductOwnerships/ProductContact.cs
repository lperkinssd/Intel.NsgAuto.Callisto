using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    public class ProductContact :IProductContact
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string WWID { get; set; }

        public string idSid { get; set; }

        public string Email { get; set; }

        public string AlternateEmail { get; set; }


    }
}
