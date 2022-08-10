using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Callisto.Business.Entities.MATs.Workflows;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.Shared.Excel;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using ImportSpecification = Intel.NsgAuto.Callisto.Business.Core.ImportSpecifications.MATs;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class MATVersionsService
    {
        public MATs GetMATs(string userId, int id)
        {
            return new MATVersionsDataContext().GetMATs(userId, id);
        }

        public MATVersion Get(string userId, int id)
        {
            return new MATVersionsDataContext().Get(userId, id);
        }

        public MATVersions GetAll(string userId, bool? isActive = null)
        {
            return new MATVersionsDataContext().GetAll(userId, isActive);
        }

        public MATReviewResponse GetReviewSteps(string userId, int versionId)
        {
            return new MATVersionsDataContext().GetReviewSteps(versionId, userId);
        }

        //public MATVersion GetVersionDetails(string userId, int id)
        //{
        //    return new MATVersionsDataContext().GetVersionDetails(userId, id);
        //}

        public MATVersion GetMATVersionDetails(int id, string userId)
        {
            return new MATVersionsDataContext().GetMATVersionDetails(id, userId);
        }

        public EntitySingleMessageResult<MATVersion> Approve(string userId, ReviewDecision decision)
        {
            EntitySingleMessageResult<MATVersion> result = new EntitySingleMessageResult<MATVersion>();
            result.Entity = new MATVersionsDataContext().Approve(userId, decision);
            if (result.Entity != null && (result.Entity.Status.Name == "In Review" || result.Entity.Status.Name == "Complete"))
            {
                result.Succeeded = true;
            }
            else
            {
                result.Succeeded = false;
                result.Message = "Invalid status change";
            }
            return result;
        }

        public EntitySingleMessageResult<MATVersion> Cancel(string userId, int id)
        {
            EntitySingleMessageResult<MATVersion> result = new EntitySingleMessageResult<MATVersion>();
            result.Entity = new MATVersionsDataContext().Cancel(userId, id);
            if (result.Entity != null && result.Entity.Status.Name == "Canceled")
            {
                result.Succeeded = true;
            }
            else
            {
                result.Succeeded = false;
                result.Message = "Invalid status change";
            }
            return result;
        }

        public EntitySingleMessageResult<MATVersion> Reject(string userId, ReviewDecision decision)
        {
            EntitySingleMessageResult<MATVersion> result = new EntitySingleMessageResult<MATVersion>();
            result.Entity = new MATVersionsDataContext().Reject(userId, decision);
            if (result.Entity != null && result.Entity.Status.Name == "Rejected")
            {
                result.Succeeded = true;
            }
            else
            {
                result.Succeeded = false;
                result.Message = "Invalid status change";
            }
            return result;
        }

        public EntitySingleMessageResult<MATVersion> Submit(string userId, int id)
        {
            EntitySingleMessageResult<MATVersion> result = new EntitySingleMessageResult<MATVersion>();
            result.Entity = new MATVersionsDataContext().Submit(userId, id);
            if (result.Entity != null && result.Entity.Status.Name == "Submitted")
            {
                result.Succeeded = true;
            }
            else
            {
                result.Succeeded = false;
                result.Message = "Invalid status change";
            }
            return result;
        }

        public IdAndNames GetAllIdAndNamesOnly(string userId, bool? isActive = null)
        {
            return new MATVersionsDataContext().GetAllIdAndNamesOnly(userId, isActive);
        }

        public MATVersionImportResponse Import(string userId, Stream stream, string filename)
        {
            MATVersionImportResponse result;
            EntitySingleMessageResult<MATsImport> parsingResult = CreateImportRecords(stream, filename);
            if (parsingResult.Succeeded)
            {
                result = new MATVersionsDataContext().Import(userId, parsingResult.Entity);
                if (result.Version != null) result.Succeeded = true;
                else result.Succeeded = false;
            }
            else
            {
                result = new MATVersionImportResponse() { Succeeded = false, ImportMessages = new ImportMessages() };
                if (!string.IsNullOrWhiteSpace(parsingResult.Message))
                {
                    result.ImportMessages.Add(new ImportMessage() { MessageType = "Abort", Message = parsingResult.Message });
                }
                else
                {
                    result.ImportMessages.Add(new ImportMessage() { MessageType = "Abort", Message = "The file could not be parsed." });
                }
            }
            result.PrepareResponse();
            return result;
       }

        public EntitySingleMessageResult<MATsImport> CreateImportRecords(Stream stream, string filename)
        {
            EntitySingleMessageResult<MATsImport> result = new EntitySingleMessageResult<MATsImport>() { Entity = new MATsImport(), Succeeded = false };
            IExcelReaderAccess excelReaderAccess = null;
            try
            {
                string extension = Functions.GetFileExtension(filename).ToUpperInvariant();
                if (extension == "XLS" || extension == "XLSX")
                {
                    excelReaderAccess = new ExcelReaderAccess(stream);
                    excelReaderAccess.Extension = Functions.GetFileExtension(filename); // why is this required?
                    List<string> workSheetNames = excelReaderAccess.GetWorkSheetNames();
                    if (workSheetNames.IsNotNull() && workSheetNames.Count > 0)
                    {
                        List<DataRow> rows = excelReaderAccess.GetDataRows(workSheetNames[0]);
                        int startIndex = ImportSpecification.HeaderRows - 1; // First row with column names already skipped by ExcelReaderAccess (since IsFirstRowColumnRow = true)
                        if (rows.IsNotNull() && rows.Count > startIndex)
                        {
                            DataColumnCollection columns = rows[0].Table.Columns; // get a reference to the columns (they are the same for all rows)
                            List<string> missingColumns = new List<string>();
                            foreach (string column in requiredColumns())
                            {
                                if (!columns.Contains(column)) missingColumns.Add(column);
                            }
                            if (missingColumns.Count > 0)
                            {
                                string missingColumnsCsv = missingColumns.Take(10).JoinString(", ");
                                if (missingColumns.Count == 1) result.Message = $"Required column not found: {missingColumnsCsv}";
                                else result.Message = $"Required columns not found: {missingColumnsCsv}";
                            }
                            else
                            {
                                int recordNumber = 0;
                                for (int i = startIndex; i < rows.Count; ++i)
                                {
                                    DataRow row = rows[i];
                                    MATImport entity = new MATImport()
                                    {
                                        RecordNumber = ++recordNumber,
                                        SsdId = row.FieldToStringSafely(ImportSpecification.ColumnNames.SSDId),
                                        DesignId = row.FieldToStringSafely(ImportSpecification.ColumnNames.DesignId),
                                        Scode = row.FieldToStringSafely(ImportSpecification.ColumnNames.Scode),
                                        MediaIPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.MediaIPN),
                                        MediaType = row.FieldToStringSafely(ImportSpecification.ColumnNames.MediaType),
                                        DeviceName = row.FieldToStringSafely(ImportSpecification.ColumnNames.DeviceName),
                                        CellRevision = row.FieldToStringSafely(ImportSpecification.ColumnNames.CellRevision),
                                        MajorProbeProgramRevision = row.FieldToStringSafely(ImportSpecification.ColumnNames.MajorProbeProgramRevision),
                                        ProbeRevision = row.FieldToStringSafely(ImportSpecification.ColumnNames.ProbeRevision),
                                        BurnTapeRevision = row.FieldToStringSafely(ImportSpecification.ColumnNames.BurnTapeRevision),
                                        CustomTestingReqd = row.FieldToStringSafely(ImportSpecification.ColumnNames.CustomTestingReqd),
                                        CustomTestingReqd2 = row.FieldToStringSafely(ImportSpecification.ColumnNames.CustomTestingReqd2),
                                        ProductGrade = row.FieldToStringSafely(ImportSpecification.ColumnNames.ProductGrade),
                                        PrbConvId = row.FieldToStringSafely(ImportSpecification.ColumnNames.PrbConvId),
                                        FabExcrId = row.FieldToStringSafely(ImportSpecification.ColumnNames.FabExcrId),
                                        FabConvId = row.FieldToStringSafely(ImportSpecification.ColumnNames.FabConvId),
                                        ReticleWaveId = row.FieldToStringSafely(ImportSpecification.ColumnNames.ReticleWaveId),
                                        FabFacility = row.FieldToStringSafely(ImportSpecification.ColumnNames.FabFacility),
                                    };
                                    result.Entity.Add(entity);
                                }
                                result.Succeeded = true;
                            }
                        }
                        else
                        {
                            result.Message = "The spreadsheet does not have any data.";
                        }
                    }
                    else
                    {
                        result.Message = "The spreadsheet does not have any worksheets.";
                    }
                }
                else
                {
                    result.Message = "Unsupported file extension.";
                }
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                excelReaderAccess?.Close();
            }
            return result;
        }

        private List<string> requiredColumns()
        {
            List<string> result = new List<string>();
            result.Add(ImportSpecification.ColumnNames.SSDId);
            result.Add(ImportSpecification.ColumnNames.DesignId);
            result.Add(ImportSpecification.ColumnNames.Scode);
            result.Add(ImportSpecification.ColumnNames.MediaIPN);
            result.Add(ImportSpecification.ColumnNames.MediaType);
            result.Add(ImportSpecification.ColumnNames.DeviceName);

            return result;
        }
    }
}
