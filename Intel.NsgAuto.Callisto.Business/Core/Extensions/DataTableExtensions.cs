using Intel.NsgAuto.Shared.Extensions;
using System.Data;

namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    public static class DataTableExtensions
    {
        public static string FieldToStringSafely(this DataRow row, string fieldName)
        {
            if (row != null && row.Table != null && row.Table.Columns.Contains(fieldName))
            {
                return row[fieldName].ToStringSafely();
            }
            return string.Empty;
        }
    }
}
