using System;
using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.Business.Entities.Imports
{
    public class ReadOnlySpecification : IReadOnlySpecification
    {
        private readonly Dictionary<string, ReadOnlyField> dictFields;

        private readonly List<ReadOnlyField> fields;

        public IReadOnlyList<ReadOnlyField> Fields => fields;
        IReadOnlyList<IReadOnlyField> IReadOnlySpecification.Fields => fields;

        public bool IsFirstRowColumnRow { get; protected set; }

        public bool MatchColumnsByName { get; protected set; }

        public int RowDataBegins { get; protected set; }

        public string WorksheetName { get; protected set; }

        public ReadOnlySpecification(bool isFirstRowColumnRow = true, int? rowDataBegins = null, string worksheetName = null, bool? matchColumnsByName = null)
        {
            if (rowDataBegins.HasValue && rowDataBegins.Value <= 0) throw new ArgumentOutOfRangeException("rowDataBegins", rowDataBegins, "If not null, must be greater than zero");
            if (rowDataBegins == null)
            {
                if (isFirstRowColumnRow) rowDataBegins = 2;
                else rowDataBegins = 1;
            }
            IsFirstRowColumnRow = isFirstRowColumnRow;
            RowDataBegins = rowDataBegins.Value;
            WorksheetName = worksheetName;
            MatchColumnsByName = matchColumnsByName ?? IsFirstRowColumnRow;
            dictFields = new Dictionary<string, ReadOnlyField>();
            fields = new List<ReadOnlyField>();
        }

        protected void AddField(ReadOnlyField field)
        {
            fields.Add(field);
            if (field.Name != null) dictFields[field.Name] = field;
        }

        public ReadOnlyField Field(string fieldName)
        {
            if (dictFields.TryGetValue(fieldName, out ReadOnlyField result)) return result;
            return null;
        }
        IReadOnlyField IReadOnlySpecification.Field(string fieldName) => Field(fieldName);
    }
}
