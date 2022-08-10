using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships;
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
    public class ProductOwnershipDataContext: IProductOwnershipDataContext
    {
        public EntitySingleMessageResult<ProductOwnerships> CreateProductOwnerShip(string userId, ProductOwnership entity)
        {
           
            
            EntitySingleMessageResult<ProductOwnerships> result = new EntitySingleMessageResult<ProductOwnerships>()
            {
                Succeeded = false,
                Entity = new ProductOwnerships(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATEPRODUCTOWNERSHIP);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@ProductTypeId", entity.ProductType.Id.NullToDBNull());
                dataAccess.AddInputParameter("@ProductPlatformId", entity.ProductPlatform.Id.NullToDBNull());
                dataAccess.AddInputParameter("@CodeNameId", entity.ProductCodeName.Id.NullToDBNull());
                dataAccess.AddInputParameter("@ProductCodeName", ((entity.ProductCodeName.Name == null)) ? null :entity.ProductCodeName.Name.Trim().NullToDBNull());
                dataAccess.AddInputParameter("@ProductBrandNameId", entity.ProductBrandName.Id.NullToDBNull());
                dataAccess.AddInputParameter("@ProductBrandName", ((entity.ProductBrandName.Name ==null)) ? null :entity.ProductBrandName.Name.Trim().NullToDBNull());
                dataAccess.AddInputParameter("@ProductLifeCycleStatusId", entity.ProductLifeCycleStatus.Id.NullToDBNull());
                dataAccess.AddInputParameter("@ProductLaunchDate", entity.ProductLaunchDate);
                dataAccess.AddTableValueParameter("@Contacts", UserDefinedTypes.PRODUCTOWNERSHIPCONTACTSCREATE, createTableConditions(entity.ProductContactRoles));            
                dataAccess.AddInputParameter("@IsActive", entity.IsActive.NullToDBNull());
                dataAccess.AddInputParameter("@CreatedBy", userId.NullToDBNull());
              
                dataAccess.AddInputParameter("@UpdatedBy", userId.NullToDBNull());


              
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    ProductContactRoles productContactRoles = new ProductContactRoles();
                    while (reader.Read())
                    {
                        productContactRoles.Add(newProductContactRole(reader));

                    }

                    reader.NextResult();
                   
                    while (reader.Read())
                    {
                        result.Entity.Add(newProductOwnership(reader, productContactRoles));
                    }
                  
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public EntitySingleMessageResult<ProductOwnerships> UpdateProductOwnerShip(string userId, ProductOwnership entity)
        {
            EntitySingleMessageResult<ProductOwnerships> result = new EntitySingleMessageResult<ProductOwnerships>()
            {
                Succeeded = false,
                Entity = new ProductOwnerships(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEPRODUCTOWNERSHIP);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", entity.Id.NullToDBNull());
                dataAccess.AddInputParameter("@RecordChanged", entity.RecordChanged.NullToDBNull());
                dataAccess.AddInputParameter("@ProductLifeCycleStatusId", entity.ProductLifeCycleStatus.Id.NullToDBNull());
                dataAccess.AddInputParameter("@ProductLaunchDate",  entity.ProductLaunchDate);
                dataAccess.AddTableValueParameter("@Contacts", UserDefinedTypes.PRODUCTOWNERSHIPCONTACTSCREATE, createTableConditions(entity.ProductContactRoles));            
                dataAccess.AddInputParameter("@IsActive", entity.IsActive.NullToDBNull());      
                dataAccess.AddInputParameter("@UpdatedBy", userId.NullToDBNull());
                EmailRecords emailRecords = new EmailRecords();
                EmailTemplate emailTemplate = new EmailTemplate();

                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    ProductContactRoles productContactRoles = new ProductContactRoles();
                    while (reader.Read())
                    {
                        productContactRoles.Add(newProductContactRole(reader));

                    }

                    reader.NextResult();

                    while (reader.Read())
                    {
                        result.Entity.Add(newProductOwnership(reader, productContactRoles));
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        emailTemplate = NewEmailTemplate(reader);
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        emailRecords.Add(newEmailRecord(reader));
                    }

                }

                
                if (entity.RecordChanged)
                    sendNotifications(emailTemplate, emailRecords, userId, entity, result.Entity.Where(record=>record.Id == entity.Id).Select(c=>c.Email).FirstOrDefault());

                       result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
                
            }
            catch (Exception ex)
            {
                Log.Error("Update Product Ownership Exception for User " + userId, ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }

       
        public EntitySingleMessageResult<ProductOwnerships> DeleteProductOwnerShip(string userId, int Id)
        {
            EntitySingleMessageResult<ProductOwnerships> result = new EntitySingleMessageResult<ProductOwnerships>()
            {
                Succeeded = false,
                Entity = new ProductOwnerships(),
            };
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_DELETEPRODUCTOWNERSHIP);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id",Id.NullToDBNull());
                


              
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    ProductContactRoles productContactRoles = new ProductContactRoles();
                    while (reader.Read())
                    {
                        productContactRoles.Add(newProductContactRole(reader));

                    }

                    reader.NextResult();

                    while (reader.Read())
                    {
                        result.Entity.Add(newProductOwnership(reader, productContactRoles));
                    }
                  
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                Log.Error("Delete Product Ownership Exception for User " + userId, ex);
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            return result;
        }
        public ProductOwnershipMetaData GetAll(string userId)
        {
            ProductOwnershipMetaData results = new ProductOwnershipMetaData();
            results.ProductOwnerships = new ProductOwnerships();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTOWNERSHIPMETADATA);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                  //  reader.NextResult();
                   

                    results.ProductOwnershipLookup = new ProductOwnershipLookup();
                    //Get Product Types
                  //  reader.NextResult();
                    results.ProductOwnershipLookup.ProductTypes = new ProductTypes();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductTypes.Add(newProductType(reader));

                    }

                    reader.NextResult();
                    results.ProductOwnershipLookup.ProductPlatforms = new ProductPlatforms();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductPlatforms.Add(newProductPlatform(reader));
                        
                    }

                    reader.NextResult();
                    results.ProductOwnershipLookup.ProductCodeNames = new ProductCodeNames();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductCodeNames.Add(newProductCodeName(reader));

                    }

                    reader.NextResult();
                    results.ProductOwnershipLookup.ProductBrandNames = new ProductBrandNames();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductBrandNames.Add(newProductBrandName(reader));

                    }

                    reader.NextResult();
                    results.ProductOwnershipLookup.ProductLifeCycleStatuses = new ProductLifeCycleStatuses();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductLifeCycleStatuses.Add(newProductLifeCycleStatus(reader));

                        }

                    reader.NextResult();
                    results.ProductOwnershipLookup.ProductContacts = new ProductContacts();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductContacts.Add(newProductContact(reader));

                    }

                    reader.NextResult();
                    results.ProductOwnershipLookup.ProductRoles = new ProductRoles();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductRoles.Add(newProductRole(reader));

                    }

                    reader.NextResult();
                    results.ProductOwnershipLookup.ProductContactRoles = new ProductContactRoles();
                    while (reader.Read())
                    {
                        results.ProductOwnershipLookup.ProductContactRoles.Add(newProductContactRole(reader));

                    }

                    reader.NextResult();
                    results.ProductOwnerships = new ProductOwnerships();
                    while (reader.Read())
                    {
                        results.ProductOwnerships.Add(newProductOwnership(reader, results.ProductOwnershipLookup.ProductContactRoles));
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


        private ProductOwnership newProductOwnership(IDataRecord record, ProductContactRoles _contact)
        {

            //string date = 
            ProductOwnership productOwnership = new ProductOwnership()
            {
                Id = record["Id"].ToIntegerSafely(),
                ProductType = new ProductType { Id = record["ProductTypeId"].ToIntegerSafely(), Name = record["ProductTypeName"].ToStringSafely()},
                ProductPlatform = new ProductPlatform { Id = record["ProductPlatformId"].ToIntegerSafely(), Name = record["ProductPlatformName"].ToStringSafely() },
                ProductCodeName = new ProductCodeName { Id = record["CodeNameId"].ToIntegerSafely(), Name = record["CodeName"].ToStringSafely() },
                ProductClassification = record["ProductClassification"].ToStringSafely(),
                ProductBrandName = new ProductBrandName { Id = record["ProductBrandNameId"].ToIntegerSafely(), Name = record["ProductBrandName"].ToStringSafely() },
                ProductLifeCycleStatus = new ProductLifeCycleStatus { Id = record["ProductLifeCycleStatusId"].ToIntegerSafely(), Name = record["ProductLifeCycleStatusName"].ToStringSafely() },
              
                ProductLaunchDate = record["ProductLaunchDate"].ToStringSafely() == "" ? null : Convert.ToDateTime(record["ProductLaunchDate"].ToStringSafely()).ToString("yyyy/MM/dd"),
                Email = record["Email"].ToStringSafely(),
                PME = record["PME"].ToStringSafely(),
                TME = record["TME"].ToStringSafely(),
                PQE = record["PQE"].ToStringSafely(),
                PMT = record["PMT"].ToStringSafely(),
                PDT = record["PDT"].ToStringSafely(),
                Others = record["Others"].ToStringSafely(),
                PMEManager = record["PMEManager"].ToStringSafely(),
                PMEManagerBackup = record["PMEManagerBackup"].ToStringSafely(),
                PMTManager = record["PMTManager"].ToStringSafely(),
                PMTManagerBackup = record["PMTManagerBackup"].ToStringSafely(),
                ProductContactRoles = new ProductContactRoles(),
             
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
            };


           // var data = _contact.Where(i => i.ContactId == productOwnership.Id).ToList();
            productOwnership.ProductContactRoles.AddRange(_contact.Where(i => i.ProductOwnershipId == productOwnership.Id).ToList());
            //foreach (ProductContactRole contact in data)
            //{
            //    // if (contact.AccountOwnershipsContactId > 0)
            //    productOwnership.ProductContactRoles.Add(contact);
            //}
            return productOwnership;

        }

        private ProductType newProductType(IDataRecord record)
        {
            return new ProductType()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
              
            };
        }

        private ProductPlatform newProductPlatform(IDataRecord record)
        {
            return new ProductPlatform()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
           
            };
        }


        private ProductCodeName newProductCodeName(IDataRecord record)
        {
            return new ProductCodeName()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
          
            };
        }


        private ProductBrandName newProductBrandName(IDataRecord record)
        {
            return new ProductBrandName()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            
            };
        }

        private ProductLifeCycleStatus newProductLifeCycleStatus(IDataRecord record)
        {
            return new ProductLifeCycleStatus()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
               
            };
        }

        private ProductContact newProductContact(IDataRecord record)
        {
            return new ProductContact()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                WWID = record["WWID"].ToStringSafely(),
                idSid = record["idSid"].ToStringSafely(),
                Email = record["Email"].ToStringSafely(),
                AlternateEmail = record["AlternateEmail"].ToStringSafely(),

            };
        }

        private ProductRole newProductRole(IDataRecord record)
        {
            return new ProductRole()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                PCN = record["PCN"].ToNullableBooleanSafely()
              
            };
        }


        private ProductContactRole newProductContactRole(IDataRecord record)
        {
            return new ProductContactRole()
            {
                ContactId = record["ContactId"].ToIntegerSafely(),
                ProductOwnershipId = record["ProductOwnershipId"].ToIntegerSafely(),
                ContactName = record["ContactName"].ToStringSafely(),
                RoleName = record["RoleName"].ToStringSafely(),
                Email = record["Email"].ToStringSafely(),
                AlternateEmail = record["AlternateEmail"].ToStringSafely(),
                WWID = record["WWID"].ToStringSafely(),
              idSid=  record["idSid"].ToStringSafely(),

            };
        }


        private DataTable createTableConditions(ProductContactRoles entities)
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

            result.Columns.Add("ContactName", typeof(string));
            result.Columns.Add("ContactId", typeof(int));
            result.Columns.Add("ContactRoleId", typeof(int));
            result.Columns.Add("ProductOwnershipId", typeof(int));
            result.Columns.Add("Email", typeof(string));
            result.Columns.Add("AlternateEmail", typeof(string));
            result.Columns.Add("idSid", typeof(string));
            result.Columns.Add("RoleName", typeof(string));
            result.Columns.Add("WWID", typeof(string));


            return result;
        }

        private void populateRowConditions(DataRow row, ProductContactRole entity)
        {
            row["ContactName"] = entity.ContactName.NullToDBNull();
            row["ContactId"] = entity.ContactId;
            row["ContactRoleId"] = System.DBNull.Value;
            row["ProductOwnershipId"] = entity.ProductOwnershipId.NullToDBNull();
            row["Email"] = entity.Email.Trim().NullToDBNull();
            row["AlternateEmail"] = entity.AlternateEmail ==null?null: entity.AlternateEmail.Trim().NullToDBNull();
            row["idSid"] = entity.idSid.NullToDBNull();
            row["RoleName"] = entity.RoleName.NullToDBNull();
            row["WWID"] = entity.WWID.NullToDBNull();

        }

     

        private void sendNotifications(EmailTemplate emailTemplate, EmailRecords emailRecords, string userId, ProductOwnership entity, string Email)
        {

         //   string Roles = String.Empty;
        //    string Roletext = String.Empty;

            StringBuilder ProductTable = new StringBuilder(EmailTableDefintions.htmlTableStart + EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdHeadStart + "Product" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Platform" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Code Name" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Brand Name" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTrEnd);
            ProductTable.Append(EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdRowStart + entity.ProductType.Name +EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + entity.ProductPlatform.Name + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + entity.ProductCodeName.Name + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + entity.ProductBrandName.Name + EmailTableDefintions.htmlTdRowEnd  + EmailTableDefintions.htmlTrEnd + EmailTableDefintions.htmlTableEnd);

          
            StringBuilder RoleTable = new StringBuilder(EmailTableDefintions.htmlTableStart + EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdHeadStart + "Role" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "Old Contact" + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdHeadStart + "New Contact" + EmailTableDefintions.htmlTdHeadEnd +  EmailTableDefintions.htmlTrEnd);
            foreach (string Role in emailRecords.Select(p => p.RoleName).Distinct())
            {
                string NewUser = String.Join(", ", emailRecords.Where(c => c.Type.Equals("Output") && c.RoleName.Equals(Role)).Select(c => c.AccountName).Distinct());
                string Olduser = String.Join(", ", emailRecords.Where(c => c.Type.Equals("Input") && c.RoleName.Equals(Role)).Select(c => c.AccountName).Distinct());
                string spantext = String.Empty;
                if (NewUser !=Olduser)
                {
                    spantext = "<span style='color:Red'>" + Role + "</spantext>";
                }
                else
                {
                    spantext = Role;
                }

                RoleTable.Append(EmailTableDefintions.htmlTrStart + EmailTableDefintions.htmlTdHeadStart + spantext + EmailTableDefintions.htmlTdHeadEnd + EmailTableDefintions.htmlTdRowStart + NewUser + EmailTableDefintions.htmlTdRowEnd + EmailTableDefintions.htmlTdRowStart + Olduser + EmailTableDefintions.htmlTdRowEnd  + EmailTableDefintions.htmlTrEnd);
            }

            //if (String.IsNullOrEmpty(Email))
            //{
            Email = String.Join(", ", emailRecords.Select(c => c.Email).Distinct());
            //}


            RoleTable.Append(EmailTableDefintions.htmlTableEnd);
       

           // string[] Emails = Email.Split(';');
            

            ITemplate template = new Template();
            template.TemplateText = emailTemplate.BodyXsl.Value;
            Transformer transformer = new Transformer();
            string baseUrl = Settings.BaseUrl;
            if (baseUrl.EndsWith(@"/")) baseUrl = baseUrl.Substring(0, baseUrl.Length - 1);
            string itemUrl = baseUrl + $"/ProductOwnerships/Index/";
            string bodyXml = string.Format(emailTemplate.BodyXml, baseUrl, ProductTable.ToString(), RoleTable.ToString(),userId,itemUrl);
            string body = transformer.Transform(template.TemplateText, bodyXml);
            var status = new MailBuilder(
                Settings.SystemEmailAddress
                  , Email.Split(','))
                //    , new string[] { "sureshkumarx.jayapal@domain.com" })
                //  , Email.Split(','))
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(Settings.SmtpServer)
                .Subject(Settings.EnvironmentName?.ToLowerInvariant() == "production" ? "" : Settings.EnvironmentName + " "  + emailTemplate.Subject)
                .Body(body)
              //  .Cc(new string[] { "jose.kurian@domain.com, jose.kurian@domain.com, jose.kurian@domain.com" })
                .ReplyTo(Settings.SupportEmailAddress)
                .Send();
        }

        public EmailTemplate NewEmailTemplate(IDataRecord record)
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
           //     Product = record["Product"].ToStringSafely()
           //     AddRole = record["AddRole"].ToStringSafely(),

            };
        }


    }
}
