using Newtonsoft.Json;
using System.Web;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.HtmlHelpers
{
    public static class JsonHelper
    {
        public static IHtmlString Serialize(object obj)
        {
            var settings = new JsonSerializerSettings { StringEscapeHandling = StringEscapeHandling.EscapeHtml };
            return MvcHtmlString.Create(JsonConvert.SerializeObject(obj, settings));
        }
    }
}