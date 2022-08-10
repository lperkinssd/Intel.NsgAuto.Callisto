using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ProductLabels;
using Intel.NsgAuto.Shared.Excel;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using ImportSpecification = Intel.NsgAuto.Callisto.Business.Core.ImportSpecifications.ProductLabels;


namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class ProductLabelSetVersionsService
    {
        public ProductLabels GetProductLabels(string userId, int id)
        {
            return new ProductLabelSetVersionsDataContext().GetProductLabels(userId, id);
        }

        public ProductLabelSetVersion Get(string userId, int id)
        {
            return new ProductLabelSetVersionsDataContext().Get(userId, id);
        }

        public ProductLabelSetVersions GetAll(string userId, bool? isActive = null)
        {
            return new ProductLabelSetVersionsDataContext().GetAll(userId, isActive);
        }

        public EntitySingleMessageResult<ProductLabelSetVersion> Approve(string userId, int id)
        {
            EntitySingleMessageResult<ProductLabelSetVersion> result = new EntitySingleMessageResult<ProductLabelSetVersion>();
            result.Entity = new ProductLabelSetVersionsDataContext().Approve(userId, id);
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

        public EntitySingleMessageResult<ProductLabelSetVersion> Cancel(string userId, int id)
        {
            EntitySingleMessageResult<ProductLabelSetVersion> result = new EntitySingleMessageResult<ProductLabelSetVersion>();
            result.Entity = new ProductLabelSetVersionsDataContext().Cancel(userId, id);
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

        public EntitySingleMessageResult<ProductLabelSetVersion> Reject(string userId, int id)
        {
            EntitySingleMessageResult<ProductLabelSetVersion> result = new EntitySingleMessageResult<ProductLabelSetVersion>();
            result.Entity = new ProductLabelSetVersionsDataContext().Reject(userId, id);
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

        public EntitySingleMessageResult<ProductLabelSetVersion> Submit(string userId, int id)
        {
            EntitySingleMessageResult<ProductLabelSetVersion> result = new EntitySingleMessageResult<ProductLabelSetVersion>();
            result.Entity = new ProductLabelSetVersionsDataContext().Submit(userId, id);
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
            return new ProductLabelSetVersionsDataContext().GetAllIdAndNamesOnly(userId, isActive);
        }

        public ProductLabelSetVersionImportResult Import(string userId, Stream stream, string filename)
        {
            ProductLabelSetVersionImportResult result;
            EntitySingleMessageResult<ProductLabelsImport> parsingResult = CreateImportRecords(stream, filename);
            if (parsingResult.Succeeded)
            {
                result = new ProductLabelSetVersionsDataContext().Import(userId, parsingResult.Entity);
                if (result.Version != null) result.Succeeded = true;
                else result.Succeeded = false;
            }
            else
            {
                result = new ProductLabelSetVersionImportResult() { Succeeded = false, ImportMessages = new ImportMessages() };
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

        public EntitySingleMessageResult<ProductLabelsImport> CreateImportRecords(Stream stream, string filename)
        {
            EntitySingleMessageResult<ProductLabelsImport> result = new EntitySingleMessageResult<ProductLabelsImport>() { Entity = new ProductLabelsImport(), Succeeded = false };
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
                        int startIndex = ImportSpecification.HeaderRows - 1; // first row with column names already skipped by ExcelReaderAccess (since IsFirstRowColumnRow = true)
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
                                    ProductLabelImport entity = new ProductLabelImport()
                                    {
                                        RecordNumber = ++recordNumber,
                                        ProductFamily = row.FieldToStringSafely(ImportSpecification.ColumnNames.ProductFamily),
                                        Customer = row.FieldToStringSafely(ImportSpecification.ColumnNames.Customer),
                                        ProductionProductCode = row.FieldToStringSafely(ImportSpecification.ColumnNames.ProductionProductCode),
                                        ProductFamilyNameSeries = row.FieldToStringSafely(ImportSpecification.ColumnNames.ProductFamilyNameSeries),
                                        Capacity = row.FieldToStringSafely(ImportSpecification.ColumnNames.Capacity),
                                        ModelString = row.FieldToStringSafely(ImportSpecification.ColumnNames.ModelString),
                                        VoltageCurrent = row.FieldToStringSafely(ImportSpecification.ColumnNames.VoltageCurrent),
                                        InterfaceSpeed = row.FieldToStringSafely(ImportSpecification.ColumnNames.InterfaceSpeed),
                                        OpalType = row.FieldToStringSafely(ImportSpecification.ColumnNames.OpalType),
                                        KCCId = row.FieldToStringSafely(ImportSpecification.ColumnNames.KCCId),
                                        CanadianStringClass = row.FieldToStringSafely(ImportSpecification.ColumnNames.CanadianStringClass),
                                        DellPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.DellPN),
                                        DellPPIDRev = row.FieldToStringSafely(ImportSpecification.ColumnNames.DellPPIDRev),
                                        DellEMCPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.DellEMCPN),
                                        DellEMCPNRev = row.FieldToStringSafely(ImportSpecification.ColumnNames.DellEMCPNRev),
                                        HpePN = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpePN),
                                        HpeModelString = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpeModelString),
                                        HpeGPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpeGPN),
                                        HpeCTAssemblyCode = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpeCTAssemblyCode),
                                        HpeCTRev = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpeCTRev),
                                        HpPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpPN),
                                        HpCTAssemblyCode = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpCTAssemblyCode),
                                        HpCTRev = row.FieldToStringSafely(ImportSpecification.ColumnNames.HpCTRev),
                                        LenovoFRU = row.FieldToStringSafely(ImportSpecification.ColumnNames.LenovoFRU),
                                        Lenovo8ScodePN = row.FieldToStringSafely(ImportSpecification.ColumnNames.Lenovo8ScodePN),
                                        Lenovo8ScodeBCH = row.FieldToStringSafely(ImportSpecification.ColumnNames.Lenovo8ScodeBCH),
                                        Lenovo11ScodePN = row.FieldToStringSafely(ImportSpecification.ColumnNames.Lenovo11ScodePN),
                                        Lenovo11ScodeRev = row.FieldToStringSafely(ImportSpecification.ColumnNames.Lenovo11ScodeRev),
                                        Lenovo11ScodePN10 = row.FieldToStringSafely(ImportSpecification.ColumnNames.Lenovo11ScodePN10),
                                        OracleProductIdentifer = row.FieldToStringSafely(ImportSpecification.ColumnNames.OracleProductIdentifer),
                                        OraclePN = row.FieldToStringSafely(ImportSpecification.ColumnNames.OraclePN),
                                        OraclePNRev = row.FieldToStringSafely(ImportSpecification.ColumnNames.OraclePNRev),
                                        OracleModel = row.FieldToStringSafely(ImportSpecification.ColumnNames.OracleModel),
                                        OraclePkgPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.OraclePkgPN),
                                        OracleMarketingPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.OracleMarketingPN),
                                        CiscoPN = row.FieldToStringSafely(ImportSpecification.ColumnNames.CiscoPN),
                                        FujistuCSL = row.FieldToStringSafely(ImportSpecification.ColumnNames.FujistuCSL),
                                        Fujitsu106PN = row.FieldToStringSafely(ImportSpecification.ColumnNames.Fujitsu106PN),
                                        HitachiModelName = row.FieldToStringSafely(ImportSpecification.ColumnNames.HitachiModelName),
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
                result.Message = exception.Message;
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
            result.Add(ImportSpecification.ColumnNames.ProductFamily);
            result.Add(ImportSpecification.ColumnNames.Customer);
            result.Add(ImportSpecification.ColumnNames.ProductionProductCode);
            result.Add(ImportSpecification.ColumnNames.ProductFamilyNameSeries);
            result.Add(ImportSpecification.ColumnNames.Capacity);
            result.Add(ImportSpecification.ColumnNames.ModelString);
            result.Add(ImportSpecification.ColumnNames.VoltageCurrent);
            result.Add(ImportSpecification.ColumnNames.InterfaceSpeed);
            result.Add(ImportSpecification.ColumnNames.OpalType);
            result.Add(ImportSpecification.ColumnNames.KCCId);
            result.Add(ImportSpecification.ColumnNames.CanadianStringClass);
            return result;
        }

    }
}
