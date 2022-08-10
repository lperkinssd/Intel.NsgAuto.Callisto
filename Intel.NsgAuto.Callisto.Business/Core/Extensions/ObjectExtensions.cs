using System;

namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    public static class ObjectExtensions
    {
        public static object NullToDBNull(this object value)
        {
            if (value == null) return DBNull.Value;
            return value;
        }

        public static long ToLongSafely(this object value)
        {
            if (value == null || value == DBNull.Value) return default;
            return (value as long?) ?? default;
        }

        public static long? ToNullableLongSafely(this object value)
        {
            if (value == null || value == DBNull.Value) return default;
            return (value as long?) ?? default;
        }

        public static byte? ToNullableByteSafely(this object value)
        {
            if (value == null || value == DBNull.Value) return default;
            return (value as byte?) ?? default;
        }
    }
}
