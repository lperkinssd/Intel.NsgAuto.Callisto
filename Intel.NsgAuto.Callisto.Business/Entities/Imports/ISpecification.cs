namespace Intel.NsgAuto.Callisto.Business.Entities.Imports
{
    public interface ISpecification : IReadOnlySpecification
    {
        new bool IsFirstRowColumnRow { get; set; }

        new bool MatchColumnsByName { get; set; }

        new int RowDataBegins { get; set; }

        new string WorksheetName { get; set; }
    }
}
