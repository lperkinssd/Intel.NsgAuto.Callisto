using Intel.NsgAuto.Web.Mvc.Core;
using Intel.NsgAuto.Web.Mvc.Models;
using System.Web.Mvc;

namespace Intel.NsgAuto.Web.Mvc.Controllers
{
    public abstract class LayoutController : Controller
    {
        /// <summary>
        /// Creates the current model's layout view model
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="t"></param>
        /// <returns></returns>
        protected T CreateLayout<T>(T t) where T : LayoutModel, new()
        {
            if (t == null)
            {
            }
            return t;
        }

        // code to handle/log any exceptions that occur in (non-api) controllers as they all inherit this class
        protected override void OnException(ExceptionContext filterContext)
        {
            if (!filterContext.ExceptionHandled)
            {
                Functions.LogException(filterContext.Exception);

                ////NOTE: ErrorController should not inherit this LayoutController (or need to add code to check for that), otherwise circular redirections could potentially occur
                //filterContext.Result = RedirectToAction("Index", "Error");
                //filterContext.ExceptionHandled = true;
            }
        }
    }
}