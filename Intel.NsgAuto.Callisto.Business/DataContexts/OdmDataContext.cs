using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.ComponentModel;
using System.Reflection;
using System.IO;
using System.Linq;
using CsvHelper;
using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;
using Intel.NsgAuto.Callisto.Business.Logging;
using Intel.NsgAuto.Callisto.Business.Entities.ODM.Handlers;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Excel;
using Intel.NsgAuto.Shared.Extensions;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class OdmDataContext : IOdmDataContext
    {
        private static readonly string[] ODMs = { "PTI", "PEGATRON" };

        public void ProcessRemovableSLots(string userId, string procName, string pickupLocation, string logPrefix)
        {
            logPrefix += " - ";
            Log.Info(logPrefix + "Start processing Removable SLots for today: " + DateTime.Now + "...");

            List<string> allProcessedSLotFiles = new List<string>();
            RemovableSLots sLots = new RemovableSLots();
            foreach (string odm in ODMs)
            {
                string odmFolder = String.Format(pickupLocation, odm);
                if (!Directory.Exists(odmFolder))
                {
                    throw new DirectoryNotFoundException("RemovaleSLots pickup folder: " + odmFolder + " does not exist.");
                }

                string[] slotFiles = Directory.GetFiles(odmFolder, "*.csv");
                allProcessedSLotFiles.AddRange(slotFiles);

                foreach (string slotFilePath in slotFiles)
                {
                    Log.Info(logPrefix + "Processing file: " + slotFilePath + "...");

                    using (TextReader reader = File.OpenText(slotFilePath))
                    {
                        CsvHelper.Configuration.CsvConfiguration conf = new CsvHelper.Configuration.CsvConfiguration(System.Globalization.CultureInfo.CurrentCulture)
                        {
                            HasHeaderRecord = false,
                            MissingFieldFound = null
                        };

                        using (CsvReader csvFile = new CsvReader(reader, conf))
                        {
                            csvFile.Read();
                            var records = csvFile.GetRecords<RemovableSLot>().ToList();

                            foreach (var rec in records)
                            {
                                rec.OdmName = odm;
                                rec.SourceFileName = Path.GetFileName(slotFilePath);
                            }

                            sLots.AddRange((List<RemovableSLot>)records);
                        }
                    }
                }
            }

            string processedFileFolder, processedFileName, archiveFolder, archiveFilePath;
            if (sLots.Count == 0)
            {
                // Simply move empty files to Archive folder 
                foreach (string slotFile in allProcessedSLotFiles)
                {
                    processedFileFolder = Path.GetDirectoryName(slotFile);
                    processedFileName = Path.GetFileName(slotFile);
                    archiveFolder = Path.Combine(processedFileFolder, "Archive");

                    if (!Directory.Exists(archiveFolder))
                    {
                        Directory.CreateDirectory(archiveFolder);
                    }

                    archiveFilePath = Path.Combine(archiveFolder, processedFileName);
                    File.Move(slotFile, archiveFilePath);
                }

                if (allProcessedSLotFiles.Count > 0)
                {
                    Log.Info(logPrefix + "Empty ODM file(s) uploaded today.");
                }
                else
                {
                    Log.Info(logPrefix + "No RemovaleSLots file uploaded today.");
                }

                return;
            }

            // Call db proc to process the RemovableSLots
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, procName);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                DataTable slotsTb = ConvertToDataTable(sLots);
                dataAccess.AddTableValueParameter("@removableSLots", UserDefinedTypes.IODMREMOVABLESLOTS, slotsTb);
                if (dataAccess.Execute())
                {
                    Log.Info(logPrefix + "Successfully processed " + sLots.Count + " Removable SLots for today " + DateTime.Now);

                    // Archive processed files
                    foreach (string slotFile in allProcessedSLotFiles)
                    {
                        processedFileFolder = Path.GetDirectoryName(slotFile);
                        processedFileName = Path.GetFileName(slotFile);
                        archiveFolder = Path.Combine(processedFileFolder, "Archive");

                        if (!Directory.Exists(archiveFolder))
                        {
                            Directory.CreateDirectory(archiveFolder);
                        }

                        archiveFilePath = Path.Combine(archiveFolder, processedFileName + ".processed");
                        File.Move(slotFile, archiveFilePath);
                    }
                }
            }
            finally
            {
                dataAccess?.Close();
            }
        }

        public Result ClearArchiveOdmManualDisposition(string userId, string procName)
        {
            Result result = new Result
            {
                Messages = new List<string>()
            };

            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, procName);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());

                dataAccess.Execute();
                result.Succeeded = true;
            }
            catch (Exception ex)
            {
                result.Succeeded = false;
                result.Messages.Add("Error occurred while clearing and archiving manual disposition data: " + ex.Message);
                Log.Error("Error occurred while clearing and archiving manual disposition data", ex);
                throw;
            }
            finally
            {
                dataAccess?.Close();
            }

            return result;
        }

        public CheckProhibitedScenarioRunTimeResponse CheckProhibitedScenarioRunTime(string userId, string process)
        {
            CheckProhibitedScenarioRunTimeResponse result = new CheckProhibitedScenarioRunTimeResponse()
            {
                IsProhibited = false,
                ProhibitedMessage = String.Empty
            };

            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETODMPROHIBITEDSCENARIORUNTIME);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@process", process.NullToDBNull());

                string startTime, endTime;
                DateTime? startRunTime, endRunTime;
                DateTime curTime = DateTime.Now;

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        startTime = reader["StartTime"].ToStringSafely();
                        endTime = reader["EndTime"].ToStringSafely();
                        startRunTime = DateTime.Parse(startTime);
                        endRunTime = DateTime.Parse(endTime);

                        if (curTime >= startRunTime && curTime <= endRunTime)
                        {
                            result.IsProhibited = true;
                            result.ProhibitedMessage = $"Running scenario is prohibited between {startTime} and {endTime} due to conflict with system data loading. Please try again after {endTime}.";
                            break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                result.Succeeded = false;
                result.Messages = new List<string>();
                result.Messages.Add(ex.Message);
                Log.Error("Error occurred while checking prohibited scenario run time", ex);
                throw;
            }
            finally
            {
                dataAccess?.Close();
            }

            return result;
        }

        public string GetProhibitedTimeRanges(string userId, string process)
        {
            string timeRanges = String.Empty;
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETODMPROHIBITEDSCENARIORUNTIME);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@process", process.NullToDBNull());

                int idx = 0;
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        if (idx > 0)
                        {
                            timeRanges += " | ";
                        }

                        string startTime = reader["StartTime"].ToStringSafely();
                        string endTime = reader["EndTime"].ToStringSafely();

                        timeRanges = $"{timeRanges}{startTime} - {endTime}";
                        idx++;
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error("Error occurred while getting prohibited time ranges", ex);
                throw;
            }
            finally
            {
                dataAccess?.Close();
            }

            return timeRanges;
        }

        public QualFilterRemovableSLots GetRemovableSLotDetails(string userId, int version, string odmName, string procName)
        {
            QualFilterRemovableSLots result = new QualFilterRemovableSLots();
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, procName);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@version", version.NullToDBNull());
                dataAccess.AddInputParameter("@odmName", odmName.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var removableSLot = new QualFilterRemovableSLot()
                        {
                            Version = reader["Version"].ToIntegerSafely(),
                            OdmName = reader["OdmName"].ToStringSafely(),
                            MMNum = reader["MMNum"].ToStringSafely(),
                            DesignId = reader["DesignId"].ToStringSafely(),
                            MediaIPN = reader["MediaIPN"].ToStringSafely(),
                            SLot = reader["SLot"].ToStringSafely(),
                            CreatedDate = reader["CreateDate"].ToDateTimeSafely(),
                            IsRemovable = reader["IsRemovable"].ToStringSafely(),
                            SourceFileName = reader["SourceFileName"].ToStringSafely(),
                            ProcessedOn = reader["ProcessedOn"].ToDateTimeSafely()
                        };
                        result.Add(removableSLot);
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

        public QualFilterRemovableSLotUploads GetQualFilterRemovableSLotUploads(string userId, DateTime loadToDate, string procName)
        {
            QualFilterRemovableSLotUploads result = new QualFilterRemovableSLotUploads();
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, procName);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@loadToDate", loadToDate.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var removableSLots = new QualFilterRemovableSLotUpload()
                        {
                            Version = reader["Version"].ToIntegerSafely(),
                            OdmName = reader["OdmName"].ToStringSafely(),
                            CreatedDate = reader["CreateDate"].ToDateTimeSafely(),
                            SourceFileName = reader["SourceFileName"].ToStringSafely(),
                            ProcessedOn = reader["ReportedOn"].ToDateTimeSafely(),
                            RemovableCount = reader["RemovableCount"].ToIntegerSafely(),
                            TotalCount = reader["TotalCount"].ToIntegerSafely()
                        };
                        result.Add(removableSLots);
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

        protected DataTable ConvertToDataTable<T>(IList<T> data)
        {
            PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            for (int i = 0; i < props.Count; i++)
            {
                PropertyDescriptor prop = props[i];
                table.Columns.Add(prop.Name, prop.PropertyType);
            }

            object[] values = new object[props.Count];
            foreach (T item in data)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    values[i] = props[i].GetValue(item);
                }

                table.Rows.Add(values);
            }

            return table;
        }
    }

}
