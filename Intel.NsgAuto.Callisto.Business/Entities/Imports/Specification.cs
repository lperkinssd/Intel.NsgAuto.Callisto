namespace Intel.NsgAuto.Callisto.Business.Entities.Imports
{
    public class Specification : ReadOnlySpecification, ISpecification
    {
        public new bool IsFirstRowColumnRow
        {
            get
            {
                return base.IsFirstRowColumnRow;
            }
            set
            {
                base.IsFirstRowColumnRow = value;
            }
        }

        public new bool MatchColumnsByName
        {
            get
            {
                return base.MatchColumnsByName;
            }
            set
            {
                base.MatchColumnsByName = value;
            }
        }

        public new int RowDataBegins
        {
            get
            {
                return base.RowDataBegins;
            }
            set
            {
                base.RowDataBegins = value;
            }
        }

        public new string WorksheetName
        {
            get
            {
                return base.WorksheetName;
            }
            set
            {
                base.WorksheetName = value;
            }
        }

        public Specification(bool isFirstRowColumnRow = true, int? rowDataBegins = null, string worksheetName = null, bool? matchColumnsByName = null)
            : base(isFirstRowColumnRow: isFirstRowColumnRow, rowDataBegins: rowDataBegins, worksheetName: worksheetName, matchColumnsByName: matchColumnsByName)
        {
        }
    }
}
