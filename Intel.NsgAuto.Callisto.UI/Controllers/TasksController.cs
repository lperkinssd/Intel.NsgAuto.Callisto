using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using Intel.NsgAuto.Web.Mvc.Models;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class TasksController : LayoutController
    {
        public ActionResult Index(long? id)
        {
            if (id.HasValue) return RedirectToAction("Details", id);
            return RedirectToAction("List");
        }

        public ActionResult List()
        {
            LayoutModel model = CreateLayout(new LayoutModel());
            return View(model);
        }

        public ActionResult Details(long? id)
        {
            if (!id.HasValue) return RedirectToAction("List");
            TaskModel model = CreateLayout(new TaskModel());
            TasksService service = new TasksService();
            model.Task = service.Get(Functions.GetLoggedInUserId(), id.Value);
            if (model.Task == null) return RedirectToAction("List");
            model.Messages = service.GetMessages(Functions.GetLoggedInUserId(), id.Value);
            return View(model);
        }
    }
}