using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models.MM
{
    public class AccountOwnershipsModel : LayoutModel
    {
        public AccountOwnershipMetaData AccountOwnerships { get; set; }
    }
}