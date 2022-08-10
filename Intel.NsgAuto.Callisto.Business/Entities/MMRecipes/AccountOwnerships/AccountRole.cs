using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    public class AccountRole: IAccountRole
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public bool? PCN { get; set; }

    }
}
