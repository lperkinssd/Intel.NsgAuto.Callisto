using System;

namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    public static class DateTimeExtensions
    {
        public static DateTime SpecifyKindUtc(this DateTime value)
        {
            return DateTime.SpecifyKind(value, DateTimeKind.Utc);
        }

        public static DateTime? SpecifyKindUtc(this DateTime? value)
        {
            if (!value.HasValue) return value;
            return DateTime.SpecifyKind(value.Value, DateTimeKind.Utc);
        }
    }
}
