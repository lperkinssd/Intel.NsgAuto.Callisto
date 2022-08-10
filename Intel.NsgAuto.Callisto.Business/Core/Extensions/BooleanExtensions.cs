namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    public static class BooleanExtensions
    {
        public static char ToYorN(this bool value)
        {
            if (value) return 'Y';
            return 'N';
        }
    }
}
