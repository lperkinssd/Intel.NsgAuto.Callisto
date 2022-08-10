using Intel.NsgAuto.Web.Mvc.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Intel.NsgAuto.Web.Mvc.Controllers
{
    public class HomeController : LayoutController
    {
        // GET: Home
        public ActionResult Index()
        {
            HomeModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.HomeModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {                
            }

            return View(model);
        }
    }
}