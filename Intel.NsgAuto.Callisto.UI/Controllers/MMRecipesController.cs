using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class MMRecipesController : LayoutController
    {
        public ActionResult Index()
        {
            MMRecipesModel model = CreateLayout(new MMRecipesModel());
            return View(model);
        }

        public ActionResult Details(long? id)
        {
            if (!id.HasValue) return RedirectToAction("List");
            MMRecipeDetailsModel model = CreateLayout(new MMRecipeDetailsModel());
            model.Entity = new MMRecipesService().GetDetails(Functions.GetLoggedInUserId(), id.Value);
            return View(model);
        }

        public ActionResult List()
        {
            MMRecipesModel model = CreateLayout(new MMRecipesModel());
            return View(model);
        }

        // id parameter is the pcode; named differently due to routing convention
        public ActionResult Simulate(string id)
        {
            MMRecipeDetailsModel model = CreateLayout(new MMRecipeDetailsModel());
            var item = new MMRecipesService().SimulateDetails(Functions.GetLoggedInUserId(), id);
            model.Entity = new MMRecipesService().SimulateDetails(Functions.GetLoggedInUserId(), id);
            return View(model);
        }
    }
}