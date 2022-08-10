using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models.MM
{
    public class ProductOwnershipsModel: LayoutModel
    {
        public ProductOwnershipMetaData ProductOwnerships { get; set; }

    }
}