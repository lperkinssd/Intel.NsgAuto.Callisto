using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models;
using Intel.NsgAuto.Shared.Extensions;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using Intel.NsgAuto.Web.Mvc.Models;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class SpeedItemsController : LayoutController
    {
        public ActionResult Index(string id)
        {
            if (id.IsNeitherNullNorEmpty())
            {
                int cleanedId = id.ToIntegerSafely();
                if (cleanedId.IsNotNull() && cleanedId > 0)
                {
                    return RedirectToAction("Details", cleanedId.ToStringSafely());
                }
            }
            return RedirectToAction("List");
        }

        public ActionResult List()
        {
            LayoutModel model = CreateLayout(new LayoutModel());
            return View(model);
        }

        public ActionResult Details(string id)
        {
            SpeedItemModel model = CreateLayout(new SpeedItemModel());
            if (id.IsNeitherNullNorEmpty())
            {
                int cleanedId = id.ToIntegerSafely();
                if (cleanedId.IsNotNull() && cleanedId > 0)
                {
                    model.Item = new SpeedItemsService().Get(Functions.GetLoggedInUserId(), cleanedId.ToStringSafely());
                }
                if (model.Item.IsNull()) {
                    return RedirectToAction("List");
                }
            }
            else
            {
                RedirectToAction("List");
            } 
            return View(model);
        }
    }
}
