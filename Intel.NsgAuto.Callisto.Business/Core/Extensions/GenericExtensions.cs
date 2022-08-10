using Newtonsoft.Json;

namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
   public static class GenericExtensions
    {
        public static T Clone<T>(this T original)
        {
            return JsonConvert.DeserializeObject<T>(JsonConvert.SerializeObject(original));
        }
    }
}
