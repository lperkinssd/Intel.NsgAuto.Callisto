using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.Business.Entities.Imports
{
    public interface IReadOnlySpecification
    {
        IReadOnlyList<IReadOnlyField> Fields { get; }

        bool IsFirstRowColumnRow { get; }

        bool MatchColumnsByName { get; }

        int RowDataBegins { get; }

        string WorksheetName { get; }

        IReadOnlyField Field(string fieldName);
    }
}
