using System;

namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    public static class NullableTypeExtensions
    {
        public static object NullToDBNull<T>(this T? item) where T : struct
        {
            if (!item.HasValue) return DBNull.Value;
            return item.Value;
        }
    }
}
