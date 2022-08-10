using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class AdministrationDataContext
    {
        public AdministrationResult GetPreferredRoleNew(string userId)
        {
            AdministrationResult result = new AdministrationResult()
            {
                Succeeded = true,
                ActiveRole = String.Empty,
                Message = String.Empty
            };

            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPREFERREDROLE);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddOutputParameter("@activeRole", DbType.String, 500);

                if (dataAccess.Execute())
                {
                    result.ActiveRole = dataAccess.GetOutPutParameterValue("@activeRole").ToStringSafely();
                }
            }
            catch (Exception ex)
            {
                result.Succeeded = false;
                result.Message = ex.Message;
            }
            finally
            {
                dataAccess?.Close();
            }

            return result;
        }

        public AdministrationResult SavePreferredRole(string userId, string newActiveRole)
        {
            AdministrationResult result = new AdministrationResult()
            {
                Succeeded = false,
                ActiveRole = String.Empty,
                Message = String.Empty
            };

            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_SAVEPREFERREDROLE);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@newActiveRole", newActiveRole.NullToDBNull());

                if (dataAccess.Execute())
                {
                    result.ActiveRole = newActiveRole;
                    result.Succeeded = true;
                }
            }
            catch (Exception ex)
            {
                result.Message = ex.Message;
            }
            finally
            {
                dataAccess?.Close();
            }

            return result;
        }

        public string GetPreferredRole(string userId)
        {
            string activeRole = String.Empty;
            ISqlDataAccess dataAccess = null;

            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPREFERREDROLE);
                dataAccess.AddInputParameter("@userId", userId.NullToDBNull());
                dataAccess.AddOutputParameter("@activeRole", DbType.String, 500);

                if (dataAccess.Execute())
                {
                    activeRole = dataAccess.GetOutPutParameterValue("@activeRole").ToStringSafely();
                }
            }
            finally
            {
                dataAccess?.Close();
            }

            return activeRole;
        }


    }
}
