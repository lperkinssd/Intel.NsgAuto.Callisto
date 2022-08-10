using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Models;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class HelpController : LayoutController
    {
        public ActionResult Support()
        {
            LayoutModel model = CreateLayout(new LayoutModel());
            return View(model);
        }
    }
}