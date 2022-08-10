using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    public static class IEnumerableExtensions
    {
        public static IEnumerable<T> Yield<T>(this T item)
        {
            yield return item;
        }
    }
}
