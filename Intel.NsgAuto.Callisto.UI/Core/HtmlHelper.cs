using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Intel.NsgAuto.Callisto.UI.Core
{
    public static class HtmlHelper
    {
        public static string ToHtmlEncoded(this string value)
        {
            string result = value;
            if (!String.IsNullOrEmpty(value))
            {
                result = HttpUtility.HtmlEncode(value);
            }
            return result;
        }
        public static string ToHtmlDecoded(this string value)
        {
            string result = value;
            if (!String.IsNullOrEmpty(value))
            {
                result = HttpUtility.HtmlDecode(value);
            }
            return result;
        }
    }
}