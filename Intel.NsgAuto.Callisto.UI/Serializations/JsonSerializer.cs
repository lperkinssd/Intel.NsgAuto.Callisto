using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace Intel.NsgAuto.Web.Mvc.Serializations
{
    public class JsonSerializer
    {
        /// <summary>
        /// Serializes an object of type T to Json string 
        /// </summary>
        /// <exception cref="InvalidOperationException">InvalidOperationException</exception>
        /// <exception cref="ArgumentException">ArgumentException</exception>
        /// <exception cref="ArgumentNullException">ArgumentException</exception>
        public static string Serialize<T>(T t)
        {
            StringBuilder sb = new StringBuilder();
            JavaScriptSerializer serializer = new JavaScriptSerializer()
            {
                MaxJsonLength = int.MaxValue
            };
            serializer.Serialize(t, sb);
            return sb.ToString();
        }
        /// <summary>
        /// Deserializes a Json string to an object
        /// If Json string is null or empty or white space, default(T) will be returned.
        /// </summary>
        /// <exception cref="ArgumentException">ArgumentException</exception>
        /// <exception cref="InvalidOperationException">InvalidOperationException</exception>
        public static T Deserialize<T>(string jsonString)
        {
            T t = default(T);
            if (! String.IsNullOrEmpty(jsonString) )
            {
                t = new JavaScriptSerializer().Deserialize<T>(jsonString);
            }
            return t;
        }
    }
}