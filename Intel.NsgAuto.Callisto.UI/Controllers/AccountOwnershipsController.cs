using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models.MM;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using Intel.NsgAuto.Callisto.Business.Logging;
using log4net;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class AccountOwnershipsController : LayoutController
    {
        // GET: AccountOwnership
        public ActionResult Index()
        {
            AccountOwnershipsModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new AccountOwnershipsModel());
                model.AccountOwnerships = new AccountOwnershipService().GetAll(Functions.GetLoggedInUserId());

                // TO DO: Get product ownership matrix and assign to the model to display in the view
                //   model.ProductOwnerships = new ProductOwnershipService().GetAll(Functions.GetLoggedInUserId());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                Log.Error("Account Ownership Index Method ", ex);
                throw ex;
            }
            finally
            {
            }


            return View(model);
        }
    }
}