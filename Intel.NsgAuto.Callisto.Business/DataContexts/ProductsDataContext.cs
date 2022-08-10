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
    public class ProductsDataContext : IProductsDataContext
    {
        public Products GetAll(string userId)
        {
            Products results = new Products();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add(newProduct(reader));
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

        public Product Get(string userId, int id)
        {
            Product result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTS);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newProduct(reader);
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

        private Product newProduct(IDataRecord record)
        {
            return new Product()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                DesignFamily = new DesignFamily()
                {
                    Id = record["DesignFamilyId"].ToIntegerSafely(),
                    Name = record["DesignFamilyName"].ToStringSafely()
                },
                IsActive = record["IsActive"].ToStringSafely().ToBooleanSafely(),
                MixType = new MixType()
                {
                    Id = record["MixTypeId"].ToNullableIntSafely(),
                    Name = record["MixTypeName"].ToStringSafely(),
                    Abbreviation = record["MixTypeAbbreviation"].ToStringSafely()
                },
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
            };
        }
    }
}
