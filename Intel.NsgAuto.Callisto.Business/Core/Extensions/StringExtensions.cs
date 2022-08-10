namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    public static class StringExtensions
    {
        public static string AddPrefix(this string value, string prefix)
        {
            if (string.IsNullOrEmpty(prefix)) return value;
            return prefix + value;
        }
    }
}
