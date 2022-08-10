using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using CsvHelper;
using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Logging;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;
using Intel.NsgAuto.Callisto.Business.Entities.ODM.Handlers;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Excel;
using Intel.NsgAuto.Shared.Extensions;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class OdmNpsgDataContext : OdmDataContext, IOdmNpsgDataContext
    {
        //private static readonly ILog Logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        #region MAT

        public MatVersions GetMatVersionDetails(string userId, int versionId)
        {
            MatVersions result = new MatVersions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMMATVERSIONDETAILS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Version", versionId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newMatVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public ImportVersions GetMatVersions(string userId)
        {
            ImportVersions result = new ImportVersions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMMATVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public ImportResult Import(string userId, MatRecords records)
        {
            ImportResult result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                result = new ImportResult();
                result.Messages = new List<string>();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_IMPORTMATRECORDS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddTableValueParameter("@MatRecords", NpsgUserDefinedTypes.MATRECORDS, createTableImport(records));
                dataAccess.ExecuteReader();

                result.Messages.Add("File loaded Successfully");
                result.HasErrors = false;
            }
            catch (Exception ex)
            {
                result.Messages.Add(ex.Message.ToStringSafely());
                result.HasErrors = true;

                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private DataTable createTableImport(MatRecords entities)
        {
            var table = createMatTableImport();
            foreach (var entity in entities)
            {
                var row = table.NewRow();
                populateRow(row, entity);
                table.Rows.Add(row);
            }
            table.AcceptChanges();
            return table;
        }

        private DataTable createMatTableImport()
        {
            var result = new DataTable();
            result.Columns.Add("WW", typeof(string));
            result.Columns.Add("SSD_Id", typeof(string));
            result.Columns.Add("Design_Id", typeof(string));
            result.Columns.Add("Scode", typeof(string));
            result.Columns.Add("Cell_Revision", typeof(string));
            result.Columns.Add("Major_Probe_Program_Revision", typeof(string));
            result.Columns.Add("Probe_Revision", typeof(string));
            result.Columns.Add("Burn_Tape_Revision", typeof(string));
            result.Columns.Add("Custom_Testing_Required", typeof(string));
            result.Columns.Add("Custom_Testing_Required2", typeof(string));
            result.Columns.Add("Product_Grade", typeof(string));
            result.Columns.Add("Prb_Conv_Id", typeof(string));
            result.Columns.Add("Fab_Conv_Id", typeof(string));
            result.Columns.Add("Fab_Excr_Id", typeof(string));
            result.Columns.Add("Media_Type", typeof(string));
            result.Columns.Add("Media_IPN", typeof(string));
            result.Columns.Add("Device_Name", typeof(string));
            result.Columns.Add("Reticle_Wave_Id", typeof(string));
            result.Columns.Add("Fab_Facility", typeof(string));
            result.Columns.Add("Create_Date", typeof(DateTime));
            result.Columns.Add("Latest", typeof(string));
            result.Columns.Add("File_Type", typeof(string));

            return result;
        }

        public DispositionVersions GetDispositionVersions(string userId)
        {
            DispositionVersions result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                result = new DispositionVersions();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMMANUALDISPOSITIONSVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new DispositionVersion()
                        {
                            CreatedBy = reader["CreatedBy"].ToStringSafely(),
                            CreatedOn = reader["CreatedOn"].ToDateTimeSafely(),
                            UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                            UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely(),
                            Version = reader["Version"].ToIntegerSafely(),
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        /// <summary>
        /// Columns that are mandatory in the excel sheet that is being used for importing dispositions
        /// </summary>
        private List<string> dispositionsRequiredColumns = new List<string>()
        {
            "SLot",
            "IPN"
        };
        private ImportDispositionsResponse parseDispositions(Stream stream, string filename)
        {
            ImportDispositionsResponse result = null;
            IExcelReaderAccess excelReaderAccess = null;
            try
            {
                result = new ImportDispositionsResponse();
                result.Messages = new List<string>();

                string extension = Functions.GetFileExtension(filename).ToUpperInvariant();
                if (extension == "XLS" || extension == "XLSX")
                {
                    excelReaderAccess = new ExcelReaderAccess(stream);
                    excelReaderAccess.Extension = extension;
                    List<string> workSheetNames = excelReaderAccess.GetWorkSheetNames();
                    string actionValue = String.Empty;

                    if (workSheetNames.IsNotNull() && workSheetNames.Count > 0)
                    {
                        List<DataRow> rows = excelReaderAccess.GetDataRows(workSheetNames[0]);
                        int startIndex = 0; // First row with column names already skipped by ExcelReaderAccess (since IsFirstRowColumnRow = true)
                        if (rows.IsNotNull() && rows.Count > startIndex)
                        {
                            DataColumnCollection columns = rows[0].Table.Columns; // get a reference to the columns (they are the same for all rows)
                            List<string> missingColumns = new List<string>();
                            foreach (string column in dispositionsRequiredColumns)
                            {
                                if (!columns.Contains(column)) missingColumns.Add(column);
                            }
                            if (missingColumns.Count > 0)
                            {
                                result.Messages.Add($"Required column(s) not found: {missingColumns.JoinString(", ")}");
                            }
                            else
                            {
                                result.Dispositions = new Dispositions();
                                for (int i = startIndex; i < rows.Count; ++i)
                                {
                                    actionValue = rows[i].FieldToStringSafely("Action");
                                    result.Dispositions.Add(new Disposition()
                                    {
                                        SLot = rows[i].FieldToStringSafely("SLot"),
                                        IntelPartNumber = rows[i].FieldToStringSafely("IPN"),
                                        ////Id  Description
                                        ////10  Manual Disposition
                                        Reason = new LotDispositionReason()
                                        {
                                            Id = 10,
                                            Name = "Manual Disposition"
                                        },
                                        ////Id  ActionName  DisplayText
                                        ////1   Marked_Non_Qualified    Marked Non Qualified
                                        ////2   Marked_Qualified    Marked Qualified
                                        //Action = new LotDispositionAction()
                                        //{
                                        //    Id = actionValue == 1,
                                        //    ActionName = "Marked_Non_Qualified",
                                        //    DisplayText = "Marked Non Qualified"
                                        //},
                                        Action = new LotDispositionAction()
                                        {
                                            Id = actionValue == "Marked Qualified" ? 2 : 1,
                                            ActionName = actionValue == "Marked Qualified" ?  "Marked_Qualified" : "Marked_Non_Qualified",
                                            DisplayText = actionValue
                                        },

                                        Notes = String.Empty
                                    });
                                }
                                result.Succeeded = true;
                            }
                        }
                        else
                        {
                            result.Messages.Add("The spreadsheet does not have any data.");
                        }
                    }
                    else
                    {
                        result.Messages.Add("The spreadsheet does not have any worksheets.");
                    }
                }
                else
                {
                    result.Messages.Add("Unsupported file extension. Use xls or xlsx files spreadsheets.");
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

        private DataTable createDispositionsImportTable(Dispositions dispositions)
        {
            DataTable table = null;
            try
            {
                table = new DataTable();
                table.Columns.Add("SLot", typeof(string));
                table.Columns.Add("IntelPartNumber", typeof(string));
                table.Columns.Add("LotDispositionReasonId", typeof(int));
                table.Columns.Add("Notes", typeof(string));
                table.Columns.Add("LotDispositionActionId", typeof(int));
                DataRow row = null;
                foreach (Disposition disposition in dispositions)
                {
                    row = table.NewRow();
                    row["SLot"] = disposition.SLot;
                    row["IntelPartNumber"] = disposition.IntelPartNumber;
                    row["LotDispositionReasonId"] = disposition.Reason.Id;
                    row["Notes"] = disposition.Notes;
                    row["LotDispositionActionId"] = disposition.Action.Id;
                    table.Rows.Add(row);
                }
                table.AcceptChanges();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return table;
        }

        public ImportDispositionsResponse ImportDispositions(Stream stream, string filename, string userId)
        {
            ImportDispositionsResponse response = null;
            try
            {
                // Parse the S-Lots from the excel file stream
                response = parseDispositions(stream, filename);
                if (response.Succeeded)
                {
                    response.Succeeded = false;
                    // Save the data into the database
                    ISqlDataAccess dataAccess = null;
                    try
                    {

                        dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_IMPORTODMMANUALDISPOSITIONS);
                        dataAccess.AddInputParameter("@UserId", userId);
                        dataAccess.AddTableValueParameter("@OdmManualDispositions", NpsgUserDefinedTypes.ODMMANUALDISPOSITIONS, createDispositionsImportTable(response.Dispositions));
                        using (IDataReader reader = dataAccess.ExecuteReader())
                        {
                            response.Dispositions = new Dispositions();
                            while (reader.Read())
                            {
                                response.Dispositions.Add(new Disposition()
                                {
                                    Action = new LotDispositionAction()
                                    {
                                        Id = reader["LotDispositionActionId"].ToIntegerSafely(),
                                        ActionName = reader["LotDispositionActionName"].ToStringSafely(),
                                        DisplayText = reader["LotDispositionActionDisplayText"].ToStringSafely()
                                    },
                                    CreatedBy = reader["CreatedBy"].ToStringSafely(),
                                    CreatedOn = reader["CreatedOn"].ToDateTimeSafely(),
                                    Id = reader["Id"].ToIntegerSafely(),
                                    Notes = reader["Notes"].ToStringSafely(),
                                    Reason = new LotDispositionReason()
                                    {
                                        Id = reader["LotDispositionReasonId"].ToIntegerSafely(),
                                        Name = reader["LotDispositionReason"].ToStringSafely(),
                                    },
                                    SLot = reader["SLot"].ToStringSafely(),
                                    IntelPartNumber = reader["IntelPartNumber"].ToStringSafely(),
                                    UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                                    UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely(),
                                    Version = reader["Version"].ToIntegerSafely(),

                                });
                            }

                            // Read the versions and populate it in the response object
                            reader.NextResult();
                            response.Versions = new DispositionVersions();
                            while (reader.Read())
                            {
                                response.Versions.Add(new DispositionVersion()
                                {
                                    CreatedBy = reader["CreatedBy"].ToStringSafely(),
                                    CreatedOn = reader["CreatedOn"].ToDateTimeSafely(),
                                    UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                                    UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely(),
                                    Version = reader["Version"].ToIntegerSafely(),
                                });
                            }
                        }

                        response.Messages.Add("Dispositions has been saved successfully");
                        response.Succeeded = true;
                    }
                    catch (Exception ex)
                    {
                        response.Messages.Add(ex.Message.ToStringSafely());
                        response.Succeeded = false;
                        throw ex;
                    }
                    finally
                    {
                        dataAccess?.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {

            }

            return response;
        }

        public Dispositions GetDispositionsByVersion(int versionId, string userId)
        {
            Dispositions result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                result = new Dispositions();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMMANUALDISPOSITIONSBYVERSION);
                dataAccess.AddInputParameter("@Version", versionId);
                dataAccess.AddInputParameter("@UserId", userId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new Disposition()
                        {
                            Action = new LotDispositionAction()
                            {
                                Id = reader["LotDispositionActionId"].ToIntegerSafely(),
                                ActionName = reader["LotDispositionActionName"].ToStringSafely(),
                                DisplayText = reader["LotDispositionActionDisplayText"].ToStringSafely()
                            },
                            CreatedBy = reader["CreatedBy"].ToStringSafely(),
                            CreatedOn = reader["CreatedOn"].ToDateTimeSafely(),
                            Id = reader["Id"].ToIntegerSafely(),
                            Notes = reader["Notes"].ToStringSafely(),
                            Reason = new LotDispositionReason()
                            {
                                Id = reader["LotDispositionReasonId"].ToIntegerSafely(),
                                Name = reader["LotDispositionReason"].ToStringSafely(),
                            },
                            SLot = reader["SLot"].ToStringSafely(),
                            IntelPartNumber = reader["IntelPartNumber"].ToStringSafely(),
                            UpdatedBy = reader["UpdatedBy"].ToStringSafely(),
                            UpdatedOn = reader["UpdatedOn"].ToDateTimeSafely(),
                            Version = reader["Version"].ToIntegerSafely(),
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private void populateRow(DataRow row, MatRecord entity)
        {
            row["WW"] = entity.WorkWeek;
            row["SSD_Id"] = entity.SSDId.NullToDBNull();
            row["Design_Id"] = entity.DesignId.NullToDBNull();
            row["Scode"] = entity.Scode.NullToDBNull();
            row["Cell_Revision"] = entity.CellRevision.NullToDBNull();
            row["Major_Probe_Program_Revision"] = entity.MPPR.NullToDBNull();
            row["Probe_Revision"] = entity.ProbeRevision.NullToDBNull();
            row["Burn_Tape_Revision"] = entity.BurnTapeRevision.NullToDBNull();
            row["Custom_Testing_Required"] = entity.CustomTestingRequired.NullToDBNull();
            row["Custom_Testing_Required2"] = entity.CustomTestingRequired2.NullToDBNull();
            row["Product_Grade"] = entity.ProductGrade.NullToDBNull();
            row["Prb_Conv_Id"] = entity.PrbConvId.NullToDBNull();
            row["Fab_Conv_Id"] = entity.FabConvId.NullToDBNull();
            row["Fab_Excr_Id"] = entity.FabExcrId.NullToDBNull();
            row["Media_Type"] = entity.MediaType.NullToDBNull();
            row["Media_IPN"] = entity.MediaIPN.NullToDBNull();
            row["Device_Name"] = entity.DeviceName.NullToDBNull();
            row["Reticle_Wave_Id"] = entity.ReticleWaveId.NullToDBNull();
            row["Fab_Facility"] = entity.FabFacility.NullToDBNull();
            row["Create_Date"] = entity.CreatedOn.NullToDBNull();
            row["Latest"] = entity.Latest.NullToDBNull();
            row["File_Type"] = entity.FileType.NullToDBNull();
        }

        #endregion

        #region PRF

        public PrfVersions GetPrfVersionDetails(string userId, int versionId)
        {
            PrfVersions result = new PrfVersions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMPRFVERSIONDETAILS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@VersionId", versionId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newPrfVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public ImportVersions GetPrfVersions(string userId)
        {
            ImportVersions result = new ImportVersions();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMPRFVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId);
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        //result.Add(newVersion(reader));

                        result.Add(new ImportVersion()
                        {
                            Id = reader["Id"].ToIntegerSafely(),
                            Version = reader["VersionNumber"].ToIntegerSafely(),
                            IsActive = true,
                            CreatedBy = reader["CreatedBy"].ToStringSafely(),
                            CreatedOn = reader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public ImportResult Import(string userId, PrfRecords records)
        {
            ImportResult result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                result = new ImportResult();
                result.Messages = new List<string>();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_IMPORTPRFRECORDS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddTableValueParameter("@PrfRecords", NpsgUserDefinedTypes.PRFRECORDS, createTableImport(records));
                dataAccess.ExecuteReader();

                result.Messages.Add("File loaded Successfully");
                result.HasErrors = false;
            }
            catch (Exception ex)
            {
                result.Messages.Add(ex.Message.ToStringSafely());
                result.HasErrors = true;

                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private DataTable createTableImport(PrfRecords prfRecords)
        {
            DataTable table = new DataTable();
            table.Columns.Add("Odm_Desc", typeof(string));
            table.Columns.Add("SSD_Family_Name", typeof(string));
            table.Columns.Add("MM_Number", typeof(string));
            table.Columns.Add("Product_Code", typeof(string));
            table.Columns.Add("SSD_Name", typeof(string));
            table.Columns.Add("CreateDate", typeof(DateTime));

            DataRow row = null;
            foreach (var prfRecord in prfRecords)
            {
                row = table.NewRow();
                row["ODM_Desc"] = prfRecord.ODMDescription;
                row["SSD_Family_Name"] = prfRecord.SSDFamilyName;
                row["MM_Number"] = prfRecord.MMNumber;
                row["Product_Code"] = prfRecord.ProductCode;
                row["SSD_Name"] = prfRecord.SSDName;
                row["CreateDate"] = prfRecord.CreatedOn.NullToDBNull();
                table.Rows.Add(row);
            }
            table.AcceptChanges();
            return table;
        }

        #endregion

        #region ODM Qual Filter

        public Result RunQualFilter(string userId)
        {
            Result response = new Result();
            ISqlDataAccess dataAccess = null;
            IDataReader reader;

            try
            {
                //Commons.InitializeConfiguration();

                //Logger.Info($"Entering RunQualFilter as {userId}");
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTER);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.SetTimeout(5 * 60);
                //Logger.Info("Executing Query : [qan].[GetODMQualFilter]");
                reader = dataAccess.ExecuteReader();
                //Logger.Info("Executed Query : [qan].[GetODMQualFilter]");

                var nonQualifiedParts = new NonQualifiedParts();
                NonQualifiedPart nonQualifiedPart = null;
                while (reader.Read())
                {
                    nonQualifiedPart = new NonQualifiedPart()
                    {
                        MMNum = reader["MMNum"].ToStringSafely(),
                        OdmName = reader["OdmName"].ToStringSafely(),
                        DesignId = reader["DesignId"].ToStringSafely(),
                        Media_IPN = reader["OsatIpn"].ToStringSafely(),
                        SLots = reader["Slots"].ToStringSafely(),
                        CreateDate = reader["CreateDate"].ToStringSafely()
                    };
                    nonQualifiedParts.Add(nonQualifiedPart);
                }

                // QUALIFIED WITHIN NON QUALIFIED LIST
                dataAccess.DataReader.NextResult();
                var exemptParts = new ExemptParts();
                ExemptPart exemptPart = null;
                while (reader.Read())
                {
                    exemptPart = new ExemptPart()
                    {
                        Design_Id = reader["Design_Id"].ToStringSafely(),
                        Device_Name = reader["Device_Name"].ToStringSafely(),
                        MediaIpn = reader["MediaIpn"].ToStringSafely(),
                        Media_Type = reader["Media_Type"].ToStringSafely(),
                        OdmName = reader["OdmName"].ToStringSafely(),
                        ScodeMm = reader["ScodeMm"].ToStringSafely(),
                        SLot = reader["SLot"].ToStringSafely(),
                        SSD_Id = reader["ScodeMm"].ToStringSafely()
                    };
                    exemptParts.Add(exemptPart);
                }
                // DISTINCT ODM NAMES
                dataAccess.DataReader.NextResult();
                List<string> odmNames = new List<string>();
                while (reader.Read())
                {
                    odmNames.Add(reader["OdmName"].ToStringSafely().Trim());
                }
                // For each ODM, write a CSV file
                var nonQualifiedPartsFile = String.Empty;
                var exemptPartsFile = String.Empty;
                var nonQualifiedPartsByOdm = new NonQualifiedParts();
                var exemptPartsByOdm = new ExemptParts();
                List<FileInfo> files;
                string utcTimeStamp = DateTime.UtcNow.ToString("yyyymmddhhmmss");
                // For every ODM
                foreach (var odmName in odmNames)
                {
                    // re-initialize the variables
                    nonQualifiedPartsByOdm = new NonQualifiedParts();
                    exemptPartsByOdm = new ExemptParts();
                    // Get the records by odm name
                    nonQualifiedPartsByOdm = nonQualifiedParts.GetByOdmName(odmName);
                    exemptPartsByOdm = exemptParts.GetByOdmName(odmName);
                    // Set the local file names for the ODM
                    string odmLocalPath = String.Format(Settings.ODMFilterOutputPathNand, odmName);
                    // If the directory does not exist, create it
                    if (!Directory.Exists(odmLocalPath))
                    {
                        Directory.CreateDirectory(odmLocalPath);
                    }
                    nonQualifiedPartsFile = Path.Combine(odmLocalPath + @"\ODM_Non-Qualified_Media_FilterReport_NPSG_" + odmName + "_" + utcTimeStamp + ".csv");
                    exemptPartsFile = Path.Combine(odmLocalPath + @"\ODM_Qualified_Media_FilterReport_NPSG_" + odmName + "_" + utcTimeStamp + ".csv");
                    // write the non qualified parts to file
                    using (var writer = new StreamWriter(nonQualifiedPartsFile))
                    {
                        //if (nonQualifiedPartsByOdm.Count > 0)
                        //{
                        using (var csv = new CsvWriter(writer, CultureInfo.InvariantCulture))
                        {
                            csv.WriteRecords(nonQualifiedPartsByOdm);
                        }
                        //}
                    }
                    // write the exempt parts from non qualified parts
                    using (var writer = new StreamWriter(exemptPartsFile))
                    {
                        //if (exemptPartsByOdm.Count > 0)
                        //{
                        using (var csv = new CsvWriter(writer, CultureInfo.InvariantCulture))
                        {
                            csv.WriteRecords(exemptPartsByOdm);
                        }
                        //}
                    }
                    FileInfo nonQualifiedPartsFileInfo = new FileInfo(nonQualifiedPartsFile);
                    FileInfo exemptPartsFileInfo = new FileInfo(exemptPartsFile);
                    // Send email per ODM
                    files = new List<FileInfo>()
                    {
                       nonQualifiedPartsFileInfo,
                       exemptPartsFileInfo
                    };

                    if (EmailHelper.Send(files, Settings.GetOdmEmailRecipients(odmName, "NAND"), "NAND", odmName))
                    {
                        //Logger.Info($"Sent emails for {odmName}");
                    }
                    // Post files to FTP for the ODM
                    //PostToFTPLocation();
                    string odmPath = String.Format(Settings.FTPLocation, "Nand", odmName);
                    if (!Directory.Exists(odmPath))
                    {
                        Directory.CreateDirectory(odmPath);
                    }
                    string nonQualifiedPartsDestFile = Path.Combine(odmPath + "\\" + Path.GetFileName(nonQualifiedPartsFileInfo.Name));
                    string exemptPartsDestFile = Path.Combine(odmPath + "\\" + Path.GetFileName(exemptPartsFileInfo.Name));
                    nonQualifiedPartsFileInfo.CopyTo(nonQualifiedPartsDestFile, true);
                    exemptPartsFileInfo.CopyTo(exemptPartsDestFile, true);

                }

                response.Messages = new List<string>();
                response.Messages.Add("Query executed successfully");
            }
            catch (Exception ex)
            {
                //Logger.Debug(ex.InnerException);
                response.Messages = new List<string>();
                response.Messages.Add(ex.Message.ToString());
                throw ex;
            }
            finally
            {
                if (dataAccess.IsNotNull())
                {
                    dataAccess.Close();
                }
            }
            return response;
        }

        #endregion

        #region ODM Qual Filter Scenarios

        public Result SaveLotDispositions(string userId, LotDispositions lotDispositions)
        {
            DataTable dtLotDispositions = getLotDispositionDataTable(lotDispositions);
            SaveLotDispositionResponse response = new SaveLotDispositionResponse();
            response.Messages = new List<string>();

            QualFilterScenario result = new QualFilterScenario();
            NonQualifiedMediasRaw nonQualifiedsRaw = new NonQualifiedMediasRaw();
            NonQualifiedMediaExceptions nonQualifiedMediaExceptions = new NonQualifiedMediaExceptions();
            ComparisonLotDispositions comparisons = new ComparisonLotDispositions();
            LotDispositionReasons reasons = new LotDispositionReasons();
            LotDispositionActions actions = new LotDispositionActions();

            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_SAVELOTDISPOSITIONS);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddTableValueParameter("@lotDispositions", NpsgUserDefinedTypes.ODMLOTDISPOSITIONS, dtLotDispositions);
                //dataAccess.AddInputParameter("@lotDispositions", dtLotDispositions);

                // Read updated non qualified media, exceptions and comparisons
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    reader.Read();
                    result.Version = newQualFilterScenarioVersion(reader);

                    reader.NextResult();
                    while (reader.Read())
                    {
                        reasons.Add(newLotDispositionReason(reader));
                    }
                    result.LotDispositionReasons = reasons;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        actions.Add(newLotDispositionAction(reader));
                    }
                    result.LotDispositionActions = actions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisons.Add(newComparison(reader));
                    }
                    result.Comparisons = comparisons;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedsRaw.Add(newNonQualifiedRaw(reader));
                    }
                    result.NonQualifiedsRaw = nonQualifiedsRaw;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedMediaExceptions.Add(newNonQualifiedException(reader));
                    }
                    result.NonQualifiedMediaExceptions = nonQualifiedMediaExceptions;
                }
                response.Scenario = result;
                response.Succeeded = true;
                response.Messages.Add("Lot Dispositions saved successfully.");
            }
            catch (Exception ex)
            {
                response.Succeeded = false;
                response.Messages.Add(ex.Message);
                throw;
            }
            finally
            {
                dataAccess?.Close();
            }

            return response;
        }

        private DataTable getLotDispositionDataTable(List<LotDisposition> lotDispositions)
        {
            DataTable dt = new DataTable();

            dt.Columns.Add("Id", typeof(int));
            dt.Columns.Add("ScenarioId", typeof(int));
            dt.Columns.Add("OdmQualFilterId", typeof(int));
            dt.Columns.Add("LotDispositionReasonId", typeof(int));
            dt.Columns.Add("Notes", typeof(string));
            dt.Columns.Add("LotDispositionActionId", typeof(int));

            DataRow dr;
            for (int idx = 0; idx < lotDispositions.Count; idx++)
            {
                dr = dt.NewRow();

                dr["Id"] = idx + 1; //lotDispositions[idx].Id;
                dr["ScenarioId"] = lotDispositions[idx].ScenarioId;
                dr["OdmQualFilterId"] = lotDispositions[idx].OdmQualFilterId;
                dr["LotDispositionReasonId"] = lotDispositions[idx].LotDispositionReasonId;
                dr["Notes"] = lotDispositions[idx].Notes;
                dr["LotDispositionActionId"] = lotDispositions[idx].LotDispositionActionId;

                dt.Rows.Add(dr);
            }

            return dt;
        }

        public Result CreateLotDisposition(string userId, LotDispositionDto lotDisposition)
        {
            SaveLotDispositionResponse response = new SaveLotDispositionResponse();
            response.Messages = new List<string>();

            QualFilterScenario result = new QualFilterScenario();
            NonQualifiedMediasRaw nonQualifiedsRaw = new NonQualifiedMediasRaw();
            NonQualifiedMediaExceptions nonQualifiedMediaExceptions = new NonQualifiedMediaExceptions();
            ComparisonLotDispositions comparisons = new ComparisonLotDispositions();
            LotDispositionReasons reasons = new LotDispositionReasons();
            LotDispositionActions actions = new LotDispositionActions();

            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_CREATEODMQUALFILTERLOTDISPOSITION);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@ScenarioId", lotDisposition.ScenarioId);
                dataAccess.AddInputParameter("@OdmQualFilterId", lotDisposition.OdmQualFilterId);
                dataAccess.AddInputParameter("@LotDispositionReasonId", lotDisposition.LotDispoistionReasonId);
                dataAccess.AddInputParameter("@Notes", lotDisposition.Notes);
                dataAccess.AddInputParameter("@LotDispositionActionId", lotDisposition.LotDispoistionActionId);
                // Read updated non qualified media, exceptions and comparisons
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    reader.Read();
                    result.Version = newQualFilterScenarioVersion(reader);

                    reader.NextResult();
                    while (reader.Read())
                    {
                        reasons.Add(newLotDispositionReason(reader));
                    }
                    result.LotDispositionReasons = reasons;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        actions.Add(newLotDispositionAction(reader));
                    }
                    result.LotDispositionActions = actions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisons.Add(newComparison(reader));
                    }
                    result.Comparisons = comparisons;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedsRaw.Add(newNonQualifiedRaw(reader));
                    }
                    result.NonQualifiedsRaw = nonQualifiedsRaw;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedMediaExceptions.Add(newNonQualifiedException(reader));
                    }
                    result.NonQualifiedMediaExceptions = nonQualifiedMediaExceptions;
                }
                response.Scenario = result;
                response.Messages.Add("Query executed successfully");
            }
            catch (Exception ex)
            {
                response.Messages.Add(ex.Message.ToString());
            }
            finally
            {
                dataAccess?.Close();
            }

            return response;
        }

        public LotDispositionActions GetLotDispositionActions(string userId, int? id = null)
        {
            LotDispositionActions result = new LotDispositionActions();
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMLOTDISPOSITIONACTIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newLotDispositionAction(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public IdAndNames GetLotDispositionReasons(string userId, int? id = null)
        {
            IdAndNames result = new IdAndNames();
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMLOTDISPOSITIONREASONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newLotDispositionReason(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public QualFilterScenario GetQualFilterScenario(string userId, int versionId)
        {
            return getQualFilterScenario(userId, versionId);
        }

        public QualFilterScenario GetQualFilterHistoricalScenario(string userId, int versionId)
        {
            return getQualFilterHistoricalScenario(userId, versionId);
        }

        public QualFilterScenarioVersions GetQualFilterScenarioVersions(string userId)
        {
            return getQualFilterScenarioVersions(userId);
        }

        public QualFilterScenarioVersions GetQualFilterScenarioVersionsDaily(string userId)
        {
            return getQualFilterScenarioVersionsDaily(userId);
        }

        public QualFilterScenarioVersions GetOdmQualFilterScenarioHistoricalVersions(string userId)
        {
            return getQualFilterScenarioHistoricalVersions(userId);
        }

        public QualFilterRemovableSLotUploads GetQualFilterRemovableSLotUploads(string userId, DateTime loadToDate)
        {
            return base.GetQualFilterRemovableSLotUploads(userId, loadToDate, NpsgStoredProcedures.SP_GETQUALFILTERNPSGREMOVABLESLOTUPLOADS);
        }

        private QualFilterScenario getQualFilterScenario(string userId, int versionId)
        {
            QualFilterScenario result = new QualFilterScenario();
            PrfVersions prfVersions = new PrfVersions();
            MatVersions matVersions = new MatVersions();
            NonQualifiedMedias nonQualifieds = new NonQualifiedMedias();
            NonQualifiedMediasRaw nonQualifiedsRaw = new NonQualifiedMediasRaw();
            NonQualifiedMediaExceptions nonQualifiedMediaExceptions = new NonQualifiedMediaExceptions();
            ComparisonLotDispositions comparisions = new ComparisonLotDispositions();
            OdmWips odmWips = new OdmWips();
            LotShips lotShips = new LotShips();
            LotDispositionReasons reasons = new LotDispositionReasons();
            LotDispositionActions actions = new LotDispositionActions();

            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTERSCENARIO);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", versionId.NullToDBNull());
                dataAccess.SetTimeout(5 * 60);

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    reader.Read();
                    result.Version = newQualFilterScenarioVersion(reader);

                    reader.NextResult();
                    while (reader.Read())
                    {
                        prfVersions.Add(newPrfVersion(reader));
                    }

                    result.Prfs = prfVersions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        matVersions.Add(newMatVersion(reader));
                    }

                    result.Mats = matVersions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifieds.Add(newNonQualified(reader));
                    }

                    result.NonQualifieds = nonQualifieds;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisions.Add(newComparison(reader));
                    }

                    result.Comparisons = comparisions;

                    //reader.NextResult();
                    //while (reader.Read())
                    //{
                    //    odmWips.Add(newOdmWip(reader));
                    //}

                    //result.OdmWips = odmWips;

                    //reader.NextResult();
                    //while (reader.Read())
                    //{
                    //    lotShips.Add(newLotShip(reader));
                    //}

                    //result.LotShips = lotShips;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        reasons.Add(newLotDispositionReason(reader));
                    }

                    result.LotDispositionReasons = reasons;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedsRaw.Add(newNonQualifiedRaw(reader));
                    }

                    result.NonQualifiedsRaw = nonQualifiedsRaw;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedMediaExceptions.Add(newNonQualifiedException(reader));
                    }

                    result.NonQualifiedMediaExceptions = nonQualifiedMediaExceptions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        actions.Add(newLotDispositionAction(reader));
                    }

                    result.LotDispositionActions = actions;

                    reader.NextResult();
                    reader.Read();
                    result.QualFilterScenarioInfo = newQualFilterScenarioInfo(reader);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private QualFilterScenario getQualFilterHistoricalScenario(string userId, int versionId)
        {
            QualFilterScenario result = new QualFilterScenario();
            PrfVersions prfVersions = new PrfVersions();
            MatVersions matVersions = new MatVersions();
            NonQualifiedMedias nonQualifieds = new NonQualifiedMedias();
            NonQualifiedMediasRaw nonQualifiedsRaw = new NonQualifiedMediasRaw();
            NonQualifiedMediaExceptions nonQualifiedMediaExceptions = new NonQualifiedMediaExceptions();
            ComparisonLotDispositions comparisions = new ComparisonLotDispositions();
            LotDispositionReasons reasons = new LotDispositionReasons();
            LotDispositionActions actions = new LotDispositionActions();

            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTERHISTORICALSCENARIO);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", versionId.NullToDBNull());
                dataAccess.SetTimeout(5 * 60);

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    reader.Read();
                    result.Version = newQualFilterScenarioVersion(reader);

                    reader.NextResult();
                    while (reader.Read())
                    {
                        prfVersions.Add(newPrfVersion(reader));
                    }

                    result.Prfs = prfVersions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        matVersions.Add(newMatVersion(reader));
                    }

                    result.Mats = matVersions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifieds.Add(newNonQualified(reader));
                    }

                    result.NonQualifieds = nonQualifieds;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        comparisions.Add(newComparison(reader));
                    }

                    result.Comparisons = comparisions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        reasons.Add(newLotDispositionReason(reader));
                    }

                    result.LotDispositionReasons = reasons;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedsRaw.Add(newNonQualifiedRaw(reader));
                    }

                    result.NonQualifiedsRaw = nonQualifiedsRaw;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        nonQualifiedMediaExceptions.Add(newNonQualifiedException(reader));
                    }

                    result.NonQualifiedMediaExceptions = nonQualifiedMediaExceptions;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        actions.Add(newLotDispositionAction(reader));
                    }

                    result.LotDispositionActions = actions;
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }
        private QualFilterScenarioVersions getQualFilterScenarioVersions(string userId, int? id = null, int? prfVersion = null, int? matVersion = null, int? odmWipSnapshotVersion = null, int? lotShipSnapshotVersion = null, int? lotDispositionSnapshotVersion = null)
        {
            QualFilterScenarioVersions result = new QualFilterScenarioVersions();
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTERSCENARIOVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@PrfVersion", prfVersion.NullToDBNull());
                dataAccess.AddInputParameter("@MatVersion", matVersion.NullToDBNull());
                dataAccess.AddInputParameter("@OdmWipSnapshotVersion", odmWipSnapshotVersion.NullToDBNull());
                dataAccess.AddInputParameter("@LotShipSnapshotVersion", lotShipSnapshotVersion.NullToDBNull());
                dataAccess.AddInputParameter("@LotDispositionSnapshotVersion", lotDispositionSnapshotVersion.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newQualFilterScenarioVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private QualFilterScenarioVersions getQualFilterScenarioVersionsDaily(string userId, int? id = null, int? prfVersion = null, int? matVersion = null, int? odmWipSnapshotVersion = null, int? lotShipSnapshotVersion = null, int? lotDispositionSnapshotVersion = null)
        {
            QualFilterScenarioVersions result = new QualFilterScenarioVersions();
            ISqlDataAccess dataAccess = null;
            //id = 2;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTERSCENARIOVERSIONSDAILY);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@PrfVersion", prfVersion.NullToDBNull());
                dataAccess.AddInputParameter("@MatVersion", matVersion.NullToDBNull());
                dataAccess.AddInputParameter("@OdmWipSnapshotVersion", odmWipSnapshotVersion.NullToDBNull());
                dataAccess.AddInputParameter("@LotShipSnapshotVersion", lotShipSnapshotVersion.NullToDBNull());
                dataAccess.AddInputParameter("@LotDispositionSnapshotVersion", lotDispositionSnapshotVersion.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newQualFilterScenarioVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private QualFilterScenarioVersions getQualFilterScenarioHistoricalVersions(string userId, int? id = null, int? prfVersion = null, int? matVersion = null, int? odmWipSnapshotVersion = null, int? lotShipSnapshotVersion = null, int? lotDispositionSnapshotVersion = null)
        {
            QualFilterScenarioVersions result = new QualFilterScenarioVersions();
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTERSCENARIOHISTORICALVERSIONS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@PrfVersion", prfVersion.NullToDBNull());
                dataAccess.AddInputParameter("@MatVersion", matVersion.NullToDBNull());
                dataAccess.AddInputParameter("@OdmWipSnapshotVersion", odmWipSnapshotVersion.NullToDBNull());
                dataAccess.AddInputParameter("@LotShipSnapshotVersion", lotShipSnapshotVersion.NullToDBNull());
                dataAccess.AddInputParameter("@LotDispositionSnapshotVersion", lotDispositionSnapshotVersion.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newQualFilterScenarioVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }
        public RunScenarioResponse RunScenario(string userId)
        {
            RunScenarioResponse response = null;

            response = createQualFilterScenario(userId);
            if (response.IsNull())
            {
                response = new RunScenarioResponse();
            }
            response.Messages = new List<string>();
            if (response.LatestScenarioVersion.IsNull())
            {
                response.Messages.Add("Failed to create the scenario. Please retry and if the problem persists, contact support.");
            }
            else
            {
                response.Messages.Add("Scenario created successfully.");
            }
            return response;
        }

        public Result PublishScenario(string userId, int? versionId)
        {
            Result response = new Result();
            ISqlDataAccess dataAccess = null;
            IDataReader reader;

            try
            {
                //Commons.InitializeConfiguration();

                //Logger.Info($"Entering RunQualFilter as {userId}");
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_PUBLISHODMQUALFILTER);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@ScenarioId", versionId.NullToDBNull());
                dataAccess.SetTimeout(300);
                //Logger.Info("Executing Query : [qan].[GetODMQualFilter]");
                reader = dataAccess.ExecuteReader();
                //Logger.Info("Executed Query : [qan].[GetODMQualFilter]");

                NonQualifiedParts nonQualifiedParts = new NonQualifiedParts();
                NonQualifiedPart nonQualifiedPart = null;
                while (reader.Read())
                {
                    nonQualifiedPart = new NonQualifiedPart()
                    {
                        MMNum = reader["MMNum"].ToStringSafely(),
                        OdmName = reader["OdmName"].ToStringSafely(),
                        DesignId = reader["DesignId"].ToStringSafely(),
                        Media_IPN = reader["OsatIpn"].ToStringSafely(),
                        SLots = reader["Slots"].ToStringSafely(),
                        CreateDate = reader["CreatedOn"].ToStringSafely()
                    };
                    nonQualifiedParts.Add(nonQualifiedPart);
                }

                // QUALIFIED WITHIN NON QUALIFIED LIST
                dataAccess.DataReader.NextResult();
                ExemptParts exemptParts = new ExemptParts();
                ExemptPart exemptPart = null;
                while (reader.Read())
                {
                    exemptPart = new ExemptPart()
                    {
                        Design_Id = reader["Design_Id"].ToStringSafely(),
                        Device_Name = reader["Device_Name"].ToStringSafely(),
                        MediaIpn = reader["MediaIpn"].ToStringSafely(),
                        Media_Type = reader["Media_Type"].ToStringSafely(),
                        OdmName = reader["OdmName"].ToStringSafely(),
                        ScodeMm = reader["ScodeMm"].ToStringSafely(),
                        SLot = reader["SLot"].ToStringSafely(),
                        SSD_Id = reader["SSD_Id"].ToStringSafely()
                    };
                    exemptParts.Add(exemptPart);
                }
                // DISTINCT ODM NAMES
                dataAccess.DataReader.NextResult();
                List<string> odmNames = new List<string>();
                while (reader.Read())
                {
                    odmNames.Add(reader["OdmName"].ToStringSafely().Trim());
                }
                // For each ODM, write a CSV file
                var nonQualifiedPartsFile = String.Empty;
                var exemptPartsFile = String.Empty;
                var nonQualifiedPartsByOdm = new NonQualifiedParts();
                var exemptPartsByOdm = new ExemptParts();
                List<FileInfo> files;
                string utcTimeStamp = DateTime.UtcNow.ToString("yyyymmddhhmmss");
                // For every ODM
                foreach (var odmName in odmNames)
                {
                    // re-initialize the variables
                    nonQualifiedPartsByOdm = new NonQualifiedParts();
                    exemptPartsByOdm = new ExemptParts();
                    // Get the records by odm name
                    nonQualifiedPartsByOdm = nonQualifiedParts.GetByOdmName(odmName);
                    exemptPartsByOdm = exemptParts.GetByOdmName(odmName);
                    // Set the local file names for the ODM
                    string odmLocalPath = String.Format(Settings.ODMFilterOutputPathNand, odmName);
                    // If the directory does not exist, create it
                    if (!Directory.Exists(odmLocalPath))
                    {
                        Directory.CreateDirectory(odmLocalPath);
                    }
                    nonQualifiedPartsFile = Path.Combine(odmLocalPath + @"\ODM_Non-Qualified_Media_FilterReport_NPSG_" + odmName + "_" + utcTimeStamp + ".csv");
                    exemptPartsFile = Path.Combine(odmLocalPath + @"\ODM_Qualified_Media_FilterReport_NPSG_" + odmName + "_" + utcTimeStamp + ".csv");
                    // write the non qualified parts to file
                    using (var writer = new StreamWriter(nonQualifiedPartsFile))
                    {
                        //if (nonQualifiedPartsByOdm.Count > 0)
                        //{
                        using (var csv = new CsvWriter(writer, CultureInfo.InvariantCulture))
                        {
                            csv.WriteRecords(nonQualifiedPartsByOdm);
                        }
                        //}
                    }
                    // write the exempt parts from non qualified parts
                    using (var writer = new StreamWriter(exemptPartsFile))
                    {
                        //if (exemptPartsByOdm.Count > 0)
                        //{
                        using (var csv = new CsvWriter(writer, CultureInfo.InvariantCulture))
                        {
                            csv.WriteRecords(exemptPartsByOdm);
                        }
                        //}
                    }
                    FileInfo nonQualifiedPartsFileInfo = new FileInfo(nonQualifiedPartsFile);
                    FileInfo exemptPartsFileInfo = new FileInfo(exemptPartsFile);
                    // Send email per ODM
                    files = new List<FileInfo>()
                    {
                       nonQualifiedPartsFileInfo,
                       exemptPartsFileInfo
                    };

                    if (EmailHelper.Send(files, Settings.GetOdmEmailRecipients(odmName, "NAND"), "NAND", odmName))
                    {
                        //Logger.Info($"Sent emails for {odmName}");
                    }
                    // Post files to FTP for the ODM
                    //PostToFTPLocation();
                    string odmPath = String.Format(Settings.FTPLocation, "Nand", odmName);
                    if (!Directory.Exists(odmPath))
                    {
                        Directory.CreateDirectory(odmPath);
                    }
                    string nonQualifiedPartsDestFile = Path.Combine(odmPath + "\\" + Path.GetFileName(nonQualifiedPartsFileInfo.Name));
                    string exemptPartsDestFile = Path.Combine(odmPath + "\\" + Path.GetFileName(exemptPartsFileInfo.Name));
                    nonQualifiedPartsFileInfo.CopyTo(nonQualifiedPartsDestFile, true);
                    exemptPartsFileInfo.CopyTo(exemptPartsDestFile, true);

                }

                response.Messages = new List<string>();
                response.Messages.Add("Query executed successfully");
            }
            catch (Exception ex)
            {
                //Logger.Debug(ex.InnerException);
                response.Messages = new List<string>();
                response.Messages.Add(ex.Message.ToString());
                throw ex;
            }
            finally
            {
                if (dataAccess.IsNotNull())
                {
                    dataAccess.Close();
                }
            }
            return response;
        }

        public void ProcessRemovableSLots(string userId)
        {
            base.ProcessRemovableSLots(userId, NpsgStoredProcedures.SP_TASKPROCESSNPSGREMOVABLESLOTS, Settings.OdmSLotNPSGPickupLocation, "NPSG");
        }

        public QualFilterRemovableSLots GetRemovableSLotDetails(string userId, int version, string odmName)
        {
            return base.GetRemovableSLotDetails(userId, version, odmName, NpsgStoredProcedures.SP_GETNPSGREMOVABLESLOTSDETAILS);
        }

        public string GetProhibitedTimeRanges(string userId)
        {
            return base.GetProhibitedTimeRanges(userId, "NAND");
        }

        public CheckProhibitedScenarioRunTimeResponse CheckProhibitedScenarioRunTime(string userId)
        {
            return base.CheckProhibitedScenarioRunTime(userId, "NAND");
        }

        public Result ClearArchiveOdmManualDisposition(string userId)
        {
            return base.ClearArchiveOdmManualDisposition(userId, NpsgStoredProcedures.SP_CLEARARCHIVEODMMANUALDISPOSITIONS);
        }

        public OdmWips GetOdmLotWipDetails(string sLot, string mediaIPN, string sCode, string odmName, string userId)
        {
            OdmWips result = null;
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMLOTWIPDETAILS);
                dataAccess.AddInputParameter("@SLot", sLot.NullToDBNull());
                dataAccess.AddInputParameter("@MediaIPN", mediaIPN.NullToDBNull());
                dataAccess.AddInputParameter("@SCode", sCode.NullToDBNull());
                dataAccess.AddInputParameter("@OdmName", odmName.NullToDBNull());
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    result = new OdmWips();
                    while (reader.Read())
                    {
                        result.Add(new OdmWip()
                        {
                            MediaLotId = reader["SLot"].ToStringSafely(),
                            SubConName = reader["OdmName"].ToStringSafely(),
                            IntelPartNumber = reader["MediaIPN"].ToStringSafely(),
                            LocationType = reader["LocationType"].ToStringSafely(),
                            InventoryLocation = reader["Location"].ToStringSafely(),
                            Category = reader["Category"].ToStringSafely(),
                            MmNumber = reader["MMNumber"].ToStringSafely(),
                            TimeEntered = reader["TimeEntered"].ToDateTimeSafely()
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public Dispositions GetAll(string userId, bool? isActive = null)
        {
            return getAll(userId, isActive: isActive);
        }
        #endregion

        #region Explanability

        public ExplainabilityReport GetExplainabilityReport(string userId)
        {
            ExplainabilityReport result = new ExplainabilityReport();
            Slots badSlots = new Slots();
            Explanations explanations = new Explanations();
            ISqlDataAccess dataAccess = null;

            try
            {

                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTEREXPLANATIONS);
                dataAccess.AddInputParameter("@UserId", userId);
                //Increase the timeout so the query can finish and avoid throwing an exception
                dataAccess.SetTimeout(120);

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        badSlots.Add(newSlot(reader));
                    }
                    result.BadSlots = badSlots;

                    reader.NextResult();
                    while (reader.Read())
                    {
                        explanations.Add(newExplanation(reader));
                    }
                    result.Explanations = explanations;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private Explanation newExplanation(IDataRecord record)
        {
            return new Explanation()
            {
                SubConName = record["SubConName"].ToStringSafely(),
                SSD_Id = record["SSD_Id"].ToStringSafely(),
                InventoryLocation = record["InventoryLocation"].ToStringSafely(),
                MMNumber = record["MMNumber"].ToStringSafely(),
                LocationType = record["LocationType"].ToStringSafely(),
                Category = record["Category"].ToStringSafely(),
                SLot = record["SLot"].ToStringSafely(),
                SCode = record["SCode"].ToStringSafely(),
                MediaIPN = record["MediaIPN"].ToStringSafely(),
                PorMajorProbeProgramRevision = record["PorMajorProbeProgramRevision"].ToStringSafely(),
                ActualMajorProbeProgramRevision = record["ActualMajorProbeProgramRevision"].ToStringSafely(),
                PorBurnTapeRevision = record["PorBurnTapeRevision"].ToStringSafely(),
                ActualBurnTapeRevision = record["ActualBurnTapeRevision"].ToStringSafely(),
                PorCellRevision = record["PorCellRevision"].ToStringSafely(),
                ActualCellRevision = record["ActualCellRevision"].ToStringSafely(),
                PorCustomTestingRequired = record["PorCustomTestingRequired"].ToStringSafely(),
                ActualCustomTestingRequired = record["ActualCustomTestingRequired"].ToStringSafely(),
                PorFabConvId = record["PorFabConvId"].ToStringSafely(),
                ActualFabConvId = record["ActualFabConvId"].ToStringSafely(),
                PorFabExcrId = record["PorFabExcrId"].ToStringSafely(),
                ActualFabExcrId = record["ActualFabExcrId"].ToStringSafely(),
                PorProductGrade = record["PorProductGrade"].ToStringSafely(),
                ActualProductGrade = record["ActualProductGrade"].ToStringSafely(),
                PorReticleWaveId = record["PorReticleWaveId"].ToStringSafely(),
                ActualReticleWaveId = record["ActualReticleWaveId"].ToStringSafely(),
                PorFabFacility = record["PorFabFacility"].ToStringSafely(),
                ActualFabFacility = record["ActualFabFacility"].ToStringSafely(),
                PorProbeRev = record["PORProbeRev"].ToStringSafely(),
                ActualProbeRev = record["ACTProbeRev"].ToStringSafely()
            };
        }

        private Slot newSlot(IDataRecord record)
        {
            return new Slot()
            {
                Name = record["BadSLots"].ToStringSafely()
            };
        }

        #endregion


        private RunScenarioResponse createQualFilterScenario(string userId)
        {
            ISqlDataAccess dataAccess = null;
            RunScenarioResponse response = null;

            try
            {
                response = new RunScenarioResponse();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_RUNODMQUALFILTERSCENARIO);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.SetTimeout(300);

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    // Read the latest scenario version details
                    reader.Read();
                    response.LatestScenarioVersion = newQualFilterScenarioVersion(reader);
                    // Read all versions that needs to be populated in the drop down list
                    response.ScenarioVersions = new QualFilterScenarioVersions();
                    reader.NextResult();
                    while (reader.Read())
                    {
                        response.ScenarioVersions.Add(newQualFilterScenarioVersion(reader));
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }

            return response;
        }
        private QualFilterScenarioVersion newQualFilterScenarioVersion(IDataRecord record)
        {
            return new QualFilterScenarioVersion()
            {
                Id = record["Id"].ToIntegerSafely(),
                PrfVersion = record["PrfVersion"].ToIntegerSafely(),
                MatVersion = record["MatVersion"].ToIntegerSafely(),
                OdmWipSnapshotVersion = record["OdmWipSnapshotVersion"].ToIntegerSafely(),
                LotShipSnapshotVersion = record["LotShipSnapshotVersion"].ToIntegerSafely(),
                LotDispositionSnapshotVersion = record["LotDispositionSnapshotVersion"].ToIntegerSafely(),
                DailyId = record["DailyId"].ToIntegerSafely(),
                StatusId = record["StatusId"].ToIntegerSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
            };
        }

        private QualFilterScenarioInfo newQualFilterScenarioInfo(IDataRecord record)
        {
            return new QualFilterScenarioInfo()
            {
                LotShipVersion = record["LotShipVersion"].ToIntegerSafely(),
                LotShipLoadTime = record["LotshipLoadTime"].ToNullableDateTimeSafely(),
                WipVersion = record["WipVersion"].ToIntegerSafely(),
                WipLoadTime = record["WipLoadTime"].ToNullableDateTimeSafely(),
                PrfVersion = record["PrfVersion"].ToIntegerSafely(),
                PrfImportTime = record["PrfImportTime"].ToNullableDateTimeSafely(),
                MatVersion = record["MatVersion"].ToIntegerSafely(),
                MatImportTime = record["MatImportTime"].ToNullableDateTimeSafely()
            };
        }

        private ImportVersion newVersion(IDataRecord record)
        {
            return new ImportVersion()
            {
                Id = record["Id"].ToIntegerSafely(),
                Version = record["VersionNumber"].ToIntegerSafely(),
                WorkWeek = record["WW"].ToStringSafely(),
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }
        private MatVersion newMatVersion(IDataRecord record)
        {
            return new MatVersion()
            {
                VersionId = record["VersionId"].ToIntegerSafely(),
                WorkWeek = record["WW"].ToStringSafely(),
                SSDId = record["SSD_Id"].ToStringSafely(),
                DesignId = record["Design_Id"].ToStringSafely(),
                Scode = record["Scode"].ToStringSafely(),
                CellRevision = record["Cell_Revision"].ToStringSafely(),
                MPPR = record["Major_Probe_Program_Revision"].ToStringSafely(),
                ProbeRevision = record["Probe_Revision"].ToStringSafely(),
                BurnTapeRevision = record["Burn_Tape_Revision"].ToStringSafely(),
                CustomTestingRequired = record["Custom_Testing_Required"].ToStringSafely(),
                CustomTestingRequired2 = record["Custom_Testing_Required2"].ToStringSafely(),
                ProductGrade = record["Product_Grade"].ToStringSafely(),
                PrbConvId = record["Prb_Conv_Id"].ToStringSafely(),
                FabConvId = record["Fab_Conv_Id"].ToStringSafely(),
                FabExcrId = record["Fab_Excr_Id"].ToStringSafely(),
                MediaType = record["Media_Type"].ToStringSafely(),
                MediaIPN = record["Media_IPN"].ToStringSafely(),
                DeviceName = record["Device_Name"].ToStringSafely(),
                ReticleWaveId = record["Reticle_Wave_Id"].ToStringSafely(),
                FabFacility = record["Fab_Facility"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                Latest = record["Latest"].ToStringSafely().ToBooleanSafely(),
                FileType = record["FileType"].ToStringSafely(),
            };
        }
        private PrfVersion newPrfVersion(IDataRecord record)
        {
            return new PrfVersion()
            {
                VersionId = record["VersionId"].ToIntegerSafely(),
                ODMDescription = record["Odm_Desc"].ToStringSafely(),
                SSDFamilyName = record["SSD_Family_Name"].ToStringSafely(),
                SSDName = record["SSD_Name"].ToStringSafely(),
                MMNumber = record["MM_Number"].ToStringSafely(),
                ProductCode = record["Product_Code"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
            };
        }
        private NonQualifiedMedia newNonQualified(IDataRecord record)
        {
            return new NonQualifiedMedia()
            {
                ScenarioId = record["ScenarioId"].ToIntegerSafely(),
                MMNum = record["MMNum"].ToStringSafely(),
                OdmName = record["OdmName"].ToStringSafely(),
                DesignId = record["DesignId"].ToStringSafely(),
                //Reformat SLots so multiple values can wrap in the grid cell
                SLots = record["SLots"].ToStringSafely().Replace(';', ' ').Trim(),
                MatId = record["MatId"].ToIntegerSafely(),
                PrfId = record["PrfId"].ToIntegerSafely(),
                OsatIpn = record["OsatIpn"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }
        private NonQualifiedMediaRaw newNonQualifiedRaw(IDataRecord record)
        {
            return new NonQualifiedMediaRaw()
            {
                Id = record["Id"].ToIntegerSafely(),
                ScenarioId = record["ScenarioId"].ToIntegerSafely(),
                OdmName = record["OdmName"].ToStringSafely(),
                MMNum = record["MMNum"].ToStringSafely(),
                OsatIpn = record["OsatIpn"].ToStringSafely(),
                SLot = record["SLot"].ToStringSafely(),
                CategoryId = record["CategoryId"].ToIntegerSafely(),
                CategoryName = record["CategoryName"].ToStringSafely(),
            };
        }
        private NonQualifiedMediaException newNonQualifiedException(IDataRecord record)
        {
            return new NonQualifiedMediaException()
            {
                ScenarioId = record["ScenarioId"].ToIntegerSafely(),
                OdmId = record["OdmId"].ToIntegerSafely(),
                OdmName = record["OdmName"].ToStringSafely(),
                SCode = record["ScodeMm"].ToStringSafely(),
                MediaIpn = record["MediaIpn"].ToStringSafely(),
                SLot = record["SLot"].ToStringSafely(),
                SSD_Id = record["SSD_Id"].ToStringSafely(),
                DesignId = record["Design_Id"].ToStringSafely(),
                DeviceName = record["Device_Name"].ToStringSafely(),
                MediaType = record["Media_Type"].ToStringSafely(),
            };
        }
        private ComparisonLotDisposition newComparison(IDataRecord record)
        {
            return new ComparisonLotDisposition()
            {
                Id = record["Id"].ToIntegerSafely(),
                SubConName = record["SubConName"].ToStringSafely(),
                SsdId = record["SSD_Id"].ToStringSafely(),
                InventoryLocation = record["InventoryLocation"].ToStringSafely(),
                MMNumber = record["MMNumber"].ToStringSafely(),
                LocationType = record["LocationType"].ToStringSafely(),
                Category = record["Category"].ToStringSafely(),
                SLot = record["SLot"].ToStringSafely(),
                DesignId = record["DesignId"].ToStringSafely(),
                SCode = record["SCode"].ToStringSafely(),
                MediaIPN = record["MediaIPN"].ToStringSafely(),
                PorMajorProbeProgramRevision = record["PorMajorProbeProgramRevision"].ToStringSafely(),
                ActualMajorProbeProgramRevision = record["ActualMajorProbeProgramRevision"].ToStringSafely(),
                PorBurnTapeRevision = record["PorBurnTapeRevision"].ToStringSafely(),
                ActualBurnTapeRevision = record["ActualBurnTapeRevision"].ToStringSafely(),
                PorCellRevision = record["PorCellRevision"].ToStringSafely(),
                ActualCellRevision = record["ActualCellRevision"].ToStringSafely(),
                PorCustomTestingRequired = record["PorCustomTestingRequired"].ToStringSafely(),
                ActualCustomTestingRequired = record["ActualCustomTestingRequired"].ToStringSafely(),
                PorFabConvId = record["PorFabConvId"].ToStringSafely(),
                ActualFabConvId = record["ActualFabConvId"].ToStringSafely(),
                PorFabExcrId = record["PorFabExcrId"].ToStringSafely(),
                ActualFabExcrId = record["ActualFabExcrId"].ToStringSafely(),
                PorProductGrade = record["PorProductGrade"].ToStringSafely(),
                ActualProductGrade = record["ActualProductGrade"].ToStringSafely(),
                PorReticleWaveId = record["PorReticleWaveId"].ToStringSafely(),
                ActualReticleWaveId = record["ActualReticleWaveId"].ToStringSafely(),
                PorFabFacility = record["PorFabFacility"].ToStringSafely(),
                ActualFabFacility = record["ActualFabFacility"].ToStringSafely(),
                PorProbeRev = record["PorProbeRev"].ToStringSafely(),
                ActualProbeRev = record["ActualProbeRev"].ToStringSafely(),
                LotDispositionReasonId = record["LotDispositionReasonId"].ToNullableIntSafely(),
                LotDispositionReason = record["LotDispositionReason"].ToStringSafely(),
                Notes = record["Notes"].ToStringSafely(),
                LotDispositionActionId = record["LotDispositionActionId"].ToNullableIntSafely(),
                LotDispositionActionName = record["LotDispositionActionName"].ToStringSafely(),
                LotDispositionDisplayText = record["LotDispositionDisplayText"].ToStringSafely(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToNullableDateTimeSafely()
            };
        }
        private OdmWip newOdmWip(IDataRecord record)
        {
            return new OdmWip()
            {
                Version = record["Version"].ToIntegerSafely(),
                MediaLotId = record["media_lot_id"].ToStringSafely(),
                SubConName = record["subcon_name"].ToStringSafely(),
                IntelPartNumber = record["intel_part_number"].ToStringSafely(),
                LocationType = record["location_type"].ToStringSafely(),
                InventoryLocation = record["inventory_location"].ToStringSafely(),
                Category = record["category"].ToStringSafely(),
                MmNumber = record["mm_number"].ToStringSafely(),
                TimeEntered = record["time_entered"].ToDateTimeSafely(),
            };
        }
        private LotShip newLotShip(IDataRecord record)
        {
            return new LotShip()
            {
                Version = record["Version"].ToIntegerSafely(),
                Id = record["id"].ToStringSafely(),
                LocationType = record["location_type"].ToStringSafely(),
                WayBill = record["way_bill"].ToStringSafely(),
                MmNumber = record["mm_number"].ToStringSafely(),
                Description = record["description"].ToStringSafely(),
                ToFacility = record["to_facility"].ToStringSafely(),
                Invoice = record["invoice"].ToStringSafely(),
                DeliveryNote = record["delivery_note"].ToStringSafely(),
                IntelBox = record["intel_box"].ToStringSafely(),
                UnitQty = record["unit_qty"].ToIntegerSafely(),
                Po = record["po"].ToStringSafely(),
                IntelUpi = record["intel_upi"].ToStringSafely(),
                DesignId = record["design_id"].ToStringSafely(),
                Device = record["device"].ToStringSafely(),
                NumberOfDieInPkg = record["number_of_die_in_pkg"].ToIntegerSafely(),
                ProbeProgramRev = record["probe_program_rev"].ToStringSafely(),
                MajorProbeProgramRev = record["major_probe_prog_rev"].ToStringSafely(),
                FabricationFacility = record["fabrication_facility"].ToStringSafely(),
                AppRestriction = record["app_restriction"].ToStringSafely(),
                ApoNumber = record["apo_number"].ToStringSafely(),
                DieQty = record["die_qty"].ToIntegerSafely(),
                CustomTested = record["custom_tested"].ToStringSafely(),
                IntelReclaim = record["intel_reclaim"].ToStringSafely(),
                AlternateSpeedSort = record["alternate_speed_sort"].ToStringSafely(),
                AteTapeRevision = record["ate_tape_revision"].ToStringSafely(),
                BurnExperiment = record["burn_experiment"].ToStringSafely(),
                BurnFlow = record["burn_flow"].ToStringSafely(),
                BurnTapeRevision = record["burn_tape_revision"].ToStringSafely(),
                WaferQty = record["wafer_qty"].ToIntegerSafely(),
                CustomTestingReqd = record["custom_testing_reqd"].ToStringSafely(),
                DdpIneligible = record["ddp_ineligible"].ToStringSafely(),
                DisallowMerging = record["disallow_merging"].ToStringSafely(),
                EngMasterVersion = record["eng_master_version"].ToStringSafely(),
                FabExcrId = record["fab_excr_id"].ToStringSafely(),
                FutureHoldLocation = record["future_hold_location"].ToStringSafely(),
                HdpIneligible = record["hdp_ineligible"].ToStringSafely(),
                HoldForWhom = record["hold_for_whom"].ToStringSafely(),
                HoldLot = record["hold_lot"].ToStringSafely(),
                HoldNotes = record["hold_notes"].ToStringSafely(),
                HoldReason = record["hold_reason"].ToStringSafely(),
                HotLotPriority = record["hot_lot_priority"].ToStringSafely(),
                IntelShipPass1Qty = record["intel_ship_pass1_qty"].ToIntegerSafely(),
                IntelShipPass2Qty = record["intel_ship_pass2_qty"].ToIntegerSafely(),
                IntelShipPass3Qty = record["intel_ship_pass3_qty"].ToIntegerSafely(),
                IntelShipPass4Qty = record["intel_ship_pass4_qty"].ToIntegerSafely(),
                InventoryLocation = record["inventory_location"].ToStringSafely(),
                LotHasBeenMarked = record["lot_has_been_marked"].ToStringSafely(),
                LotHasRejects = record["lot_has_rejects"].ToStringSafely(),
                LotId = record["lot_id"].ToStringSafely(),
                MarketingSpeed = record["marketing_speed"].ToStringSafely(),
                NonShippable = record["non_shippable"].ToStringSafely(),
                NumArrayDecks = record["num_array_decks"].ToIntegerSafely(),
                OdpIneligible = record["odp_ineligible"].ToStringSafely(),
                PlannedLaserScribe = record["planned_laser_scribe"].ToStringSafely(),
                PlannedTestSite = record["planned_test_site"].ToStringSafely(),
                ProductGradeSorted = record["product_grade_sorted"].ToStringSafely(),
                ProdGradeSortReqd = record["prod_grade_sort_reqd"].ToStringSafely(),
                ProductGrade = record["product_grade"].ToStringSafely(),
                QaAsmConvHold = record["qa_asm_conv_hold"].ToStringSafely(),
                QaAsmExcrHold = record["qa_asm_excr_hold"].ToStringSafely(),
                QaAsmSwrHold = record["qa_asm_swr_hold"].ToStringSafely(),
                QaDispositionHold = record["qa_disposition_hold"].ToStringSafely(),
                QaFabConvHold = record["qa_fab_conv_hold"].ToStringSafely(),
                QaFabExcrHold = record["qa_fab_excr_hold"].ToStringSafely(),
                QaFabSwrHold = record["qa_fab_swr_hold"].ToStringSafely(),
                QaPrbConvHold = record["qa_prb_conv_hold"].ToStringSafely(),
                QaPrbExcrHold = record["qa_prb_excr_hold"].ToStringSafely(),
                QaReticleWaveHold = record["qa_reticle_wave_hold"].ToStringSafely(),
                QaWorkRequestDesc = record["qa_work_request_desc"].ToStringSafely(),
                QdpIneligible = record["qdp_ineligible"].ToStringSafely(),
                TestDataReqd = record["test_data_reqd"].ToStringSafely(),
                PrbConvId = record["prb_conv_id"].ToStringSafely(),
                NumIoChannels = record["num_io_channels"].ToIntegerSafely(),
                ReticleWaveId = record["reticle_wave_id"].ToStringSafely(),
                CellRevision = record["cell_revision"].ToStringSafely(),
                CmosRevision = record["cmos_revision"].ToStringSafely(),
                ColdFinalReqd = record["cold_final_reqd"].ToStringSafely(),
                ExcrContainment = record["excr_containment"].ToStringSafely(),
                LeadCount = record["lead_count"].ToStringSafely(),
                NumFlashCePins = record["num_flash_ce_pins"].ToStringSafely(),
                CountryOfAssembly = record["country_of_assembly"].ToStringSafely(),
                LastUpdatedDateTime = record["last_updated_datetime"].ToDateTimeSafely(),
                LastTrackedSource = record["last_tracked_source"].ToStringSafely(),
                LoadFileDateTime = record["load_file_datetime"].ToDateTimeSafely(),
                CurrentLocation = record["current_location"].ToStringSafely(),
                ShippmentDate = record["shipment_date"].ToDateTimeSafely(),
                ShippingLabelLot = record["shipping_label_lot"].ToStringSafely(),
                FabConvId = record["fab_conv_id"].ToStringSafely(),
                Unqualified = record["unqualified"].ToStringSafely(),
                ElecSpecialTest = record["elec_special_test"].ToStringSafely(),
                RmaLot = record["rma_lot"].ToStringSafely(),
                CibrLotNumber = record["cibr_lot_number"].ToStringSafely(),
                IntelShipPass5Qty = record["intel_ship_pass5_qty"].ToIntegerSafely(),
                IntelShipPass6Qty = record["intel_ship_pass6_qty"].ToIntegerSafely(),
            };

        }
        private LotDispositionAction newLotDispositionAction(IDataRecord record)
        {
            return new LotDispositionAction()
            {
                Id = record["Id"].ToIntegerSafely(),
                ActionName = record["ActionName"].ToStringSafely(),
                DisplayText = record["DisplayText"].ToStringSafely()
            };
        }
        private LotDispositionReason newLotDispositionReason(IDataRecord record)
        {
            return new LotDispositionReason()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Description"].ToStringSafely()
            };
        }
        private Dispositions getAll(string userId, int? id = null, bool? isActive = null, bool? isPOR = null)
        {
            Dispositions result = new Dispositions();
            ISqlDataAccess dataAccess = null;
            try
            {
                //dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, NpsgStoredProcedures.SP_GETDISPOSITIONS);
                //dataAccess.AddInputParameter("@UserId", userId);
                //dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                //dataAccess.AddInputParameter("@IsActive", isActive.NullToDBNull());
                //dataAccess.AddInputParameter("@IsPOR", isPOR.NullToDBNull());
                //using(IDataReader reader = dataAccess.ExecuteReader())
                //{
                //    while(reader.Read())
                //    {
                //        result.Add(newDisposition(reader));
                //    }
                //}
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }

            return result;
        }


        #region Code Graveyard

        //public Result RunQualFilter(string userId)
        //{
        //    Result response = new Result();

        //    response.Messages = new List<string>();
        //    response.Messages.Add("Query executed successfully");

        //    return response;
        //}

        //public GenerateFilesResponse RunQualFilter(string userId)
        //{
        //    GenerateFilesResponse response = new GenerateFilesResponse();
        //    ISqlDataAccess dataAccess = null;
        //    IDataReader reader;

        //    try
        //    {
        //        //Commons.InitializeConfiguration();

        //        //Logger.Info($"Entering RunQualFilter as {userId}");
        //        dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, NpsgStoredProcedures.SP_GETODMQUALFILTER);
        //        dataAccess.AddInputParameter("@UserId", userId);
        //        dataAccess.SetTimeout(5 * 60);
        //        //Logger.Info("Executing Query : [qan].[GetODMQualFilter]");
        //        reader = dataAccess.ExecuteReader();
        //        //Logger.Info("Executed Query : [qan].[GetODMQualFilter]");

        //        var nonQualifiedParts = new NonQualifiedParts();
        //        NonQualifiedPart nonQualifiedPart = null;
        //        while (reader.Read())
        //        {
        //            nonQualifiedPart = new NonQualifiedPart()
        //            {
        //                MMNum = reader["MMNum"].ToStringSafely(),
        //                OdmName = reader["OdmName"].ToStringSafely(),
        //                DesignId = reader["DesignId"].ToStringSafely(),
        //                Media_IPN = reader["OsatIpn"].ToStringSafely(),
        //                SLots = reader["Slots"].ToStringSafely(),
        //                CreateDate = reader["CreateDate"].ToStringSafely()
        //            };
        //            nonQualifiedParts.Add(nonQualifiedPart);
        //        }

        //        // QUALIFIED WITHIN NON QUALIFIED LIST
        //        dataAccess.DataReader.NextResult();
        //        var exemptParts = new ExemptParts();
        //        ExemptPart exemptPart = null;
        //        while (reader.Read())
        //        {
        //            exemptPart = new ExemptPart()
        //            {
        //                Design_Id = reader["Design_Id"].ToStringSafely(),
        //                Device_Name = reader["Device_Name"].ToStringSafely(),
        //                MediaIpn = reader["MediaIpn"].ToStringSafely(),
        //                Media_Type = reader["Media_Type"].ToStringSafely(),
        //                OdmName = reader["OdmName"].ToStringSafely(),
        //                ScodeMm = reader["ScodeMm"].ToStringSafely(),
        //                SLot = reader["SLot"].ToStringSafely(),
        //                SSD_Id = reader["ScodeMm"].ToStringSafely()
        //            };
        //            exemptParts.Add(exemptPart);
        //        }
        //        // DISTINCT ODM NAMES
        //        dataAccess.DataReader.NextResult();
        //        List<string> odmNames = new List<string>();
        //        while (reader.Read())
        //        {
        //            odmNames.Add(reader["OdmName"].ToStringSafely().Trim());
        //        }
        //        // For each ODM, write a CSV file
        //        var nonQualifiedPartsFile = String.Empty;
        //        var exemptPartsFile = String.Empty;
        //        var nonQualifiedPartsByOdm = new NonQualifiedParts();
        //        var exemptPartsByOdm = new ExemptParts();
        //        List<FileInfo> files;
        //        string utcTimeStamp = DateTime.UtcNow.ToString("yyyymmddhhmmss");
        //        // For every ODM
        //        foreach (var odmName in odmNames)
        //        {
        //            // re-initialize the variables
        //            nonQualifiedPartsByOdm = new NonQualifiedParts();
        //            exemptPartsByOdm = new ExemptParts();
        //            // Get the records by odm name
        //            nonQualifiedPartsByOdm = nonQualifiedParts.GetByOdmName(odmName);
        //            exemptPartsByOdm = exemptParts.GetByOdmName(odmName);
        //            // Set the local file names for the ODM
        //            string odmLocalPath = String.Format(Settings.ODMFilterOutputPath, odmName);
        //            // If the directory does not exist, create it
        //            if (!Directory.Exists(odmLocalPath))
        //            {
        //                Directory.CreateDirectory(odmLocalPath);
        //            }
        //            nonQualifiedPartsFile = Path.Combine(odmLocalPath + @"\ODM_Non-Qualified_Media_FilterReport_" + odmName + "_" + utcTimeStamp + ".csv");
        //            exemptPartsFile = Path.Combine(odmLocalPath + @"\ODM_Qualified_Media_FilterReport_" + odmName + "_" + utcTimeStamp + ".csv");
        //            // write the non qualified parts to file
        //            using (var writer = new StreamWriter(nonQualifiedPartsFile))
        //            {
        //                if (nonQualifiedPartsByOdm.Count > 0)
        //                {
        //                    //using (var csv = new CsvWriter(writer, CultureInfo.InvariantCulture))
        //                    //{
        //                    //    csv.WriteRecords(nonQualifiedPartsByOdm);
        //                    //}
        //                }
        //            }
        //            // write the exempt parts from non qualified parts
        //            using (var writer = new StreamWriter(exemptPartsFile))
        //            {
        //                if (exemptPartsByOdm.Count > 0)
        //                {
        //                    //using (var csv = new CsvWriter(writer, CultureInfo.InvariantCulture))
        //                    //{
        //                    //    csv.WriteRecords(exemptPartsByOdm);
        //                    //}
        //                }
        //            }
        //            FileInfo nonQualifiedPartsFileInfo = new FileInfo(nonQualifiedPartsFile);
        //            FileInfo exemptPartsFileInfo = new FileInfo(exemptPartsFile);
        //            // Send email per ODM
        //            files = new List<FileInfo>()
        //            {
        //               nonQualifiedPartsFileInfo,
        //               exemptPartsFileInfo
        //            };

        //            if (EmailHelper.Send(files))
        //            {
        //                //Logger.Info($"Sent emails for {odmName}");
        //            }
        //            // Post files to FTP for the ODM
        //            //PostToFTPLocation();
        //            string odmPath = String.Format(Settings.FTPLocation, odmName);
        //            if (!Directory.Exists(odmPath))
        //            {
        //                Directory.CreateDirectory(odmPath);
        //            }
        //            string nonQualifiedPartsDestFile = Path.Combine(odmPath + "\\" + Path.GetFileName(nonQualifiedPartsFileInfo.Name));
        //            string exemptPartsDestFile = Path.Combine(odmPath + "\\" + Path.GetFileName(exemptPartsFileInfo.Name));
        //            nonQualifiedPartsFileInfo.CopyTo(nonQualifiedPartsDestFile, true);
        //            exemptPartsFileInfo.CopyTo(exemptPartsDestFile, true);

        //        }

        //        response.successResponse = new List<string>();
        //        response.successResponse.Add("Query executed successfully.");
        //    }
        //    catch (Exception ex)
        //    {
        //        //Logger.Debug(ex.InnerException);
        //        response.errorResponse = new List<string>();
        //        response.errorResponse.Add(ex.Message.ToString());
        //        throw ex;
        //    }
        //    finally
        //    {
        //        if (dataAccess.IsNotNull())
        //        {
        //            dataAccess.Close();
        //        }
        //    }
        //    return response;
        //}

        #endregion

    }

}
