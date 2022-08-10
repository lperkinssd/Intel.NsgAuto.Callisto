using DevExpress.Spreadsheet;
using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.Osat;
using Intel.NsgAuto.Callisto.Business.Entities.Osat.Workflows;
using Intel.NsgAuto.Callisto.Business.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using DevExpress.CodeParser;
using Intel.NsgAuto.Shared.Extensions;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class OsatService
    {
        #region attribute types
        public EntitySingleMessageResult<AttributeTypes> CreateAttributeType(string userId, AttributeTypeCreateDto entity)
        {
            return new OsatDataContext().CreateAttributeType(userId, entity);
        }

        public AttributeTypesManage GetAttributeTypesManage(string userId)
        {
            return new OsatDataContext().GetAttributeTypesManage(userId);
        }

        public EntitySingleMessageResult<AttributeTypes> UpdateAttributeType(string userId, AttributeTypeUpdateDto entity)
        {
            return new OsatDataContext().UpdateAttributeType(userId, entity);
        }

        #endregion

        #region build criterias
        public EntitySingleMessageResult<long?> CreateBuildCriteriaSet(string userId, BuildCriteriaSetCreateDto entity)
        {
            return new OsatDataContext().CreateBuildCriteriaSet(userId, entity);
        }

        public EntitySingleMessageResult<BuildCriteriaSetComments> CreateBuildCriteriaSetComment(string userId, BuildCriteriaSetCommentCreateDto entity)
        {
            return new OsatDataContext().CreateBuildCriteriaSetComment(userId, entity);
        }

        public BuildCombinations GetBuildCombinations(string userId, int? designId = null, bool? porBuildCriteriaSetExists = null, int? osatId=null)
        { 
            return new OsatDataContext().GetBuildCombinations(userId, designId: designId, porBuildCriteriaSetExists: porBuildCriteriaSetExists, osatId: osatId);
        }

        public BuildCriteriaSet GetBuildCriteriaSet(string userId, long id)
        {
            return new OsatDataContext().GetBuildCriteriaSet(userId, id);
        }

        public BuildCriteriaSetAndVersions GetBuildCriteriaSetAndVersions(string userId, int buildCombinationId)
        {
            return new OsatDataContext().GetBuildCriteriaSetAndVersions(userId, buildCombinationId);
        }

        public BuildCombinationAndBuildCriteriaSets GetBuildCombinationAndBuildCriteriaSets(string userId, int buildCombinationId)
        {
            return new OsatDataContext().GetBuildCombinationAndBuildCriteriaSets(userId, buildCombinationId);
        }

        public BuildCriteriaSetCreate GetBuildCriteriaSetCreate(string userId, long? id, int? buildCombinationId)
        {
            return new OsatDataContext().GetBuildCriteriaSetCreate(userId, id, buildCombinationId);
        }

        public BuildCriteriaSetDetails GetBuildCriteriaSetDetails(string userId, long id, long? idCompare = null)
        {
            return new OsatDataContext().GetBuildCriteriaSetDetails(userId, id, idCompare);
        }
        public List<BuildCriteriaSet> GetBuildCriteriaSets(List<long> ids)
        {
            var osatDc = new OsatDataContext();
            var results = ids.Select(id => osatDc.GetBuildCriteriaSet(id)).ToList();
             return results;
        }

        public DesignSummary GetDesignSummary(string userId, int? designId, int? designFamilyId = null)
        {
            return new OsatDataContext().GetDesignSummary(userId, designId, designFamilyId);
        }

        public EntitySingleMessageResult<BuildCriteriaSetDetails> ApproveBuildCriteriaSet(string userId, ReviewDecisionDto decision, bool isBulk, bool sendEmail)
        {
            return new OsatDataContext().ApproveBuildCriteriaSet(userId, decision, isBulk, sendEmail);
        }

        public EntitySingleMessageResult<BuildCriteriaSetDetails> CancelBuildCriteriaSet(string userId, DraftDecisionDto decision, bool isBulk, bool sendEmail)
        {
            return new OsatDataContext().CancelBuildCriteriaSet(userId, decision, isBulk, sendEmail);
        }

        public EntitySingleMessageResult<BuildCriteriaSetDetails> RejectBuildCriteriaSet(string userId, ReviewDecisionDto decision, bool isBulk, bool sendEmail)
        {
            return new OsatDataContext().RejectBuildCriteriaSet(userId, decision,isBulk,sendEmail);
        }

        public EntitySingleMessageResult<BuildCriteriaSetDetails> SubmitBuildCriteriaSet(string userId, DraftDecisionDto decision, bool isBulk, bool sendEmail, string ReviewText)
        {
            return new OsatDataContext().SubmitBuildCriteriaSet(userId, decision, isBulk, sendEmail, ReviewText);
        }

        public EntitySingleMessageResult<BuildCombinations> UpdateBuildCombinationPublish(string userId, BuildCombinationUpdatePublishDto entity)
        {
            return new OsatDataContext().UpdateBuildCombinationPublish(userId, entity);
        }
        //public List<EntitySingleMessageResult<long?>> UpdateOsatBuildCriteriaSetForBulkUpdate(string userId, List<BuildCriteriaSetConditionsUpdateDto> entity)
        //{
        //    var results = new List<EntitySingleMessageResult<long?>>();
        //    var osatDc = new OsatDataContext();
        //    foreach (var buildCriteriaSetConditionsUpdateDto in entity)
        //    {
        //        results.Add(osatDc.UpdateOsatBuildCriteriaSetForBulkUpdate(userId, buildCriteriaSetConditionsUpdateDto));
        //    }
        //    return results;
        //}
        #endregion

        #region pas
        public EntitySingleMessageResult<PasVersionDetails> CancelPasVersion(string userId, int id)
        {
            return new OsatDataContext().CancelPasVersion(userId, id);
        }
        public PasVersion GetPasVersion(string userId, int id)
        {
            return new OsatDataContext().GetPasVersion(userId, id);
        }

        public PasVersionDetails GetPasVersionDetails(string userId, int id)
        {
            return new OsatDataContext().GetPasVersionDetails(userId, id);
        }

        public PasVersionsListAndImport GetPasVersionListAndImport(string userId)
        {
            return new OsatDataContext().GetPasVersionsListAndImport(userId);
        }

        public PasVersions GetPasVersions(string userId)
        {
            return new OsatDataContext().GetPasVersions(userId);
        }

        public EntitySingleMessageResult<PasVersion> ImportPasVersion(string userId, PasVersionImport versionImport)
        {
            EntitySingleMessageResult<PasVersion> result;
            ExcelStreamToDataTable converter = new ExcelStreamToDataTable(File.OpenRead(versionImport.File.UploadFilePath), versionImport.File.OriginalExtension, ImportSpecifications.OsatPas);
            DataTable dataTable = converter.TryConvert(out string message);
            if (dataTable != null)
            {
                result = new OsatDataContext().ImportPasVersion(userId, dataTable, versionImport);
            }
            else
            {
                result = new EntitySingleMessageResult<PasVersion>()
                {
                    Succeeded = false,
                    Message = message ?? "The file could not be parsed",
                };
            }
            if (result.Succeeded)
            {
                string filePath = string.Format(Settings.PathOsatPasVersion, result.Entity.Id, Path.GetFileName(versionImport.File.OriginalFilePath), result.Entity.Combination.DesignFamily.Name);
                string fileDirectory = Path.GetDirectoryName(filePath);
                if (!Directory.Exists(fileDirectory)) Directory.CreateDirectory(fileDirectory);
                File.Move(versionImport.File.UploadFilePath, filePath);
            }
            else
            {
                // delete temporary file
                File.Delete(versionImport.File.UploadFilePath);
            }
            return result;
        }

        public EntitySingleMessageResult<PasVersionDetails> SubmitPasVersion(string userId, int id)
        {
            return new OsatDataContext().SubmitPasVersion(userId, id);
        }
        #endregion

        #region qual filters

        public OsatMetaData GetAll(string userId)
        {
            return new OsatDataContext().GetAll(userId);
        }

        public EntitySingleMessageResult<QualFilterExport> CreateQualFilterExport(string userId, QualFilterRecordsQueryCustom recordsQuery = null)
        {
            return new OsatDataContext().CreateQualFilterExport(userId, recordsQuery);
        }

        public QualFilterExport GetQualFilterExport(string userId, int id)
        {
            return new OsatDataContext().GetQualFilterExport(userId, id);
        }

        public QualFilterExportDetails GetQualFilterExportDetails(string userId, int id)
        {
            QualFilterExportDetails result = null;
            var export = new OsatDataContext().GetQualFilterExport(userId, id);
            if (export != null)
            {
                result = new QualFilterExportDetails()
                {
                    Export = export,
                };
            }
            return result;
        }

        public QualFilterExports GetQualFilterExports(string userId)
        {
            return new OsatDataContext().GetQualFilterExports(userId);
        }

        public QualFilterImport GetQualFilterImport(string userId, int id)
        {
            return new OsatDataContext().GetQualFilterImport(userId, id);
        }

        public QualFilterImportDetails GetQualFilterImportDetails(string userId, int id)
        {
            return new OsatDataContext().GetQualFilterImportDetails(userId, id);
        }

        public QualFilterImports GetQualFilterImports(string userId)
        {
            return new OsatDataContext().GetQualFilterImports(userId);
        }

        public QualFilterImportsList GetQualFilterImportsList(string userId)
        {
            return new QualFilterImportsList()
            {
                Imports = GetQualFilterImports(userId),
            };
        }

        public FileResponse GenerateQualFilterSpreadsheet(string userId, int designId, int osatId, bool includeStatusSubmittedInReview, bool includeStatusDraft)
        {
            FileResponse result = null;
            QualFilterFile file = GetQualFilterFile(userId, new QualFilterRecordsQuery()
            {
                DesignId = designId, 
                OsatId = osatId, 
                IncludeStatusInReview = includeStatusSubmittedInReview, 
                IncludeStatusSubmitted = includeStatusSubmittedInReview,
                IncludeStatusDraft = includeStatusDraft
            });
            if (file != null)
            {
                result = new FileResponse()
                {
                    Name = file.Name,
                    Content = GenerateQualFilterSpreadsheet(file),
                };
            }
            return result;
        }

        public QualFilter GetQualFilter(string userId, int designId = 0, int osatId = 0)
        {
            return new OsatDataContext().GetQualFilter(userId, designId, osatId);
        }

        public QualFilterFile GetQualFilterFile(string userId, QualFilterRecordsQuery entity)
        {
            QualFilterFiles files = new OsatDataContext().GetQualFilterFiles(userId, entity);
            return files?.FirstOrDefault(); ;
        }
        public OsatBuildCriteriaSetBulkImportInfo GetOsatBuildCriteriaSetBulkImportDesignAndVersion(int importId)
        {
            return new OsatDataContext().GetOsatBuildCriteriaSetBulkImportDesignAndVersion(importId);
        }


        public QualFilterExportsListAndPublish GetQualFilterExportsListAndPublish(string userId)
        {
            return new OsatDataContext().GetQualFilterExportsListAndPublish(userId);
        }

        public List<OsatBuildCriteriaSetBulkUpdateChangeDTO> GetOsatBuildCriteriaSetBulkUpdateChanges(long buildCriteriaSetId, int importId)
        {
            return new OsatDataContext().GetOsatBuildCriteriaSetBulkUpdateChanges(buildCriteriaSetId, importId);
        }

        public EntitySingleMessageResult<QualFilterImport> ImportQualFilter(string userId, PostedFile file, bool removeFileAfter)
        {
            var result = new EntitySingleMessageResult<QualFilterImport>();
            using (var stream = File.OpenRead(file.UploadFilePath))
            {
                var dataset = TryQualFilterSpreadsheetToDataSet(stream, out string message);
                if (dataset != null)
                {
                    result = new OsatDataContext().CreateQualFilterImport(userId, file.OriginalFileName, file.ContentLength, dataset);
                }
                else
                {
                    result = new EntitySingleMessageResult<QualFilterImport>()
                    {
                        Succeeded = false,
                        Message = message ?? "The file could not be parsed",
                    };
                }
            }
            if (result != null && result.Succeeded)
            {
                string filePath = string.Format(Settings.PathOsatQfImport, result.Entity.Id, result.Entity.FileName);
                string fileDirectory = Path.GetDirectoryName(filePath);
                if (!Directory.Exists(fileDirectory)) Directory.CreateDirectory(fileDirectory);
                if (removeFileAfter)
                {
                    File.Move(file.UploadFilePath, filePath);
                }
                else
                {
                    File.Copy(file.UploadFilePath, filePath);
                }
            }
            else
            {
                if (removeFileAfter)
                {
                    File.Delete(file.UploadFilePath);
                }
            }
            return result;
        }

        public EntitySingleMessageResult<List<OsatImportedBuildCriteria>> ValidateImportQualFilterBulkUpdate(string userId, int designId, PostedFile file, bool removeFileAfter, out string pendingImportId, int osatId)
        {
            var result = new EntitySingleMessageResult<List<OsatImportedBuildCriteria>>()
            {
                Succeeded = true,
                Message = "The data is valid.",
            };
            pendingImportId = null;
            var fileName = file.OriginalFileName;
            var currentFile = Settings.DirectoryTemp + @"\" + Path.GetFileNameWithoutExtension(fileName) + "_" + Guid.NewGuid() + "." + file.OriginalExtension;
            File.Copy(file.UploadFilePath, currentFile);
            using (var stream = File.OpenRead(file.UploadFilePath))
            {
                var dataSet = TryQualFilterSpreadsheetToDataSet(stream, out string message);
                if (dataSet != null)
                {
                    var osatDataContext = new OsatDataContext();
                    var qff = GetQualFilterFile(userId, new QualFilterRecordsQuery { DesignId = designId, OsatId = osatId, IncludePublishDisabled = false, IncludeStatusDraft = false, IncludeStatusInReview = false, IncludeStatusSubmitted = false });
                    var isDifferent = BuildCriteriaSetsChanged(ref dataSet, qff);
                    if (!isDifferent)
                    {
                        result.Succeeded = false;
                        result.Message = "No changes where found in the uploaded file.";
                        return result;
                    }


                    var existing = osatDataContext.GetOsatBuildCriteriaSetStatusForBulkUpdateImport(dataSet,osatId);

                    cleanCriteriaName(ref dataSet);

                    var pendingImport = new OsatBuildCriteriaSetBulkImportPending
                    {
                        CurrentFile = currentFile,
                        UploadedDataSet = dataSet,
                        DesignId = designId,
                        FileLengthInBytes = file.ContentLength,
                        FileName = fileName
                    };

                    HttpContext.Current.Application[pendingImport.Id] = pendingImport;
                    pendingImportId = pendingImport.Id;

                    result.Entity = existing;
                }
                else
                {
                    result = new EntitySingleMessageResult<List<OsatImportedBuildCriteria>>()
                    {
                        Succeeded = false,
                        Message = message ?? "The file could not be parsed",
                        Entity = new List<OsatImportedBuildCriteria>()
                    };
                }
            }
            if (removeFileAfter)
            {
                File.Delete(file.UploadFilePath);
            }
            return result;
        }

        public EntitySingleMessageResult<int> ImportQualFilterBulkUpdate(string userId, string pendingImportId, int osatid)
        {
            var result = new EntitySingleMessageResult<int>()
            {
                Succeeded = true,
                Message = "The data was saved.",
            };


           var  pendingImport = HttpContext.Current.Application[pendingImportId] as OsatBuildCriteriaSetBulkImportPending;

           if (pendingImport == null)
           {
               return new EntitySingleMessageResult<int>()
               {
                   Succeeded = false,
                   Message = $"Pending import: {pendingImportId} was not found.",
                   Entity = 0
               };
            }

            var osatDataContext = new OsatDataContext();
            var results = osatDataContext.CreateOsatBuildCriteriaSetBulkUpdateImports(userId, pendingImport.DesignId, pendingImport.FileName, pendingImport.CurrentFile, pendingImport.FileLengthInBytes, pendingImport.UploadedDataSet, osatid);
            if (!results.Succeeded)
            {
                result = new EntitySingleMessageResult<int>()
                {
                    Succeeded = false,
                    Message = results.Message,
                    Entity = 0
                };
            }
            else
            {
                HttpContext.Current.Application[pendingImportId] = null;
                result.Entity = results.Entity;
            }
            return result;
        }

        private void cleanCriteriaName(ref DataSet dataSet)
        {
            var regEx = new Regex(@"^[A-Z0-9]{3}\s{1}");
            dataSet.Tables["Criterias"].AsEnumerable().ToList().ForEach(row =>
            {
                var name = row["Name"].ToString();
                var m = regEx.Match(name);
                if (m.Success)
                    row["Name"] = name.Replace(m.Value, string.Empty);
            });
        }
            
        private bool BuildCriteriaSetsChanged(ref DataSet dataSet,
            QualFilterFile qualFilterFile)
        {

            var criteriaDt = dataSet.Tables["Criterias"];
            var attributeDt = dataSet.Tables["Attributes"];
            var changeFound = false;
            List<int> criteriasetnochange = new List<int>();
          
            foreach (var buildCriteriaSetCondition in qualFilterFile.Sheets.SelectMany(s => s.Records))
            {
                var changecriteriasetFound = false;
                var nameFilter = buildCriteriaSetCondition.FilterDescription;
                var criteriaFilter = $"Name='{nameFilter}' And DeviceName='{buildCriteriaSetCondition.DeviceName}' And PartNumberDecode='{buildCriteriaSetCondition.PartNumberDecode}'";
                var filteredCriteria = criteriaDt.Select(criteriaFilter);
                if (!filteredCriteria.Any()) continue;
                var criteriaIndex = filteredCriteria[0]["Index"].ToIntegerSafely();
                
                var filteredAttributes = attributeDt.Select($"CriteriaIndex={criteriaIndex}");
                if (!filteredAttributes.Any())
                {
                    continue;
                }

                var attributes = buildCriteriaSetCondition.AttributeValues.GetType().GetProperties();
                foreach (var attribute in filteredAttributes)
                {
                    var condition = attributes.SingleOrDefault(x => x.Name == attribute["Name"].ToStringSafely());
                    if (condition == null) continue;

                    if (condition.GetValue(buildCriteriaSetCondition.AttributeValues).ToStringSafely().Equals(attribute["Value"].ToStringSafely()))
                        continue;
                    
                    changeFound = true;
                    changecriteriasetFound = true;
                }

                if (!changecriteriasetFound)
                {
                    criteriasetnochange.Add(criteriaIndex);
                }

                
            }

        if (criteriasetnochange.Any())
            {
                foreach(var id in criteriasetnochange)
                {
                    DataRow[] result = dataSet.Tables["Attributes"].Select($"CriteriaIndex={id}");
                    foreach (DataRow row in result)
                    {
                        // if (row["CtryCode"].ToString().Trim().ToUpper().Contains("MM"))
                        dataSet.Tables["Attributes"].Rows.Remove(row);
                    }

                    result = dataSet.Tables["Criterias"].Select($"Index={id}");
                    foreach (DataRow row in result)
                    {
                        // if (row["CtryCode"].ToString().Trim().ToUpper().Contains("MM"))
                        dataSet.Tables["Criterias"].Rows.Remove(row);
                    }

                }
            }
           

            return changeFound;
        }

        public SingleMessageResult UpdateQualFilterExportDelivered(string userId, int id)
        {
            return new OsatDataContext().UpdateQualFilterExportDelivered(userId, id);
        }

        public SingleMessageResult UpdateQualFilterExportGenerated(string userId, int id, string filename, int fileLengthInBytes)
        {
            return new OsatDataContext().UpdateQualFilterExportGenerated(userId, id, filename, fileLengthInBytes);
        }

        public SingleMessageResult UpdateQualFilterImportCanceled(string userId, int id)
        {
            return new OsatDataContext().UpdateQualFilterImportCanceled(userId, id);
        }

        public EntitySingleMessageResult<QualFilterImportDetails> UpdateQualFilterImportCanceledReturnDetails(string userId, int id)
        {
            return new OsatDataContext().UpdateQualFilterImportCanceledReturnDetails(userId, id);
        }

        public SingleMessageResult UpdateQualFilterImportPor(string userId, int id)
        {
            return new OsatDataContext().UpdateQualFilterImportPor(userId, id);
        }

        public EntitySingleMessageResult<QualFilterImportDetails> UpdateQualFilterImportPorReturnDetails(string userId, int id)
        {
            return new OsatDataContext().UpdateQualFilterImportPorReturnDetails(userId, id);
        }

        public static MemoryStream GenerateQualFilterSpreadsheet(QualFilterFile file)
        {
            using (Workbook workbook = new Workbook())
            {
                workbook.BeginUpdate();

                int worksheetIndex = 0;
                foreach (var sheet in file.Sheets)
                {
                    Worksheet worksheet;

                    if (worksheetIndex == 0)
                    {
                        worksheet = workbook.Worksheets[worksheetIndex];
                    }
                    else
                    {
                        worksheet = workbook.Worksheets.Add();
                    }
                    worksheet.Name = sheet.Name;

                    int column;
                    int row = -1;
                    Cell cell;

                    AddQFRow(worksheet, ++row, "", sheet.Records, x => x.FilterDescription);
                    AddQFRow(worksheet, ++row, "Device name", sheet.Records, x => x.DeviceName);
                    AddQFRow(worksheet, ++row, "Part number decode", sheet.Records, x => x.PartNumberDecode);
                    //if (file?.Osat?.Id != 1) // not included for Amkor
                    //{
                        AddQFRow(worksheet, ++row, "ES", sheet.Records, x => x.IsEngineeringSample.ToYorN().ToString());
                    //}

                    cell = worksheet.Cells[++row, 0];
                    cell.Value = "Required attribute conditions for shipment of that production part number";
                    cell.Font.UnderlineType = UnderlineType.Single;

                    AddQFRow(worksheet, ++row, "apo_number", sheet.Records, x => x.AttributeValues.apo_number);
                    AddQFRow(worksheet, ++row, "app_restriction", sheet.Records, x => x.AttributeValues.app_restriction);
                    AddQFRow(worksheet, ++row, "ate_tape_revision", sheet.Records, x => x.AttributeValues.ate_tape_revision);
                    AddQFRow(worksheet, ++row, "burn_flow", sheet.Records, x => x.AttributeValues.burn_flow);
                    AddQFRow(worksheet, ++row, "burn_tape_revision", sheet.Records, x => x.AttributeValues.burn_tape_revision);
                    AddQFRow(worksheet, ++row, "cell_revision", sheet.Records, x => x.AttributeValues.cell_revision);
                    AddQFRow(worksheet, ++row, "cmos_revision", sheet.Records, x => x.AttributeValues.cmos_revision);
                    AddQFRow(worksheet, ++row, "country_of_assembly", sheet.Records, x => x.AttributeValues.country_of_assembly);
                    AddQFRow(worksheet, ++row, "custom_testing_reqd", sheet.Records, x => x.AttributeValues.custom_testing_reqd);
                    AddQFRow(worksheet, ++row, "design_id", sheet.Records, x => x.AttributeValues.design_id);
                    AddQFRow(worksheet, ++row, "device", sheet.Records, x => x.AttributeValues.device);
                    AddQFRow(worksheet, ++row, "fab_conv_id", sheet.Records, x => x.AttributeValues.fab_conv_id);
                    AddQFRow(worksheet, ++row, "fab_excr_id", sheet.Records, x => x.AttributeValues.fab_excr_id);
                    AddQFRow(worksheet, ++row, "fabrication_facility", sheet.Records, x => x.AttributeValues.fabrication_facility);
                    AddQFRow(worksheet, ++row, "lead_count", sheet.Records, x => x.AttributeValues.lead_count);
                    AddQFRow(worksheet, ++row, "major_probe_prog_rev", sheet.Records, x => x.AttributeValues.major_probe_prog_rev);
                    AddQFRow(worksheet, ++row, "marketing_speed", sheet.Records, x => x.AttributeValues.marketing_speed);
                    AddQFRow(worksheet, ++row, "non_shippable", sheet.Records, x => x.AttributeValues.non_shippable);
                    AddQFRow(worksheet, ++row, "num_array_decks", sheet.Records, x => x.AttributeValues.num_array_decks);
                    AddQFRow(worksheet, ++row, "num_flash_ce_pins", sheet.Records, x => x.AttributeValues.num_flash_ce_pins);
                    AddQFRow(worksheet, ++row, "num_io_channels", sheet.Records, x => x.AttributeValues.num_io_channels);
                    AddQFRow(worksheet, ++row, "number_of_die_in_pkg", sheet.Records, x => x.AttributeValues.number_of_die_in_pkg);
                    AddQFRow(worksheet, ++row, "pgtier", sheet.Records, x => x.AttributeValues.pgtier);
                    AddQFRow(worksheet, ++row, "prb_conv_id", sheet.Records, x => x.AttributeValues.prb_conv_id);
                    AddQFRow(worksheet, ++row, "product_grade", sheet.Records, x => x.AttributeValues.product_grade);
                    AddQFRow(worksheet, ++row, "reticle_wave_id", sheet.Records, x => x.AttributeValues.reticle_wave_id);

                    // autofit columns
                    column = 0;
                    worksheet.Columns[column].AutoFit();
                    foreach (var record in sheet.Records)
                    {
                        worksheet.Columns[++column].AutoFit();
                    }

                    ++worksheetIndex;
                }

                workbook.EndUpdate();
                var stream = new MemoryStream();
                workbook.SaveDocument(stream, DocumentFormat.Xlsx);
                stream.Seek(0, SeekOrigin.Begin);
                return stream;
            }
        }

        private static void AddQFRow(Worksheet worksheet, int row, string rowDescription, QualFilterRecords records, Func<QualFilterRecord, string> function)
        {
            int column = 0;
            worksheet.Cells[row, column].Value = rowDescription;
            foreach (var record in records)
            {
                worksheet.Cells[row, ++column].Value = function(record);
            }
        }

        private static DataSet TryQualFilterSpreadsheetToDataSet(Stream stream, out string message)
        {
            var result = new DataSet();
            try
            {

                message = null;
                var attributes = new DataTable("Attributes");
                attributes.Columns.Add("Index", typeof(int));
                attributes.Columns.Add("CriteriaIndex", typeof(int));
                attributes.Columns.Add("Name", typeof(string));
                attributes.Columns.Add("Value", typeof(string));
                result.Tables.Add(attributes);
                var criterias = new DataTable("Criterias");
                criterias.Columns.Add("Index", typeof(int));
                criterias.Columns.Add("GroupIndex", typeof(int));
                criterias.Columns.Add("SourceIndex", typeof(int));
                criterias.Columns.Add("Name", typeof(string));
                criterias.Columns.Add("DeviceName", typeof(string));
                criterias.Columns.Add("PartNumberDecode", typeof(string));
                criterias.Columns.Add("ES", typeof(string));
                result.Tables.Add(criterias);
                var groups = new DataTable("Groups");
                groups.Columns.Add("Index", typeof(int));
                groups.Columns.Add("SourceIndex", typeof(int));
                groups.Columns.Add("Name", typeof(string));
                result.Tables.Add(groups);
                var groupFields = new DataTable("GroupFields");
                groupFields.Columns.Add("Index", typeof(int));
                groupFields.Columns.Add("GroupIndex", typeof(int));
                groupFields.Columns.Add("SourceIndex", typeof(int));
                groupFields.Columns.Add("Name", typeof(string));
                groupFields.Columns.Add("SourceName", typeof(string));
                groupFields.Columns.Add("IsAttribute", typeof(bool));
                result.Tables.Add(groupFields);
                var attributeIndex = 1;
                var criteriaIndex = 1;
                var groupIndex = 1;
                var groupFieldIndex = 1;
                var worksheetIndex = 0;
                using (var workbook = new Workbook())
                {
                    workbook.LoadDocument(stream);
                    foreach (var worksheet in workbook.Worksheets.Where(x => x.Visible))
                    {
                        var worksheetName = worksheet.Name?.Trim();
                        var worksheetNameUpper = worksheetName?.ToUpper();
                        if (worksheetNameUpper == "NOTES" || worksheetNameUpper == "UPDATE HISTORY")
                        {
                            // worksheet ignored
                        }
                        else
                        {
                            // worksheet contains data to be imported
                            var group = groups.NewRow();
                            group["Index"] = groupIndex;
                            group["SourceIndex"] = worksheetIndex;
                            group["Name"] = worksheetName.NullToDBNull();
                            groups.Rows.Add(group);
                            var attributesRowIndexReached = false;
                            var range = worksheet.GetDataRange();
                            var columnIndex = range.LeftColumnIndex;
                            var rowIndexToAttributeName = new Dictionary<int, string>();
                            var rowIndexToCriteriaColumn = new Dictionary<int, DataColumn>();
                            var first = true;
                            // loop to determine what each row represents
                            for (var rowIndex = range.TopRowIndex; rowIndex <= range.BottomRowIndex; ++rowIndex)
                            {
                                DataRow groupField = null;
                                var cellText = worksheet.Cells[rowIndex, columnIndex].DisplayText?.Trim();
                                if (!attributesRowIndexReached) // determine what criteria column the row represents
                                {
                                    DataColumn column = null;
                                    var cellTextUpper = cellText?.ToUpper();
                                    if (first)
                                    {
                                        first = false;
                                        if (string.IsNullOrWhiteSpace(cellTextUpper)) column = criterias.Columns["Name"];
                                    }
                                    if (column == null && !string.IsNullOrEmpty(cellTextUpper))
                                    {
                                        if (cellTextUpper.StartsWith("DEVICE NAME")) column = criterias.Columns["DeviceName"];
                                        else if (cellTextUpper.StartsWith("PART NUMBER DECODE")) column = criterias.Columns["PartNumberDecode"];
                                        else if (cellTextUpper == "ES") column = criterias.Columns["ES"];
                                        else if (cellTextUpper.Contains("REQUIRED") && cellTextUpper.Contains("ATTRIBUTE") && cellTextUpper.Contains("CONDITIONS"))
                                        {
                                            attributesRowIndexReached = true;
                                        }
                                    }
                                    if (column != null)
                                    {
                                        rowIndexToCriteriaColumn[rowIndex] = column;
                                        groupField = groupFields.NewRow();
                                        groupField["Index"] = groupFieldIndex;
                                        groupField["GroupIndex"] = groupIndex;
                                        groupField["SourceIndex"] = rowIndex;
                                        groupField["Name"] = column.ColumnName;
                                        groupField["SourceName"] = cellText;
                                        groupField["IsAttribute"] = false;
                                    }
                                }
                                else // determine what attribute type the row represents
                                {
                                    if (!string.IsNullOrEmpty(cellText))
                                    {
                                        rowIndexToAttributeName[rowIndex] = cellText;
                                        groupField = groupFields.NewRow();
                                        groupField["Index"] = groupFieldIndex;
                                        groupField["GroupIndex"] = groupIndex;
                                        groupField["SourceIndex"] = rowIndex;
                                        groupField["Name"] = cellText;
                                        groupField["IsAttribute"] = true;
                                    }
                                }
                                if (groupField != null)
                                {
                                    groupFields.Rows.Add(groupField);
                                    ++groupFieldIndex;
                                }
                            }
                            // loop through columns (other than the first) which contain criteria
                            for (++columnIndex; columnIndex <= range.RightColumnIndex; ++columnIndex)
                            {
                                var allCellsEmpty = true;
                                string cellText;
                                var criteria = criterias.NewRow();
                                criteria["Index"] = criteriaIndex;
                                criteria["GroupIndex"] = groupIndex;
                                criteria["SourceIndex"] = columnIndex;
                                foreach (var item in rowIndexToCriteriaColumn)
                                {
                                    cellText = worksheet.Cells[item.Key, columnIndex].DisplayText?.Trim();
                                    if (!string.IsNullOrEmpty(cellText))
                                    {
                                        allCellsEmpty = false;
                                        criteria[item.Value] = cellText.NullToDBNull();
                                    }
                                }
                                var attributesTemp = new List<DataRow>();
                                var attributeIndexTemp = attributeIndex; // until we know if all cells are empty, use a temporary index initialized to the current value
                                foreach (var item in rowIndexToAttributeName)
                                {
                                    var attribute = attributes.NewRow();
                                    cellText = worksheet.Cells[item.Key, columnIndex].DisplayText?.Trim();
                                    attribute["Index"] = attributeIndexTemp++;
                                    attribute["CriteriaIndex"] = criteriaIndex;
                                    attribute["Name"] = item.Value;
                                    attribute["Value"] = cellText.NullToDBNull();
                                    attributesTemp.Add(attribute);
                                    if (!string.IsNullOrEmpty(cellText))
                                    {
                                        allCellsEmpty = false;
                                    }
                                }
                                if (!allCellsEmpty)
                                {
                                    criterias.Rows.Add(criteria);
                                    ++criteriaIndex;
                                    foreach (var attribute in attributesTemp) attributes.Rows.Add(attribute);
                                    attributeIndex = attributeIndexTemp;
                                }
                            }
                            ++groupIndex;
                        }
                        ++worksheetIndex;
                    }
                }
                attributes.AcceptChanges();
                criterias.AcceptChanges();
                groups.AcceptChanges();
                groupFields.AcceptChanges();
            }
            catch (Exception e)
            {
                message = $"{e.Message}-{e.StackTrace}";
            }
            return result;
        }
        #endregion
    }
}
