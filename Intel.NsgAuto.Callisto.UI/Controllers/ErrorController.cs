using System.Net;
using System.Web;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class ErrorController : Controller
    {
        public ActionResult Index(string aspxerrorpath)
        {
            return View();
        }
        public ActionResult NotFound(string aspxerrorpath)
        {
            return View();
        }
        public ActionResult AccessDenied(string aspxerrorpath)
        {
            return View();
        }

        // TODO: for testing purposes, remove these later
        public ActionResult TestException()
        {
            throw new System.Exception("Test exception");
        }
        public ActionResult TestAccessDenied()
        {
            throw new HttpException((int)HttpStatusCode.Forbidden, "You are unauthorized use this system. Request access before proceeding.");
        }
    }
}