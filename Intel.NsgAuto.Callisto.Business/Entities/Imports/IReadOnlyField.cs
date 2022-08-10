namespace Intel.NsgAuto.Callisto.Business.Entities.Imports
{
    public interface IReadOnlyField
    {
        string ColumnName { get; }

        bool ColumnRequired { get; }

        string DisplayName { get; }

        string Name { get; }
    }
}
