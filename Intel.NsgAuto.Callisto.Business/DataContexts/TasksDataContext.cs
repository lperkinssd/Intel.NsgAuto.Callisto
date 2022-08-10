using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Data;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class TasksDataContext
    {
        public void Abort(long id)
        {
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_UPDATETASKABORT);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
        }

        public Task CreateByName(string taskTypeName)
        {
            Task result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_CREATETASKBYNAMERETURNTASK);
                dataAccess.AddInputParameter("@TaskTypeName", taskTypeName.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newTask(reader);
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

        public void CreateMessage(long id, string type, string text)
        {
            var textSafe = text;
            if (textSafe != null && textSafe.Length > 4000) textSafe = textSafe.Substring(0, 4000);
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_CREATETASKMESSAGE);
                dataAccess.AddInputParameter("@TaskId", id.NullToDBNull());
                dataAccess.AddInputParameter("@Type", type.NullToDBNull());
                dataAccess.AddInputParameter("@Text", textSafe.NullToDBNull());
                dataAccess.AddInputParameter("@Print", false);
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
        }

        public void End(long id)
        {
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_UPDATETASKEND);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
        }

        public Task Get(string userId, long id)
        {
            Tasks items = getAll(userId, id: id);
            if (items.Count > 0) return items[0];
            return null;
        }

        public Tasks GetAllOpen(string userId)
        {
            return getAll(userId, startDateTimeNull: false, endDateTimeNull: true, resolvedDateTimeNull: true);
        }

        public Tasks GetAllRecent(string userId, int days)
        {
            return getAll(userId, startDateTimeMin: DateTime.UtcNow.AddDays(-days));
        }

        public TaskMessages GetMessages(string userId, long taskId)
        {
            return getMessages(userId, taskId: taskId);
        }

        public Task Resolve(string userId, long id, string resolvedBy)
        {
            Task result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_UPDATETASKRESOLVED);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@ResolvedBy", resolvedBy.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newTask(reader);
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

        public Task ResolveAllAborted(string userId, long taskId, string resolvedBy)
        {
            Task result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_UPDATETASKSRESOLVEALLABOERTEDRETURNTASK);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@TaskId", taskId.NullToDBNull());
                dataAccess.AddInputParameter("@ResolvedBy", resolvedBy.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newTask(reader);
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

        public Task Unresolve(string userId, long id)
        {
            Task result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_UPDATETASKUNRESOLVED);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newTask(reader);
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

        private Tasks getAll(string userId, long? id = null, int? taskTypeId = null, string status = null, DateTime? startDateTimeMin = null, DateTime? startDateTimeMax = null, bool? startDateTimeNull = null, DateTime? endDateTimeMin = null, DateTime? endDateTimeMax = null, bool? endDateTimeNull = null, DateTime? abortDateTimeMin = null, DateTime? abortDateTimeMax = null, bool? abortDateTimeNull = null, DateTime? resolvedDateTimeMin = null, DateTime? resolvedDateTimeMax = null, bool? resolvedDateTimeNull = null, string resolvedBy = null)
        {
            Tasks result = new Tasks();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_GETTASKS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@TaskTypeId", taskTypeId.NullToDBNull());
                dataAccess.AddInputParameter("@Status", status.NullToDBNull());
                dataAccess.AddInputParameter("@StartDateTimeMin", startDateTimeMin.NullToDBNull());
                dataAccess.AddInputParameter("@StartDateTimeMax", startDateTimeMax.NullToDBNull());
                dataAccess.AddInputParameter("@StartDateTimeNull", startDateTimeNull.NullToDBNull());
                dataAccess.AddInputParameter("@EndDateTimeMin", endDateTimeMin.NullToDBNull());
                dataAccess.AddInputParameter("@EndDateTimeMax", endDateTimeMax.NullToDBNull());
                dataAccess.AddInputParameter("@EndDateTimeNull", endDateTimeNull.NullToDBNull());
                dataAccess.AddInputParameter("@AbortDateTimeMin", abortDateTimeMin.NullToDBNull());
                dataAccess.AddInputParameter("@AbortDateTimeMax", abortDateTimeMax.NullToDBNull());
                dataAccess.AddInputParameter("@AbortDateTimeNull", abortDateTimeNull.NullToDBNull());
                dataAccess.AddInputParameter("@ResolvedDateTimeMin", resolvedDateTimeMin.NullToDBNull());
                dataAccess.AddInputParameter("@ResolvedDateTimeMax", resolvedDateTimeMax.NullToDBNull());
                dataAccess.AddInputParameter("@ResolvedDateTimeNull", resolvedDateTimeNull.NullToDBNull());
                dataAccess.AddInputParameter("@ResolvedBy", resolvedBy.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newTask(reader));
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

        private TaskMessages getMessages(string userId, long? id = null, long? taskId = null)
        {
            TaskMessages result = new TaskMessages();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_GETTASKMESSAGES);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@TaskId", taskId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newTaskMessage(reader));
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

        public void UpdateProgress(long id, int progressPercent, string progressText = null)
        {
            var progressTextSafe = progressText;
            if (progressTextSafe != null && progressTextSafe.Length > 200) progressTextSafe = progressTextSafe.Substring(0, 200);

            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_UPDATETASKPROGRESS);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@ProgressPercent", progressPercent.NullToDBNull());
                dataAccess.AddInputParameter("@ProgressText", progressTextSafe.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                { }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
        }

        #region entity data binders
        public static Task newTask(IDataRecord record)
        {
            return new Task()
            {
                Id = record["Id"].ToLongSafely(),
                TaskType = new TaskType()
                {
                    Id = record["TaskTypeId"].ToIntegerSafely(),
                    Name = record["TaskTypeName"].ToStringSafely(),
                    ThresholdTimeLimit = record["TaskTypeThresholdTimeLimit"].ToNullableIntSafely(),
                    CodeLocation = record["TaskTypeCodeLocation"].ToStringSafely(),
                },
                Status = record["Status"].ToStringSafely(),
                StartDateTime = record["StartDateTime"].ToDateTimeSafely().SpecifyKindUtc(),
                EndDateTime = record["EndDateTime"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                AbortDateTime = record["AbortDateTime"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                ResolvedDateTime = record["ResolvedDateTime"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                ResolvedBy = record["ResolvedBy"].ToStringSafely(),
                ProgressPercent = record["ProgressPercent"].ToNullableByteSafely(),
                ProgressText = record["ProgressText"].ToStringSafely(),
                ElapsedMinutes = record["ElapsedMinutes"].ToIntegerSafely(),
                Problematic = record["Problematic"].ToStringSafely().ToBooleanSafely(),
            };
        }

        public static TaskMessage newTaskMessage(IDataRecord record)
        {
            return new TaskMessage()
            {
                Id = record["Id"].ToLongSafely(),
                TaskId = record["TaskId"].ToLongSafely(),
                Type = record["Type"].ToStringSafely(),
                Text = record["Text"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }
        #endregion
    }
}
