namespace Intel.NsgAuto.Callisto.Business.Entities.Imports
{
    public class ReadOnlyField : IReadOnlyField
    {
        public string ColumnName { get; }

        public bool ColumnRequired { get; }

        public string DisplayName { get; }

        public string Name { get; }

        public ReadOnlyField(string name, string columnName = null, string displayName = null, bool columnRequired = false)
        {
            Name = name;
            ColumnName = columnName ?? name;
            DisplayName = displayName ?? ColumnName;
            ColumnRequired = columnRequired;
        }
    }
}
