using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes;
using Intel.NsgAuto.Callisto.Business.Entities.ProductLabels;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Data;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class MMRecipesDataContext : IMMRecipesDataContext
    {
        public MMRecipe Get(string userId, long id)
        {
            return get(userId, id);
        }

        public MMRecipeDetails SimulateDetails(string userId, string pcode)
        {
            MMRecipeDetails result = getReferenceTables(userId);
            result.MMRecipe = simulate(userId, pcode);
            return result;
        }

        public MMRecipes GetAll(string userId)
        {
            return getAll(userId);
        }

        public MMRecipes GetReviewables(string userId)
        {
            return getReviewables(userId);
        }

        public SingleMessageResult Update(string userId, MMRecipeUpdate model)
        {
            SingleMessageResult result = new SingleMessageResult();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_UPDATEMMRECIPE);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", model.Id.NullToDBNull());
                dataAccess.AddInputParameter("@PRQDate", model.PRQDate.NullToDBNull());
                dataAccess.AddInputParameter("@CustomerQualStatusId", model.CustomerQualStatusId.NullToDBNull());
                dataAccess.AddInputParameter("@PLCStageId", model.PLCStageId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader()) { }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
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

        public EntitySingleMessageResult<MMRecipeDetails> Approve(string userId, ReviewDecisionDto decision)
        {
            return approveOrReject(StoredProcedures.SP_UPDATEMMRECIPEAPPROVEDRETURNDETAILS, userId, decision);
        }

        public EntitySingleMessageResult<MMRecipeDetails> Cancel(string userId, long id)
        {
            return submitOrCancel(StoredProcedures.SP_UPDATEMMRECIPECANCELEDRETURNDETAILS, userId, id);
        }

        public EntitySingleMessageResult<MMRecipeDetails> Reject(string userId, ReviewDecisionDto decision)
        {
            return approveOrReject(StoredProcedures.SP_UPDATEMMRECIPEREJECTEDRETURNDETAILS, userId, decision);
        }

        public EntitySingleMessageResult<MMRecipeDetails> Submit(string userId, long id)
        {
            return submitOrCancel(StoredProcedures.SP_UPDATEMMRECIPESUBMITTEDRETURNDETAILS, userId, id);
        }

        private MMRecipe get(string userId, long id)
        {
            MMRecipe result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMMRECIPEDETAILS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newMMRecipe(reader);
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

        private MMRecipe simulate(string userId, string pcode)
        {
            MMRecipe result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                MATAttributes attributeValues = new MATAttributes();
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMMRECIPENEW);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@PCode", pcode.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newMMRecipe(reader);
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

        private MMRecipes getAll(string userId, long? id = null, string pcode = null, int? version = null, bool? isActive = null, bool? isPOR = null)
        {
            MMRecipes result = new MMRecipes();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMMRECIPES);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@PCode", pcode.NullToDBNull());
                dataAccess.AddInputParameter("@Version", version.NullToDBNull());
                dataAccess.AddInputParameter("@IsActive", isActive.NullToDBNull());
                dataAccess.AddInputParameter("@IsPOR", isPOR.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newMMRecipeBase(reader));
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

        public MMRecipeDetails GetDetails(string userId, long id)
        {
            MMRecipeDetails result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMMRECIPEDETAILS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newMMRecipeDetails(reader);
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

        private MMRecipes getReviewables(string userId)
        {
            MMRecipes result = new MMRecipes();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMMRECIPESREVIEWABLE);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newMMRecipeBase(reader));
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

        private MMRecipeDetails getReferenceTables(string userId)
        {
            MMRecipeDetails result = new MMRecipeDetails();
            result.CustomerQualStatuses = new CustomerQualStatuses();
            result.PLCStages = new PLCStages();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETMMRECIPEREFERENCETABLES);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.CustomerQualStatuses.Add(new CustomerQualStatus() { Id = reader["Id"].ToIntegerSafely(), Name = reader["Name"].ToStringSafely() });
                    }

                    reader.NextResult();

                    while (reader.Read())
                    {
                        result.PLCStages.Add(new PLCStage() { Id = reader["Id"].ToIntegerSafely(), Name = reader["Name"].ToStringSafely() });
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

        private EntitySingleMessageResult<MMRecipeDetails> approveOrReject(string storedProcedure, string userId, ReviewDecisionDto decision)
        {
            EntitySingleMessageResult<MMRecipeDetails> result = new EntitySingleMessageResult<MMRecipeDetails>()
            {
                Succeeded = false,
            };
            ReviewEmails emails = null;
            EmailTemplates emailTemplates = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, storedProcedure);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", decision.VersionId.NullToDBNull());
                dataAccess.AddInputParameter("@SnapshotReviewerId", decision.SnapshotReviewerId.NullToDBNull());
                dataAccess.AddInputParameter("@Comment", decision.Comment.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #12 result sets
                        result.Entity = newMMRecipeDetails(reader);

                        if (reader.NextResult())
                        {
                            // #13 result set: email templates
                            emailTemplates = reader.NewEmailTemplates();

                            // #14 result set: review emails
                            reader.NextResult();
                            emails = reader.NewReviewEmails();
                        }
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            sendEmails(emailTemplates, emails, decision.VersionId);
            return result;
        }


        private EntitySingleMessageResult<MMRecipeDetails> submitOrCancel(string storedProcedure, string userId, long id)
        {
            EntitySingleMessageResult<MMRecipeDetails> result = new EntitySingleMessageResult<MMRecipeDetails>()
            {
                Succeeded = false,
            };
            ReviewEmails emails = null;
            EmailTemplates emailTemplates = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, storedProcedure);
                dataAccess.AddOutputParameter("@Succeeded", DbType.Boolean);
                dataAccess.AddOutputParameter("@Message", DbType.String, 500);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // #1 through #12 result sets
                        result.Entity = newMMRecipeDetails(reader);

                        if (result.Entity.MMRecipe != null && reader.NextResult())
                        {
                            // #13 result set: email templates
                            emailTemplates = reader.NewEmailTemplates();

                            // #14 result set: review emails
                            reader.NextResult();
                            emails = reader.NewReviewEmails();
                        }
                    }
                }
                result.Succeeded = dataAccess.GetOutPutParameterValue("@Succeeded").ToNullableBooleanSafely() ?? false;
                result.Message = dataAccess.GetOutPutParameterValue("@Message").ToStringSafely();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dataAccess?.Close();
            }
            sendEmails(emailTemplates, emails, id);
            return result;
        }

        #region entity data binders
        private CustomerQualStatus newCustomerQualStatus(IDataRecord record)
        {
            return new CustomerQualStatus()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            };
        }

        private PLCStage newPLCStage(IDataRecord record)
        {
            return new PLCStage()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
            };
        }

        private MMRecipe newMMRecipe(IDataReader reader)
        {
            // #1 result set: mm recipe record
            MMRecipe result = newMMRecipeBase(reader);

            if (result != null)
            {
                MATAttributes attributeValues = new MATAttributes();

                result.NandMediaItems = new MMRecipeNandMediaItems();
                // #2 result set: nand/media items
                reader.NextResult();
                while (reader.Read())
                {
                    result.NandMediaItems.Add(newNandMediaItem(reader));
                }

                // #3 result set: nand/media attribute values
                reader.NextResult();
                while (reader.Read())
                {
                    attributeValues.Add(newMATAttribute(reader));
                }

                // #4 result set: associated items
                reader.NextResult();
                result.OtherAssociatedItems = new MMRecipeAssociatedItems();
                while (reader.Read())
                {
                    result.OtherAssociatedItems.Add(newAssociatedItem(reader));
                }

                // #5 result set: product label set version record
                reader.NextResult();
                if (reader.Read())
                {
                    result.ProductLabel = ProductLabelSetVersionsDataContext.newProductLabel(reader);
                }

                // #6 result set: product label attributes
                reader.NextResult();
                if (result.ProductLabel != null)
                {
                    result.ProductLabel.Attributes = new ProductLabelAttributes();
                    while (reader.Read())
                    {
                        result.ProductLabel.Attributes.Add(ProductLabelSetVersionsDataContext.newAttribute(reader));
                    }
                }

                foreach (MATAttribute attributeValue in attributeValues)
                {
                    MMRecipeNandMediaItem item = result.NandMediaItems.Find(x => x.MATId == attributeValue.MATId);
                    if (item != null)
                    {
                        item.AttributeValues.Add(attributeValue);
                    }
                }
            }
            return result;
        }

        private MMRecipeDetails newMMRecipeDetails(IDataReader reader)
        {
            MMRecipeDetails result = new MMRecipeDetails();
            // #1 through #6 result sets
            result.MMRecipe = newMMRecipe(reader);

            if (result.MMRecipe != null)
            {
                result.CustomerQualStatuses = new CustomerQualStatuses();
                // #7 result set: customer qual statuses
                reader.NextResult();
                while (reader.Read())
                {
                    result.CustomerQualStatuses.Add(newCustomerQualStatus(reader));
                }

                result.PLCStages = new PLCStages();
                // #8 result set: plc stages
                reader.NextResult();
                while (reader.Read())
                {
                    result.PLCStages.Add(newPLCStage(reader));
                }

                // #9 through #12 result sets: review stages, review groups, reviewers, review decisions
                reader.NextResult();
                result.Review = reader.NewReview();
            }

            return result;
        }

        private MMRecipe newMMRecipeBase(IDataRecord record)
        {
            int? intId;
            long? longId;
            return new MMRecipe()
            {
                Id = record["Id"].ToLongSafely(),
                Version = record["Version"].ToIntegerSafely(),
                IsPOR = record["IsPOR"].ToStringSafely().ToBooleanSafely(),
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                Status = new Status()
                {
                    Id = record["StatusId"].ToIntegerSafely(),
                    Name = record["StatusName"].ToStringSafely(),
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                PCode = record["PCode"].ToStringSafely(),
                ProductName = record["ProductName"].ToStringSafely(),
                ProductFamily = (intId = record["ProductFamilyId"].ToNullableIntSafely()) == null ? null : new ProductFamily()
                {
                    Id = intId.Value,
                    Name = record["ProductFamilyName"].ToStringSafely(),
                },
                MOQ = record["MOQ"].ToNullableIntSafely(),
                ProductionProductCode = record["ProductionProductCode"].ToStringSafely(),
                SCode = record["SCode"].ToStringSafely(),
                FormFactor = (intId = record["FormFactorId"].ToNullableIntSafely()) == null ? null : new FormFactor()
                {
                    Id = intId.Value,
                    Name = record["FormFactorName"].ToStringSafely(),
                },
                Customer = (intId = record["CustomerId"].ToNullableIntSafely()) == null ? null : new Customer()
                {
                    Id = intId.Value,
                    Name = record["CustomerName"].ToStringSafely(),
                },
                PRQDate = record["PRQDate"].ToNullableDateTimeSafely(),
                CustomerQualStatus = (intId = record["CustomerQualStatusId"].ToNullableIntSafely()) == null ? null : new CustomerQualStatus()
                {
                    Id = intId.Value,
                    Name = record["CustomerQualStatusName"].ToStringSafely(),
                },
                SCodeProductCode = record["SCodeProductCode"].ToStringSafely(),
                ModelString = record["ModelString"].ToStringSafely(),
                PLCStage = (intId = record["PLCStageId"].ToNullableIntSafely()) == null ? null : new PLCStage()
                {
                    Id = intId.Value,
                    Name = record["PLCStageName"].ToStringSafely(),
                },
                ProductLabel = (longId = record["ProductLabelId"].ToNullableLongSafely()) == null ? null : new ProductLabel()
                {
                    Id = longId.Value,
                    Capacity = record["ProductLabelCapacity"].ToStringSafely(),
                },
            };
        }

        private MATAttribute newMATAttribute(IDataRecord record)
        {
            return new MATAttribute()
            {
                Id = record["Id"].ToIntegerSafely(),
                MATId = record["MATId"].ToIntegerSafely(),
                Name = record["MATAttributeTypeName"].ToStringSafely(),
                NameDisplay = record["MATAttributeTypeNameDisplay"].ToStringSafely(),
                Value = record["Value"].ToStringSafely(),
                Operator = record["Operator"].ToStringSafely(),
                DataType = record["DataType"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private MMRecipeAssociatedItem newAssociatedItem(IDataRecord record)
        {
            MMRecipeAssociatedItem result = new MMRecipeAssociatedItem();
            populateAssociatedItem(result, record);
            return result;
        }

        private MMRecipeNandMediaItem newNandMediaItem(IDataRecord record)
        {
            MMRecipeNandMediaItem result = new MMRecipeNandMediaItem() { AttributeValues = new MATAttributes() };
            populateAssociatedItem(result, record);
            return result;
        }

        private void populateAssociatedItem(MMRecipeAssociatedItem item, IDataRecord record)
        {
            item.MATId = record["MATId"].ToIntegerSafely();
            item.SpeedItemCategory = new SpeedItemCategory()
            {
                Id = record["SpeedItemCategoryId"].ToIntegerSafely(),
                Name = record["SpeedItemCategoryName"].ToStringSafely(),
                Code = record["SpeedItemCategoryCode"].ToStringSafely(),
            };
            item.ItemId = record["ItemId"].ToStringSafely();
            item.Revision = record["Revision"].ToStringSafely();
            item.SpeedBomAssociationType = new SpeedBomAssociationType()
            {
                Id = record["SpeedBomAssociationTypeId"].ToIntegerSafely(),
                Name = record["SpeedBomAssociationTypeName"].ToStringSafely(),
                CodeSpeed = record["SpeedBomAssociationTypeCodeSpeed"].ToStringSafely(),
                NameSpeed = record["SpeedBomAssociationTypeNameSpeed"].ToStringSafely(),
            };
        }
        #endregion

        #region helpers
        private void sendEmails(EmailTemplates emailTemplates, ReviewEmails emails, long id)
        {
            if (emailTemplates != null && emails != null && emailTemplates.Count > 0 && emails.Count > 0)
            {
                string baseUrl = Settings.BaseUrl;
                if (baseUrl.EndsWith(@"/")) baseUrl = baseUrl.Substring(0, baseUrl.Length - 1); // remove trailing "/" character
                string itemUrl = baseUrl + $"/MMRecipes/Details/{id}";
                foreach (EmailTemplate template in emailTemplates)
                {
                    EmailTemplateSender sender = new EmailTemplateSender(template);
                    foreach (ReviewEmail email in emails.Where(x => x.EmailTemplateId == template.Id))
                    {
                        /*
                            {0} = base url for the site without trailing "/" character (used for images)
                            {1} = url for the item being reviewed
                            {2} = review stage name
                            {3} = recipient name
                            {4} = type of item being reviewed
                            {5} = item description
                         */
                        try
                        {
                            string[] to = email.To.Split(';');
                            sender.Cc.Clear();
                            sender.Bcc.Clear();
                            if (email.Cc.IsNeitherNullNorEmpty())
                            {
                                sender.Cc.AddRange(email.Cc.Split(';'));
                            }
                            if (email.Bcc.IsNeitherNullNorEmpty())
                            {
                                sender.Bcc.AddRange(email.Bcc.Split(';'));
                            }
                            sender.Send(to, baseUrl, itemUrl, email.ReviewAtDescription, email.RecipientName, "MM Recipe", email.VersionDescription);
                        }
                        catch { }
                    }
                }
            }
        }
        #endregion
    }
}
