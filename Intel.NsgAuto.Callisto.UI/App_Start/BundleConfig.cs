using System.Web.Optimization;

namespace Intel.NsgAuto.Web.Mvc
{
    public class BundleConfig
    {
        /// <summary>
        /// Registers all scripts and styles to be delivered as bundles
        /// </summary>
        /// <param name="bundles"></param>
        public static void RegisterBundles(BundleCollection bundles)
        {
            // add the  style bundle for minified compressed delivery
            //bundles.Add(new StyleBundle("~/bundles/dxcss").Include(
            //    "~/Styles/dx/dx.common.css",
            //    "~/Styles/dx/dx.light.css",
            //    "~/Styles/fa/css/fontawesome.min.css"));
            bundles.Add(new StyleBundle("~/bundles/nsgacss").Include(
                "~/Styles/nsga/core.css",
                "~/Styles/fa/css/all.min.css")
                //.IncludeDirectory("~/Styles/fa/webfonts", "*.eot", false)
                //.IncludeDirectory("~/Styles/fa/webfonts", "*.ttf", false)
                //.IncludeDirectory("~/Styles/fa/webfonts", "*.woff", false)
                //.IncludeDirectory("~/Styles/fa/webfonts", "*.woff2", false)
                //.IncludeDirectory("~/Styles/fa/webfonts", "*.svg", false)
                );
            bundles.Add(new StyleBundle("~/bundles/appcss").IncludeDirectory(
                "~/Styles/nsga/app", "*.css", true));
            // add the bundle for minified compressed delivery
            bundles.Add(new ScriptBundle("~/bundles/Scripts/jquery").Include(
                  "~/Scripts/jquery-{version}.js",
                  "~/Scripts/jquery.validate.js",
                  "~/Scripts/jszip.js"));
            bundles.Add(new ScriptBundle("~/bundles/Scripts/dx").Include(
                  "~/Scripts/dx/dx.all.js"));
            bundles.Add(new ScriptBundle("~/bundles/Scripts/nsgajs").Include(
                  "~/Scripts/nsga/Nsga.js",
                  "~/Scripts/nsga/Nsga.Framework.js",
                  "~/Scripts/nsga/Nsga.MainMenu.js",
                  "~/Scripts/nsga/Nsga.ToolBar.js",
                  "~/Scripts/nsga/Nsga.ClearOnfocus.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/scripts/appjs").IncludeDirectory(
                "~/Scripts/appjs", "*.js", true));


            bundles.Add(new ScriptBundle("~/bundles/Scripts/handlebars").Include(
                "~/Scripts/handlebars.min-v4.7.7.js"));

            BundleTable.EnableOptimizations = true;
        }
    }
}

