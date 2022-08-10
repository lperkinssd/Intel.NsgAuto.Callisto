using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    public class EmailRecord: IEmailRecord
    {
        public string AccountName { get; set; }
        public string Email { get; set; }
        public string RoleName { get; set; }
        public string Type { get; set; }

        //public string Product { get; set; }

        //public string AddRole { get; set; }
    }
}
