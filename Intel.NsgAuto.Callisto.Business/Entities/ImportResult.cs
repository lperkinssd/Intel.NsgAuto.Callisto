using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class ImportResult : Result
    {
        public ImportMessages ImportMessages { get; set; }
        public bool HasErrors { get; set; }

        public void PrepareResponse()
        {
            if (Messages == null) Messages = new List<string>();
            if (ImportMessages != null && ImportMessages.Count > 0)
            {
                var abortMessages = ImportMessages.Where(x => x.MessageType == "Abort");
                var abortMessageCount = abortMessages.Count();
                if (abortMessageCount > 0)
                {
                    int messageThreshold = 20;
                    int count = 0;
                    foreach (var message in ImportMessages)
                    {
                        Messages.Add(message.Message);
                        ++count;
                        if (count > messageThreshold) break;
                    }
                }
                else
                {
                    var errorMessages = ImportMessages.Where(x => x.MessageType == "Error");
                    var errorMessageCount = errorMessages.Count();
                    if (errorMessageCount > 0)
                    {
                        HasErrors = true;
                        int errorThreshold = 25;
                        var thresholdErrors = errorMessages.Take(errorThreshold);
                        int[] rowNumbers = thresholdErrors.Where(x => x.RecordNumber.HasValue).Select(x => RecordNumberToRowNumber(x.RecordNumber.Value)).Distinct().ToArray();
                        if (rowNumbers.Length > 0)
                        {
                            Array.Sort(rowNumbers);
                            string rowNumbersCsv = string.Join(",", rowNumbers);
                            string message = "";
                            if (rowNumbers.Length == 1) message = "This row had an error and was not imported: ";
                            else if (rowNumbers.Length > 1) message = "These rows had errors and were not imported: ";
                            message += rowNumbersCsv;
                            Messages.Add(message);
                        }
                        Messages.Add("Error Summary:");
                        var groups = thresholdErrors.GroupBy(x => new { x.FieldName, x.Message }, (key, group) => new { FieldName = key.FieldName, Message = key.Message, Results = group.ToList() }).OrderBy(x => x.FieldName);
                        foreach (var group in groups)
                        {
                            string message = "";
                            if (!group.FieldName.IsNullOrEmpty()) message += $"{FieldNameDescription(group.FieldName)}: ";
                            message += group.Message;
                            rowNumbers = group.Results.Where(x => x.RecordNumber.HasValue).Select(x => RecordNumberToRowNumber(x.RecordNumber.Value)).ToArray();
                            if (rowNumbers.Length > 0)
                            {
                                Array.Sort(rowNumbers);
                                string rowsCsv = string.Join(",", rowNumbers);
                                string rowOrRows = rowNumbers.Length > 1 ? "rows" : "row";
                                message += $" on {rowOrRows} {rowsCsv}";
                            }
                            Messages.Add(message);
                        }
                        if (errorMessageCount > errorThreshold) Messages.Add($"The error threshold was exceeded. There were more errors than are shown.");
                    }
                }
            }
        }

        public virtual int RecordNumberToRowNumber(int recordNumber)
        {
            // Assumes a single header row
            return recordNumber + 1;
        }

        public virtual string FieldNameDescription(string fieldName)
        {
            return fieldName;
        }
    }
}
