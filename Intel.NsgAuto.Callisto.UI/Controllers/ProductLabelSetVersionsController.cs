using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using Intel.NsgAuto.Web.Mvc.Models;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class ProductLabelSetVersionsController : LayoutController
    {
        public ActionResult Index()
        {
            return RedirectToAction("List");
        }

        public ActionResult List()
        {
            LayoutModel model = CreateLayout(new LayoutModel());
            return View(model);
        }

        public ActionResult Details(int? id)
        {
            if (!id.HasValue) return RedirectToAction("List");
            ProductLabelSetVersionModel model = CreateLayout(new ProductLabelSetVersionModel());
            string userId = Functions.GetLoggedInUserId();
            model.LoggedInUserId = userId;
            ProductLabelSetVersionsService service = new ProductLabelSetVersionsService();
            model.Version = service.Get(userId, id.Value);
            if (model.Version == null) return RedirectToAction("List");
            model.ProductLabels = service.GetProductLabels(userId, id.Value);
            return View(model);
        }
    }
}