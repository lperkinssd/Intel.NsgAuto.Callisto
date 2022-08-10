using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Http;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Optimization;
using Intel.NsgAuto.Callisto.UI.Controllers;
using log4net;


namespace Intel.NsgAuto.Web.Mvc
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            log4net.Config.XmlConfigurator.Configure();

            //Functions.InitializeApplication();
        }

        protected void Session_Start()
        {
            //Functions.InitializeSession();
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            var httpContext = HttpContext.Current;
            Exception ex = Server.GetLastError();
            Functions.LogException(ex);

            int httpCode = 500;
            HttpException httpEx;
            if (ex is HttpException)
            {
                httpEx = ex as HttpException;
            }
            else
            {
                httpEx = ex.InnerException as HttpException;
            }
            if (httpEx != null) httpCode = httpEx.GetHttpCode();

            string action;
            switch (httpCode)
            {
                case 404:
                    action = "NotFound";
                    break;
                case 403:
                    action = "AccessDenied";
                    break;
                default:
                    action = "Index";
                    break;
            }

            httpContext.ClearError();
            httpContext.Response.Clear();
            httpContext.Response.TrySkipIisCustomErrors = true;

            var routeData = new RouteData();
            routeData.Values["controller"] = "Error";
            routeData.Values["action"] = action;

            // note: potential circular redirect in the (hopefully rare) case where the exception occurred in the Error view/controller itself
            // might be better to check for that and if so just show the blank response
            var controller = new ErrorController();
            ((IController)controller).Execute(new RequestContext(new HttpContextWrapper(httpContext), routeData));

        }
    }
}