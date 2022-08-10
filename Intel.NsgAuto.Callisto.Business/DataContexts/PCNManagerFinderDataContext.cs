using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder;
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
   public class PCNManagerFinderDataContext : IPCNManagerFinderDataContext
    {
        public PCNManagerMetadata GetAll(string userId)
        {
            PCNManagerMetadata results = new PCNManagerMetadata();

            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPCNMANAGERMETADATA);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                int counter = 1;
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

                     reader.NextResult();
                    results.PCNManagerRoles = new PCNManagerRoles();
                    while (reader.Read())
                    {
                        
                        results.PCNManagerRoles.Add(newPCNManagerRole(reader, counter++));

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


        public EntitySingleMessageResult<Approvers> GetApprovers(PCNManagerFilter PCNManagerFilter, string userId)
        {
            EntitySingleMessageResult<Approvers> result = new EntitySingleMessageResult<Approvers>()
            {
                Succeeded = false,
                Entity = new Approvers(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPCNMANAGERLIST);

                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@ProductCodeNameId", PCNManagerFilter.ProductCodeName.Id.NullToDBNull());
                dataAccess.AddInputParameter("@AccountCustomerId", PCNManagerFilter.AccountCustomer.Id.NullToDBNull());
                if (PCNManagerFilter.PCNManagerRole.Name !="All")
                    dataAccess.AddInputParameter("@Role", PCNManagerFilter.PCNManagerRole.Name.NullToDBNull());

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

        private PCNManagerRole newPCNManagerRole(IDataRecord record, int counter)
        {
            return new PCNManagerRole()
            {
                Id = counter,
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
