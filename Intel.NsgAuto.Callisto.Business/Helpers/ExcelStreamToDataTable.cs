using Intel.NsgAuto.Callisto.Business.Entities.Imports;
using Intel.NsgAuto.Shared.Excel;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Security.AntiXss;

namespace Intel.NsgAuto.Callisto.Business.Helpers
{
    public class ExcelStreamToDataTable
    {
        private const string DEFAULT_RECORD_NUMBER_COLUMN_NAME = "RecordNumber";

        public string FileExtension { get; set; }

        public bool IncludeRecordNumber { get; set; }

        public string RecordNumberColumnName { get; set; }

        public IReadOnlySpecification Specification { get; set; }

        public Stream Stream { get; set; }

        public ExcelStreamToDataTable(Stream stream = null, string fileExtension = null, IReadOnlySpecification specification = null, bool includeRecordNumber = true, string recordNumberColumnName = DEFAULT_RECORD_NUMBER_COLUMN_NAME)
        {
            Stream = stream;
            FileExtension = fileExtension;
            Specification = specification;
            IncludeRecordNumber = includeRecordNumber;
            RecordNumberColumnName = recordNumberColumnName;
        }

        public DataTable TryConvert(out string message)
        {
            DataTable result = CreateEmptyDataTable();
            message = null;
            bool succeeded = false;
            IExcelReaderAccess excelReaderAccess = null;
            try
            {
                string extension = FileExtension.ToUpperInvariant();
                if (extension != "XLS" && extension != "XLSX")
                {
                    message = "Unsupported file extension";
                    return null;
                }
                excelReaderAccess = new ExcelReaderAccess(Stream)
                {
                    Extension = extension, // not sure why this is required, but it won't properly read the stream without setting it
                    IsFirstRowColumnRow = Specification?.IsFirstRowColumnRow ?? false,
                };
                List<string> worksheetNames = excelReaderAccess.GetWorkSheetNames();
                if ((worksheetNames?.Count ?? 0) <= 0)
                {
                    message = "The spreadsheet does not have any worksheets";
                    return null;
                }
                string worksheetName = Specification?.WorksheetName ?? worksheetNames[0];
                if (!worksheetNames.Contains(worksheetName))
                {
                    message = $"The spreadsheet does not contain a worksheet with name: {worksheetName}";
                    return null;
                }
                List<DataRow> excelRows = excelReaderAccess.GetDataRows(worksheetName);
                // first row with column names already skipped by ExcelReaderAccess when IsFirstRowColumnRow = true
                int startIndex = excelReaderAccess.IsFirstRowColumnRow ? (Specification?.RowDataBegins ?? 2) - 2 : (Specification?.RowDataBegins ?? 1) - 1;
                if ((excelRows?.Count ?? 0) <= startIndex)
                {
                    message = "The worksheet does not have any data";
                    return null;
                }
                DataColumnCollection excelColumns = excelRows[0].Table.Columns; // get a reference to the columns (they are the same for all rows)
                if (Specification != null)
                {
                    List<string> missingRequiredColumns = new List<string>();
                    int excelColumnIndex = 0;
                    foreach (IReadOnlyField field in Specification?.Fields)
                    {
                        if (field.ColumnRequired)
                        {
                            if (Specification?.MatchColumnsByName ?? false)
                            {
                                if (!excelColumns.Contains(field.ColumnName)) missingRequiredColumns.Add(field.ColumnName);
                            }
                            else
                            {
                                if (excelColumnIndex >= excelColumns.Count) missingRequiredColumns.Add(field.ColumnName);
                            }
                        }
                        ++excelColumnIndex;
                    }
                    if (missingRequiredColumns.Count > 0)
                    {
                        string missingColumnsCsv = missingRequiredColumns.Take(10).JoinString(", ");
                        if (missingRequiredColumns.Count == 1) message = $"Required column not found: {missingColumnsCsv}";
                        else message = $"Required columns not found: {missingColumnsCsv}";
                        return null;
                    }
                    result = CreateEmptyDataTable();
                }
                else
                {
                    result = CreateEmptyDataTable(excelColumns.Count);
                }
                int recordNumber = 0;
                for (int i = startIndex; i < excelRows.Count; ++i)
                {
                    ++recordNumber;
                    DataRow excelRow = excelRows[i];
                    DataRow row = result.NewRow();
                    int columnIndex = 0;
                    foreach (DataColumn column in result.Columns)
                    {
                        if (IncludeRecordNumber && column.Ordinal == 0)
                        {
                            row[column] = recordNumber;
                        }
                        else
                        {
                            string value = null;
                            if (Specification?.MatchColumnsByName ?? false)
                            {
                                IReadOnlyField field = Specification.Field(column.ColumnName);
                                if (excelRow.Table.Columns.Contains(field.ColumnName)) value = AntiXssEncoder.XmlEncode(excelRow[field.ColumnName].ToStringSafely());
                            }
                            else
                            {
                                if (columnIndex < excelRow.Table.Columns.Count) value = AntiXssEncoder.XmlEncode((excelRow[columnIndex].ToStringSafely()));
                            }
                            if (value == null) value = string.Empty;
                            row[column] = value;
                            ++columnIndex;
                        }
                    }
                    result.Rows.Add(row);
                }
                result.AcceptChanges();
                succeeded = true;
            }
            catch (Exception exception)
            {
                message = exception.Message;
            }
            finally
            {
                excelReaderAccess?.Close();
            }
            if (succeeded) return result;
            return null;
        }

        private DataTable CreateEmptyDataTable(int? columnCount = null)
        {
            DataTable result = new DataTable();
            if (IncludeRecordNumber) result.Columns.Add(RecordNumberColumnName, typeof(int));
            if (Specification != null)
            {
                foreach (IReadOnlyField field in Specification.Fields)
                {
                    result.Columns.Add(field.Name, typeof(string));
                }
            }
            else
            {
                for (int i = 0; i < columnCount.Value; ++i)
                {
                    DataColumn column = new DataColumn()
                    {
                        DataType = typeof(string)
                    };
                    result.Columns.Add(column);
                }
            }
            return result;
        }
    }
}
