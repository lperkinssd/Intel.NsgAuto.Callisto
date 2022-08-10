using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities.App;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.DirectoryServices;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    internal class UserDataContext : IUserDataContext
    {
        /// <summary>
        /// Initializes a user session
        /// </summary>
        /// <param name="sessionId"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public User InitializeSession(string sessionId, User user)
        {
            //ISqlDataAccess dataAccess = null;
            //try
            //{
            //    dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_INITIALIZESESSION);
            //    ////dataAccess.AddInputParameter("@UserIdSid", DbType.String, user.Attributes.Idsid);
            //    //dataAccess.AddInputParameter("@SessionId", DbType.String, sessionId);
            //    //dataAccess.AddTableValueParameter("@Users", "[qan].[IUsers]", getUsersTable(user.Attributes));
            //    //dataAccess.AddTableValueParameter("@UserRoles", "[qan].[IUserRoles]", getUserRolesTable(user.Attributes));
            //    //dataAccess.AddTableValueParameter("@UserProcessRoles", "[qan].[IUserProcessRoles]", getUserProcessRolesTable(user));
            //    dataAccess.ExecuteReader();
            //    //if (dataAccess.DataReader.IsNotNull())
            //    //{
            //    //    // Get the user process roles
            //    //    user.ProcessRoles = new ProcessRoles();
            //    //    while (dataAccess.DataReader.Read())
            //    //    {
            //    //        user.ProcessRoles.Add(
            //    //            new ProcessRole()
            //    //            {
            //    //                RoleName = dataAccess.DataReader["RoleName"].ToStringSafely(),
            //    //                Process = new Process()
            //    //                {
            //    //                    Name = dataAccess.DataReader["Name"].ToStringSafely(),
            //    //                    Id = dataAccess.DataReader["Name"].ToStringSafely(),
            //    //                    IsActive = dataAccess.DataReader["IsActive"].ToStringSafely().ToBooleanSafely(),
            //    //                    CreatedBy = dataAccess.DataReader["CreatedBy"].ToStringSafely(),
            //    //                    CreatedOn = dataAccess.DataReader["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            //    //                    UpdatedBy = dataAccess.DataReader["UpdatedBy"].ToStringSafely(),
            //    //                    UpdatedOn = dataAccess.DataReader["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
            //    //                }
            //    //            });
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{
            //    throw ex;
            //}
            //finally
            //{
            //    if (dataAccess.IsNotNull())
            //    {
            //        dataAccess.Close();
            //    }
            //}
            return user;
        }

        private DataTable getUsersTable(Employee user)
        {
            DataTable tbl = null;
            try
            {
                tbl = new DataTable();
                tbl.Columns.Add("WWID", typeof(string));
                tbl.Columns.Add("IdSid", typeof(string));
                tbl.Columns.Add("Name", typeof(string));
                tbl.Columns.Add("Email", typeof(string));
                DataRow row = tbl.NewRow();
                //row["WWID"] = user.WWID;
                //row["IdSid"] = user.Idsid;
                //row["Name"] = user.Name;
                //row["Email"] = user.Email;
                tbl.Rows.Add(row);

                tbl.AcceptChanges();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tbl;
        }
        private DataTable getUserRolesTable(Employee user)
        {
            DataTable tbl = null;
            try
            {
                tbl = new DataTable();
                tbl.Columns.Add("WWID", typeof(string));
                tbl.Columns.Add("IdSid", typeof(string));
                tbl.Columns.Add("RoleName", typeof(string));
                //foreach (string role in user.Roles)
                //{
                //    //DataRow row = tbl.NewRow();
                //    //row["WWID"] = user.WWID;
                //    //row["IdSid"] = user.Idsid;
                //    //row["RoleName"] = role;
                //    //tbl.Rows.Add(row);
                //}
                //tbl.AcceptChanges();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tbl;
        }
        private DataTable getUserProcessRolesTable(User user)
        {
            DataTable tbl = null;
            try
            {
                tbl = new DataTable();
                tbl.Columns.Add("WWID", typeof(string));
                tbl.Columns.Add("IdSid", typeof(string));
                tbl.Columns.Add("RoleName", typeof(string));
                foreach (ProcessRole role in user.ProcessRoles)
                {
                    if (role.IsNotNull())
                    {
                        DataRow row = tbl.NewRow();
                        row["WWID"] = user.Attributes.WWID;
                        row["IdSid"] = user.Attributes.Idsid;
                        row["RoleName"] = role.RoleName;
                        tbl.Rows.Add(row);
                    }
                }
                tbl.AcceptChanges();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tbl;
        }
    }
}
