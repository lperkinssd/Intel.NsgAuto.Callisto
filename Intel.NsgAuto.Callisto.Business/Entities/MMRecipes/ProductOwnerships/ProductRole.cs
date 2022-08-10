using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    public class ProductRole : IProductRole
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool? PCN { get; set; }

    }
}
