using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships;
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

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class AccountOwnershipDataContext :IAccountOwnershipDataContext
    {
        public AccountOwnershipMetaData GetAll(string userId)
        {
            AccountOwnershipMetaData results = new AccountOwnershipMetaData();
            
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETACCOUNTOWNERSHIPMETADATA);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    //  reader.NextResult();


                    results.AccountOwnershipLookup = new AccountOwnershipLookup();
                 
                    results.AccountOwnershipLookup.AccountClients = new AccountClients();
                    while (reader.Read())
                    {
                        results.AccountOwnershipLookup.AccountClients.Add(newAccountClient(reader));

                    }

                    reader.NextResult();
                    results.AccountOwnershipLookup.AccountCustomers = new AccountCustomers();
                    while (reader.Read())
                    {
                        results.AccountOwnershipLookup.AccountCustomers.Add(newAccountCustomers(reader));

                    }

                    reader.NextResult();
                    results.AccountOwnershipLookup.AccountSubsidiaries = new AccountSubsidiaries();
                    while (reader.Read())
                    {
                        results.AccountOwnershipLookup.AccountSubsidiaries.Add(newAccountSubsidiary(reader));

                    }

                   

                    reader.NextResult();
                    results.AccountOwnershipLookup.AccountProducts = new AccountProducts();
                    while (reader.Read())
                    {
                        results.AccountOwnershipLookup.AccountProducts.Add(newAccountProduct(reader));

                    }

                

                    reader.NextResult();
                    results.AccountOwnershipLookup.AccountRoles = new AccountRoles();
                    while (reader.Read())
                    {
                        results.AccountOwnershipLookup.AccountRoles.Add(newAccountRole(reader));

                    }


                    reader.NextResult();
                    AccountOwnershipContacts AccountOwnershipContacts = new AccountOwnershipContacts();
                    while (reader.Read())
                    {
                        AccountOwnershipContacts.Add(newAccountOwnershipContact(reader));

                    }   



                    reader.NextResult();
                    results.AccountOwnerships = new AccountOwnerships();
                    while (reader.Read())
                    {
                                             
                        results.AccountOwnerships.Add(newAccountOwnership(reader, AccountOwnershipContacts));
                    }


                }
            }
            catch (Exception ex)
            {
                Log.Error("Get Account Ownership Exception for User " + userId, ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return results;
        }

       

        public EntitySingleMessageResult<AccountOwnerships> CreateAccountOwnerShip(string userId, AccountOwnership entity)
        {
            EntitySingleMessageResult<AccountOwnerships> result = new EntitySingleMessageResult<AccountOwnerships>()
            {
                Succeeded = false,
                Entity = new AccountOwnerships(),
            };

           // return result;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEACCOUNTOWNERSHIP);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@AccountClientId", entity.AccountClient.Id.NullToDBNull());
                dataAccess.AddInputParameter("@AccountCustomerId", entity.AccountCustomer.Id.NullToDBNull());
                dataAccess.AddInputParameter("@AccountSubsidiaryId", entity.AccountSubsidiary.Id.NullToDBNull());
                dataAccess.AddInputParameter("@AccountProductid", entity.AccountProduct.Id.NullToDBNull());
      
                dataAccess.AddInputParameter("@IsActive", entity.IsActive.NullToDBNull());
                dataAccess.AddInputParameter("@Notes", entity.Notes.NullToDBNull());
                dataAccess.AddInputParameter("@CreatedBy", userId.NullToDBNull());
                dataAccess.AddTableValueParameter("@Contacts", UserDefinedTypes.ACCOUNTOWNERSHIPCONTACTSCREATE, createTableConditions(entity.AccountOwnershipContacts));
                dataAccess.AddInputParameter("@UpdatedBy", userId.NullToDBNull());


            
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    AccountOwnershipContacts AccountOwnershipContacts = new AccountOwnershipContacts();
                    while (reader.Read())
                    {
                        AccountOwnershipContacts.Add(newAccountOwnershipContact(reader));

                    }
                    reader.NextResult();
                    while (reader.Read())
                    {
                        result.Entity.Add(newAccountOwnership(reader,AccountOwnershipContacts));
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error("Create Account Ownership Exception for User " + userId, ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }


        public EntitySingleMessageResult<AccountOwnerships> UpdateAccountOwnerShip(string userId, AccountOwnership entity)
        {
            EntitySingleMessageResult<AccountOwnerships> result = new EntitySingleMessageResult<AccountOwnerships>()
            {
                Succeeded = false,
                Entity = new AccountOwnerships(),
            };

            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEACCOUNTOWNERSHIP);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", entity.Id.NullToDBNull());
                dataAccess.AddInputParameter("@RecordChanged", entity.RecordChanged.NullToDBNull());
                dataAccess.AddInputParameter("@Notes", entity.Notes.NullToDBNull());         
                dataAccess.AddTableValueParameter("@Contacts", UserDefinedTypes.ACCOUNTOWNERSHIPCONTACTSCREATE, createTableConditions(entity.AccountOwnershipContacts));
                dataAccess.AddInputParameter("@UpdatedBy", userId.NullToDBNull());

                EmailRecords emailRecords = new EmailRecords();
                EmailTemplate emailTemplate = new EmailTemplate();
                //AccountEmailTemplate accountEmailTemplate = new AccountEmailTemplate();
                string Product = string.Empty;

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    AccountOwnershipContacts AccountOwnershipContacts = new AccountOwnershipContacts();
                    while (reader.Read())
                    {
                        AccountOwnershipContacts.Add(newAccountOwnershipContact(reader));

                    }
                    reader.NextResult();
                    while (reader.Read())
                    {
                        result.Entity.Add(newAccountOwnership(reader, AccountOwnershipContacts));
                    }
                    
                    reader.NextResult();
                    while (reader.Read())
                    {
                        emailTemplate = NewEmailTemplate(reader);
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        Product = reader["Name"].ToStringSafely();
                    }

                    reader.NextResult();

                    while (reader.Read())
                    {
                        emailRecords.Add(newEmailRecord(reader));
                    }
                }

                if (entity.RecordChanged)
                    sendNotifications(emailTemplate, emailRecords, userId, entity, result.Entity.Where(record => record.Id == entity.Id).Select(c => c.Email).FirstOrDefault(), Product);

                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
               
                
            }
            catch (Exception ex)
            {
                Log.Error("Update Account Ownership Exception for User " + userId, ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }



        public EntitySingleMessageResult<AccountOwnerships> DeleteAccountOwnerShip(string userId, int Id)
        {
            EntitySingleMessageResult<AccountOwnerships> result = new EntitySingleMessageResult<AccountOwnerships>()
            {
                Succeeded = false,
                Entity = new AccountOwnerships(),
            };

            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_DELETEACCOUNTOWNERSHIP);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", Id.NullToDBNull());
               


                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    AccountOwnershipContacts AccountOwnershipContacts = new AccountOwnershipContacts();
                    while (reader.Read())
                    {
                        AccountOwnershipContacts.Add(newAccountOwnershipContact(reader));

                    }
                    reader.NextResult();
                    while (reader.Read())
                    {
                        result.Entity.Add(newAccountOwnership(reader, AccountOwnershipContacts));
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error("Delete Account Ownership Exception for User " + userId, ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

        public EmailTemplate NewEmailTemplate( IDataRecord record)
        {
            return new EmailTemplate()
            {
                BodyXsl = new EmailTemplateBodyXsl()
                {
                    Value = record["BodyXslValue"].ToStringSafely(),
                },
               
                BodyXml = record["BodyXml"].ToStringSafely(),
                Subject = record["Subject"].ToStringSafely(),
            };
        }

        private EmailRecord newEmailRecord(IDataRecord record)
        {
            return new EmailRecord()
            {
                AccountName = record["AccountName"].ToStringSafely(),
                Email = record["Email"].ToStringSafely(),
                RoleName = record["RoleName"].ToStringSafely(),
                Type = record["Type"].ToStringSafely()

            };
        }

        private AccountClient newAccountClient(IDataRecord record)
        {
            return new AccountClient()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
           
            };
        }

        private AccountRole newAccountRole(IDataRecord record)
        {
            return new AccountRole()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                PCN = record["PCN"].ToNullableBooleanSafely()
           
            };
        }

        private AccountCustomer newAccountCustomers(IDataRecord record)
        {
            return new AccountCustomer()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
          
            };
        }

        private AccountSubsidiary newAccountSubsidiary(IDataRecord record)
        {
            return new AccountSubsidiary()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
          
            };
        }

      

        private AccountProduct newAccountProduct(IDataRecord record)
        {
            return new AccountProduct()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            
            };
        }

        private AccountOwnershipContact newAccountOwnershipContact(IDataRecord record)
        {
            return new AccountOwnershipContact()
            {
                AccountOwnershipId = record["AccountOwnershipId"].ToIntegerSafely(),
                AccountOwnershipsContactId = record["AccountOwnershipsContactId"].ToIntegerSafely(),
                AccountName = record["AccountName"].ToStringSafely(),
                WWID = record["WWID"].ToStringSafely().Trim(),
                Email = record["Email"].ToStringSafely().Trim(),
                AlternateEmail = record["AlternateEmail"].ToStringSafely().Trim(),
                idSid = record["idSid"].ToStringSafely().Trim(),
                RoleName = record["RoleName"].ToStringSafely(),
               
            };
        }

        private AccountOwnership newAccountOwnership(IDataRecord record, AccountOwnershipContacts _contact)
        {

            AccountOwnership accountOwnership = new AccountOwnership()
            {
                Id = record["Id"].ToIntegerSafely(),
                AccountClient = new AccountClient { Id = record["AccountClientId"].ToIntegerSafely(), Name = record["AccountClientName"].ToStringSafely() },
                AccountCustomer = new AccountCustomer { Id = record["AccountCustomerId"].ToIntegerSafely(), Name = record["AccountCustomerName"].ToStringSafely() },
                AccountSubsidiary = new AccountSubsidiary { Id = record["AccountSubsidiaryId"].ToIntegerSafely(), Name = record["AccountSubsidiaryName"].ToStringSafely() },
                AccountProduct = new AccountProduct { Id = record["AccountProductId"].ToIntegerSafely(), Name = record["AccountProductName"].ToStringSafely() },
                AccountProcess = record["AccountProcess"].ToStringSafely(),
                AccountOwnershipContacts = new AccountOwnershipContacts(),
                AEName = record["AEName"].ToStringSafely(),
                PCNName = record["PCNName"].ToStringSafely(),
                CQEName = record["CQEName"].ToStringSafely(),
                FAEName = record["FAEName"].ToStringSafely(),
                FSEName = record["FSEName"].ToStringSafely(),
                CMEName = record["CMEName"].ToStringSafely(),
                OthersName = record["OthersName"].ToStringSafely(),
                AEManagerName = record["AEManagerName"].ToStringSafely(),
                CQEManagerName = record["CQEManagerName"].ToStringSafely(),
                AEManagerBackupName = record["AEManagerBackupName"].ToStringSafely(),
                CQEManagerBackupName = record["CQEManagerBackupName"].ToStringSafely(),             
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                Notes = record["Notes"].ToStringSafely(),
                Email = record["Email"].ToStringSafely().Replace("N/A;", "").Replace("N/A", "").Trim(),                
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely()


            };

           

           

            accountOwnership.AccountOwnershipContacts.AddRange(_contact.Where(i => i.AccountOwnershipId == accountOwnership.Id).ToList());
            //foreach (AccountOwnershipContact contact in data)
            //{
            //    if (contact.AccountOwnershipsContactId > 0)
            //        accountOwnership.AccountOwnershipContacts.Add(contact);
            //}
            return accountOwnership;
        }

        
        private DataTable createTableConditions(AccountOwnershipContacts entities)
        {
            DataTable table = createTableConditions();
            int index = 0;
            if (entities != null)
            {
                foreach (var entity in entities)
                {
                    var row = table.NewRow();
                    populateRowConditions(row, entity);
                    table.Rows.Add(row);
                }
                table.AcceptChanges();
            }
            return table;
        }

        private DataTable createTableConditions()
        {
            var result = new DataTable();
           
            result.Columns.Add("AccountName", typeof(string));
            result.Columns.Add("AccountOwnershipId", typeof(int));
            result.Columns.Add("AccountOwnershipsContactId", typeof(int));
            result.Columns.Add("Email", typeof(string));
            result.Columns.Add("AlternateEmail", typeof(string));
            result.Columns.Add("idSid", typeof(string));
            result.Columns.Add("RoleName", typeof(string));
            result.Columns.Add("WWID", typeof(string));
           

            return result;
        }

        private void populateRowConditions(DataRow row, AccountOwnershipContact entity)
        {
            row["AccountName"] = entity.AccountName.NullToDBNull();
            row["AccountOwnershipId"] = entity.AccountOwnershipId.NullToDBNull();
            row["AccountOwnershipsContactId"] = entity.AccountOwnershipsContactId.NullToDBNull();
            row["Email"] = entity.Email.Trim().NullToDBNull();
            row["AlternateEmail"] = entity.AlternateEmail == null ? null : entity.AlternateEmail.Trim().NullToDBNull();
            row["idSid"] = entity.idSid.NullToDBNull();
            row["RoleName"] = entity.RoleName.NullToDBNull();
            row["WWID"] = entity.WWID.NullToDBNull();
            
        }
        private void sendEmails(EmailTemplate emailTemplate, EmailRecords emailRecords,string userId)
        {
            //foreach (string Role in emailRecords.Select(p => p.RoleName).Distinct())
            //{
                string UserEmails = String.Join(";", emailRecords.Select(c => c.Email.Trim()).Distinct());
                string NewUser = String.Join(";", emailRecords.Where(c => c.Type.Equals("Input")).Select(c => c.AccountName).Distinct());
                string Role = String.Join(";", emailRecords.Select(c => c.RoleName).Distinct());
                string oldUser = String.Join(";", emailRecords.Where(c => c.Type.Equals("Output")).Select(c => c.AccountName).Distinct());
                string Product = emailRecords.Select(p => p.Product).FirstOrDefault();
                emailTemplate.Subject = "Ownership Change Notification";
                if (emailTemplate != null && UserEmails != null && oldUser != null && UserEmails != "" && oldUser != "")
                {
                    string baseUrl = Settings.BaseUrl;
                   // if (baseUrl.EndsWith(@"/")) baseUrl = baseUrl.Substring(0, baseUrl.Length - 1); // remove trailing "/" character
                  //  string itemUrl = baseUrl + $"/AccountOwnerships/Index/";

                    //   { 0} = base url for the site without trailing "/" character(used for images)
                    //        {1} = Product Name
                    //        {2} = Role of the User
                    //        {3} = The new user names
                    //        {4} = The older user names
                    //        {5} = User changed the record
                    //     */
                    try
                    {
                        EmailTemplateSender sender = new EmailTemplateSender(emailTemplate);
                        string[] to = "sureshkumarx.jayapal@domain.com".Split(';'); // UserEmails.Split(';');
                     
                        sender.Send(to, baseUrl, Product,Role,NewUser,oldUser, userId);
                    }
                    catch (Exception ex) {
                        Log.Error("Update Account Ownership Send Email Exception for User " + userId, ex);
                        throw ex;
                    }
                }
               
           // }
        }

        //private void sendNotifications(EmailTemplate emailTemplate, EmailRecords emailRecords, string userId)
        //{

        //    ITemplate template = new Template();
        //    template.TemplateText = emailTemplate.BodyXsl.Value;
        //    Transformer transformer = new Transformer();
        //    string body = transformer.Transform(template.TemplateText, emailTemplate.BodyXml);
        //    var status = new MailBuilder(
        //        Settings.SystemEmailAddress
        //        , new string[] { "jose.kurian@domain.com, jose.kurian@domain.com" })
        //        .UsingTemplateText(template.TemplateText)
        //        .UsingSmtpServer(Settings.SmtpServer)
        //        .Subject(Settings.EnvironmentName + "Test Mail from Unit Test. Ignore this mail, please.")
        //        .Body(body)
        //        .Cc(new string[] { "jose.kurian@domain.com, jose.kurian@domain.com, jose.kurian@domain.com" })
        //        .ReplyTo(Settings.SupportEmailAddress)
        //        .Send();
        //}


        private void sendNotifications(EmailTemplate emailTemplate, EmailRecords emailRecords, string userId, AccountOwnership entity, string Email, string Product)
        {

            //   string Roles = String.Empty;
            //    string Roletext = String.Empty;

            StringBuilder ProductTable = new StringBuilder(EmailTableDefintions.htmlTableStart + EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdHeadStart + "DC/Client" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Main Customer" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Customer Breakdown" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Product Breakdown" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTrEnd);
            ProductTable.Append(EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdRowStart + entity.AccountClient.Name + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + entity.AccountCustomer.Name + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + entity.AccountSubsidiary.Name + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + entity.AccountProduct.Name + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTrEnd + EmailTableDefintions.htmlTableEnd);

            //if (String.IsNullOrEmpty(Email))
            //{
            Email = String.Join(", ", emailRecords.Select(c => c.Email).Distinct());
            //}

            StringBuilder RoleTable = new StringBuilder(EmailTableDefintions.htmlTableStart + EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdHeadStart + "Role" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Old Contact" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "New Contact" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTrEnd);
            foreach (string Role in emailRecords.Select(p => p.RoleName).Distinct())
            {
                string NewUser = String.Join(", ", emailRecords.Where(c => c.Type.Equals("Output") && c.RoleName.Equals(Role)).Select(c => c.AccountName).Distinct());
                string Olduser = String.Join(", ", emailRecords.Where(c => c.Type.Equals("Input") && c.RoleName.Equals(Role)).Select(c => c.AccountName).Distinct());
                string spantext = String.Empty;
                if (NewUser != Olduser)
                {
                    spantext = "<span style='color:Red'>" + Role + "</spantext>";
                }
                else
                {
                    spantext = Role;
                }

                RoleTable.Append(EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdHeadStart + spantext + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdRowStart + NewUser + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + Olduser + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTrEnd);
            }

            RoleTable.Append(EmailTableDefintions.htmlTableEnd);


            // string[] Emails = Email.Split(';');


            ITemplate template = new Template();
            template.TemplateText = emailTemplate.BodyXsl.Value;
            Transformer transformer = new Transformer();
            string baseUrl = Settings.BaseUrl;
            if (baseUrl.EndsWith(@"/")) baseUrl = baseUrl.Substring(0, baseUrl.Length - 1);
            string itemUrl = baseUrl + $"/AccountOwnerships/Index/";
            string bodyXml = string.Format(emailTemplate.BodyXml, baseUrl, ProductTable.ToString(), RoleTable.ToString(), userId, itemUrl, Product);
            string body = transformer.Transform(template.TemplateText, bodyXml);
            var status = new MailBuilder(
                Settings.SystemEmailAddress
              ,  Email.Split(',') )
             //   , new string[] { "sureshkumarx.jayapal@domain.com" })
            // , Email.Split(';'))
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(Settings.SmtpServer)
                .Subject(Settings.EnvironmentName?.ToLowerInvariant() == "production" ? "" : Settings.EnvironmentName + " " + emailTemplate.Subject)
                .Body(body)
                //  .Cc(new string[] { "jose.kurian@domain.com, jose.kurian@domain.com, jose.kurian@domain.com" })
                .ReplyTo(Settings.SupportEmailAddress)
                .Send();
        }






    }
}
