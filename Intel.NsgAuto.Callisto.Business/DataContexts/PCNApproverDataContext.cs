using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;
using Intel.NsgAuto.Callisto.Business.Logging;
using Intel.NsgAuto.Shared.Mail;
using System.Web.UI.WebControls;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class PCNApproverDataContext : IPCNApproverDataContext
    {
        public PCNApproverMetadata GetAll(string userId)
        {
            PCNApproverMetadata results = new PCNApproverMetadata();
           
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPCNAPPROVERMETADATA);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                  
                   

                   
                    results.ProductCodeNames = new ProductCodeNames();
                    while (reader.Read())
                    {
                        results.ProductCodeNames.Add(newProductCodeName(reader));

                    }

                    reader.NextResult();
                    results.AccountCustomers = new AccountCustomers();
                    while (reader.Read())
                    {
                        results.AccountCustomers.Add(newAccountCustomer(reader));

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
            return results;
        }


        public EntitySingleMessageResult<Approvers> GetApprovers(PCNApproverFilter PCNApproverFilter, string userId)
        {
            EntitySingleMessageResult<Approvers> result = new EntitySingleMessageResult<Approvers>()
            {
                Succeeded = false,
                Entity = new Approvers(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPCNAPPROVERLIST);
           
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@ProductCodeNameId", PCNApproverFilter.ProductCodeName.Id.NullToDBNull());
                dataAccess.AddInputParameter("@AccountCustomerId", PCNApproverFilter.AccountCustomer.Id.NullToDBNull());
                //dataAccess.AddInputParameter("@ProductCodeName", PCNApproverFilter.ProductCodeName.Name.NullToDBNull());
                //dataAccess.AddInputParameter("@AccountCustomerName", PCNApproverFilter.AccountCustomer.Name.NullToDBNull());

                using (IDataReader reader = dataAccess.ExecuteReader())
                {

                    while (reader.Read())
                    {
                        //  AccountOwnershipContacts.Add(newAccountOwnershipContact(reader));
                        result.Entity.Add(newApprover(reader));

                    }
                }

              
            }
            catch (Exception ex)
            {
                Log.Error("Create Product Ownership Exception for User " + userId, ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        private ProductCodeName newProductCodeName(IDataRecord record)
        {
            return new ProductCodeName()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),

            };
        }

        private AccountCustomer newAccountCustomer(IDataRecord record)
        {
            return new AccountCustomer()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),

            };
        }

        private Approver newApprover(IDataRecord record)
        {
            return new Approver()
            {
                ContactName = record["ContactName"].ToStringSafely(),
                RoleName = record["RoleName"].ToStringSafely(),
                Email = record["Email"].ToStringSafely()
            };
        }


        



    }
}
