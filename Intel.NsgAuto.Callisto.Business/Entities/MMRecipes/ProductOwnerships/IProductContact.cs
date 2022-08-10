using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships
{
    interface IProductContact
    {
        int Id { get; set; }

        string Name { get; set; }

        string WWID { get; set; }

        string idSid { get; set; }

        string Email { get; set; }

        string AlternateEmail { get; set; }


    }
}
