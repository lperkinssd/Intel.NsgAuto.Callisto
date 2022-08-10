using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using Dejavu.Calendar;
using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;
using Intel.NsgAuto.Shared.Excel;
using Intel.NsgAuto.Shared.Extensions;
using MatImportSpecification = Intel.NsgAuto.Callisto.Business.Core.ImportSpecifications.OdmMATs;
using PrfImportSpecification = Intel.NsgAuto.Callisto.Business.Core.ImportSpecifications.OdmPRFs;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class OdmService
    {
        public Result CreateLotDisposition(string userId, LotDispositionDto lotDisposition)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).CreateLotDisposition(userId, lotDisposition);
        }
        public Result SaveLotDispositions(string userId, LotDispositions lotDispositions)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).SaveLotDispositions(userId, lotDispositions);
        }

        public ExplainabilityReport GetExplainabilityReport(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetExplainabilityReport(userId);
        }

        //public OdmQualFilters GetLatestOdmQualFilter(string userId)
        //{
        //    return new OdmDataContextFactory().CreateOdmDataContext(userId).GetLatestOdmQualFilter(userId);
        //}

        //GetLotDispositionReasons
        public IdAndNames GetLotDispositionReasons(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetLotDispositionReasons(userId);
        }

        public MatVersions GetMatVersionDetails(string userId, int versionId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetMatVersionDetails(userId, versionId);
        }

        public ImportVersions GetMatVersions(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetMatVersions(userId);
        }

        public QualFilterScenario GetQualFilterScenario(string userId, int versionId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetQualFilterScenario(userId, versionId);
        }

        public QualFilterScenario GetQualFilterHistoricalScenario(string userId, int versionId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetQualFilterHistoricalScenario(userId, versionId);
        }

        public OdmWips GetOdmLotWipDetails(string sLot, string mediaIPN, string sCode, string odmName, string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetOdmLotWipDetails(sLot, mediaIPN, sCode, odmName, userId);
        }

        public QualFilterScenarioVersions GetQualFilterScenarioVersions(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetQualFilterScenarioVersions(userId);
        }

        public QualFilterScenarioVersions GetQualFilterScenarioVersionsDaily(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetQualFilterScenarioVersionsDaily(userId);
        }

        public QualFilterScenarioVersions GetOdmQualFilterScenarioHistoricalVersions(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetOdmQualFilterScenarioHistoricalVersions(userId);
        }

        public QualFilterRemovableSLotUploads GetQualFilterRemovableSLotUploads(string userId, DateTime loadToDate)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetQualFilterRemovableSLotUploads(userId, loadToDate);
        }

        public QualFilterRemovableSLots GetRemovableSLotDetails(string userId, int version, string odmName)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetRemovableSLotDetails(userId, version, odmName);
        }

        public string GetProhibitedTimeRanges(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetProhibitedTimeRanges(userId);
        }

        public PrfVersions GetPrfVersionDetails(string userId, int versionId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetPrfVersionDetails(userId, versionId);
        }

        public ImportVersions GetPrfVersions(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetPrfVersions(userId);
        }

        public ImportResult ImportMAT(string userId, Stream stream, string filename)
        {
            ImportResult result;
            EntitySingleMessageResult<MatRecords> parsingResult = CreateMatImportRecords(stream, filename);
            if (parsingResult.Succeeded)
            {
                result = new OdmDataContextFactory().CreateOdmDataContext(userId).Import(userId, parsingResult.Entity);
                if (result.Messages[0] == "File loaded Successfully") result.Succeeded = true;
                else result.Succeeded = false;
            }
            else
            {
                result = new ImportResult() { Succeeded = false, Messages = new List<string>() };
                if (!string.IsNullOrWhiteSpace(parsingResult.Message))
                {
                    result.Messages.Add(parsingResult.Message);
                }
                else
                {
                    result.Messages.Add("The file could not be parsed.");
                }
            }
            result.PrepareResponse();
            return result;
        }

        public ImportResult ImportPRF(string userId, Stream stream, string filename)
        {
            ImportResult result;
            EntitySingleMessageResult<PrfRecords> parsingResult = CreatePrfImportRecords(stream, filename);
            if (parsingResult.Succeeded)
            {
                result = new OdmDataContextFactory().CreateOdmDataContext(userId).Import(userId, parsingResult.Entity);
                if (result.Messages[0] == "File loaded Successfully") result.Succeeded = true;
                else result.Succeeded = false;
            }
            else
            {
                result = new ImportResult() { Succeeded = false, Messages = new List<string>() };
                if (!string.IsNullOrWhiteSpace(parsingResult.Message))
                {
                    result.Messages.Add(parsingResult.Message);
                }
                else
                {
                    result.Messages.Add("The file could not be parsed.");
                }
            }
            result.PrepareResponse();
            return result;
        }

        public DispositionVersions GetDispositionVersions(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetDispositionVersions(userId);
        }

        public ImportDispositionsResponse ImportDispositions(Stream stream, string filename, string userId)
        {
            ImportDispositionsResponse result = null;
            result = new OdmDataContextFactory().CreateOdmDataContext(userId).ImportDispositions(stream, filename, userId);
            return result;
        }

        public Result PublishScenario(string userId, int? versionId)
        {
            Result result = new OdmDataContextFactory().CreateOdmDataContext(userId).PublishScenario(userId, versionId);
            if (result.Messages[0] == "Publish executed successfully") result.Succeeded = true;
            else result.Succeeded = false;
            return result;
        }

        public Result PublishScenarioOptane(string userId, int? versionId)
        {
            Result result = new OdmDataContextFactory().CreateOdmIogDataContext().PublishScenario(userId, versionId);
            if (result.Messages[0] == "Publish executed successfully") result.Succeeded = true;
            else result.Succeeded = false;
            return result;
        }

        public Result PublishScenarioNand(string userId, int? versionId)
        {
            Result result = new OdmDataContextFactory().CreateOdmNpsgDataContext().PublishScenario(userId, versionId);
            if (result.Messages[0] == "Publish executed successfully") result.Succeeded = true;
            else result.Succeeded = false;
            return result;
        }

        public void ProcessRemovableSLots(string userId, CompanyType companyType)
        {
            new OdmDataContextFactory().CreateOdmDataContext(companyType).ProcessRemovableSLots(userId);
        }

        public Result RunQualFilter(string userId)
        {
            Result result;

            result = new OdmDataContextFactory().CreateOdmDataContext(userId).RunQualFilter(userId);
            if (result.Messages[0] == "Query executed successfully") result.Succeeded = true;
            else result.Succeeded = false;

            return result;
        }

        public Result RunScenario(string userId)
        {
            Result result;

            result = new OdmDataContextFactory().CreateOdmDataContext(userId).RunScenario(userId);
            if (result.Messages[0] == "Query executed successfully") result.Succeeded = true;
            else result.Succeeded = false;

            return result;
        }

        public EntitySingleMessageResult<MatRecords> CreateMatImportRecords(Stream stream, string filename)
        {
            EntitySingleMessageResult<MatRecords> result = new EntitySingleMessageResult<MatRecords>() { Entity = new MatRecords(), Succeeded = false };
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
                        int startIndex = MatImportSpecification.HeaderRows - 1; // First row with column names already skipped by ExcelReaderAccess (since IsFirstRowColumnRow = true)
                        if (rows.IsNotNull() && rows.Count > startIndex)
                        {
                            DataColumnCollection columns = rows[0].Table.Columns; // get a reference to the columns (they are the same for all rows)
                            List<string> missingColumns = new List<string>();
                            foreach (string column in requiredMatColumns())
                            {
                                if (!columns.Contains(column)) missingColumns.Add(column);
                            }
                            if (missingColumns.Count > 0)
                            {
                                string missingColumnsCsv = missingColumns.Take(18).JoinString(", ");
                                if (missingColumns.Count == 1) result.Message = $"Required column not found: {missingColumnsCsv}";
                                else result.Message = $"Required columns not found: {missingColumnsCsv}";
                            }
                            else
                            {
                                int recordNumber = 0;
                                var ww = DateTime.Now.ToIntelWw();

                                for (int i = startIndex; i < rows.Count; ++i)
                                {
                                    DataRow row = rows[i];
                                    MatRecord entity = new MatRecord()
                                    {
                                        RecordNumber = ++recordNumber,
                                        WorkWeek = ww.Year.ToStringSafely() + ww.Ordinal.ToStringSafely(),
                                        SSDId = row.FieldToStringSafely(MatImportSpecification.ColumnNames.SSDId),
                                        DesignId = row.FieldToStringSafely(MatImportSpecification.ColumnNames.DesignId),
                                        Scode = row.FieldToStringSafely(MatImportSpecification.ColumnNames.Scode),
                                        CellRevision = row.FieldToStringSafely(MatImportSpecification.ColumnNames.CellRevision),
                                        MPPR = row.FieldToStringSafely(MatImportSpecification.ColumnNames.MajorProbeProgramRevision),
                                        ProbeRevision = row.FieldToStringSafely(MatImportSpecification.ColumnNames.ProbeRevision),
                                        BurnTapeRevision = row.FieldToStringSafely(MatImportSpecification.ColumnNames.BurnTapeRevision),
                                        CustomTestingRequired = row.FieldToStringSafely(MatImportSpecification.ColumnNames.CustomTestingReqd),
                                        CustomTestingRequired2 = row.FieldToStringSafely(MatImportSpecification.ColumnNames.CustomTestingReqd2),
                                        ProductGrade = row.FieldToStringSafely(MatImportSpecification.ColumnNames.ProductGrade),
                                        PrbConvId = row.FieldToStringSafely(MatImportSpecification.ColumnNames.PrbConvId),
                                        FabConvId = row.FieldToStringSafely(MatImportSpecification.ColumnNames.FabConvId),
                                        FabExcrId = row.FieldToStringSafely(MatImportSpecification.ColumnNames.FabExcrId),
                                        MediaType = row.FieldToStringSafely(MatImportSpecification.ColumnNames.MediaType),
                                        MediaIPN = row.FieldToStringSafely(MatImportSpecification.ColumnNames.MediaIPN),
                                        DeviceName = row.FieldToStringSafely(MatImportSpecification.ColumnNames.DeviceName),
                                        ReticleWaveId = row.FieldToStringSafely(MatImportSpecification.ColumnNames.ReticleWaveId),
                                        FabFacility = row.FieldToStringSafely(MatImportSpecification.ColumnNames.FabFacility),
                                        CreatedOn = DateTime.Now,
                                        Latest = true,
                                        FileType = "P"

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

        public Result ClearArchiveOdmManualDisposition(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).ClearArchiveOdmManualDisposition(userId);
        }

        public Dispositions GetDispositionsByVersion(int versionId, string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetDispositionsByVersion(versionId, userId);
        }

        public EntitySingleMessageResult<PrfRecords> CreatePrfImportRecords(Stream stream, string filename)
        {
            EntitySingleMessageResult<PrfRecords> result = new EntitySingleMessageResult<PrfRecords>() { Entity = new PrfRecords(), Succeeded = false };
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
                        int startIndex = PrfImportSpecification.HeaderRows - 1; // First row with column names already skipped by ExcelReaderAccess (since IsFirstRowColumnRow = true)
                        if (rows.IsNotNull() && rows.Count > startIndex)
                        {
                            DataColumnCollection columns = rows[0].Table.Columns; // get a reference to the columns (they are the same for all rows)
                            List<string> missingColumns = new List<string>();
                            foreach (string column in requiredPrfColumns())
                            {
                                if (!columns.Contains(column)) missingColumns.Add(column);
                            }
                            if (missingColumns.Count > 0)
                            {
                                string missingColumnsCsv = missingColumns.Take(5).JoinString(", ");
                                if (missingColumns.Count == 1) result.Message = $"Required column not found: {missingColumnsCsv}";
                                else result.Message = $"Required columns not found: {missingColumnsCsv}";
                            }
                            else
                            {
                                var ww = DateTime.Now.ToIntelWw();
                                for (int i = startIndex; i < rows.Count; ++i)
                                {
                                    DataRow row = rows[i];
                                    

                                    PrfRecord entity = new PrfRecord()
                                    {
                                        WorkWeek = ww.Year.ToStringSafely() + ww.Ordinal.ToStringSafely(),
                                        ODMDescription = row.FieldToStringSafely(PrfImportSpecification.ColumnNames.ODMDescription),
                                        SSDFamilyName = row.FieldToStringSafely(PrfImportSpecification.ColumnNames.SSDFamilyName),
                                        MMNumber = row.FieldToStringSafely(PrfImportSpecification.ColumnNames.MMNumber),
                                        ProductCode = row.FieldToStringSafely(PrfImportSpecification.ColumnNames.ProductCode),
                                        SSDName = row.FieldToStringSafely(PrfImportSpecification.ColumnNames.SSDName),
                                        CreatedOn = DateTime.Now,
                                        Latest = true,
                                        FileType = "P"

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

        private List<string> requiredMatColumns()
        {
            List<string> result = new List<string>();
            result.Add(MatImportSpecification.ColumnNames.SSDId);
            result.Add(MatImportSpecification.ColumnNames.DesignId);
            result.Add(MatImportSpecification.ColumnNames.Scode);
            result.Add(MatImportSpecification.ColumnNames.CellRevision);
            result.Add(MatImportSpecification.ColumnNames.MajorProbeProgramRevision);
            result.Add(MatImportSpecification.ColumnNames.ProbeRevision);
            result.Add(MatImportSpecification.ColumnNames.BurnTapeRevision);
            result.Add(MatImportSpecification.ColumnNames.CustomTestingReqd);
            result.Add(MatImportSpecification.ColumnNames.CustomTestingReqd2);
            result.Add(MatImportSpecification.ColumnNames.ProductGrade);
            result.Add(MatImportSpecification.ColumnNames.PrbConvId);
            result.Add(MatImportSpecification.ColumnNames.FabExcrId);
            result.Add(MatImportSpecification.ColumnNames.FabConvId);
            result.Add(MatImportSpecification.ColumnNames.ReticleWaveId);
            result.Add(MatImportSpecification.ColumnNames.MediaIPN);
            result.Add(MatImportSpecification.ColumnNames.FabFacility);
            result.Add(MatImportSpecification.ColumnNames.MediaType);
            result.Add(MatImportSpecification.ColumnNames.DeviceName);            

            return result;
        }

        private List<string> requiredPrfColumns()
        {
            List<string> result = new List<string>();
            result.Add(PrfImportSpecification.ColumnNames.ODMDescription);
            result.Add(PrfImportSpecification.ColumnNames.SSDFamilyName);
            result.Add(PrfImportSpecification.ColumnNames.MMNumber);
            result.Add(PrfImportSpecification.ColumnNames.ProductCode);
            result.Add(PrfImportSpecification.ColumnNames.SSDName);

            return result;
        }

        /// <summary>
        /// Angie: TODO - figure out the correct parameters
        /// and if this is the correct method
        /// </summary>
        /// <param name=""></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public Dispositions GetAll(string userId, bool? isActive = null)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).GetAll(userId, isActive);
        }

        public Result CheckProhibitedScenarioRunTime(string userId)
        {
            return new OdmDataContextFactory().CreateOdmDataContext(userId).CheckProhibitedScenarioRunTime(userId);
        }       

    }
}
