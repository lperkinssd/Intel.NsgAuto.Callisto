using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder
{
    public class PCNRole : IPCNRole
    {
       public string Role { get; set; }
        public string Name { get; set; }

        public string Email { get; set; }
    }
}
