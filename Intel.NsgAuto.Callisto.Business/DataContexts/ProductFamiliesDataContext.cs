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
    public class ProductFamiliesDataContext
    {
        public ProductFamily Get(string userId, int id)
        {
            ProductFamilies items = getAll(userId, id: id);
            if (items.Count > 0) return items[0];
            return null;
        }

        public ProductFamilies GetAll(string userId)
        {
            return getAll(userId);
        }

        private ProductFamilies getAll(string userId, int? id = null, string name = null)
        {
            ProductFamilies result = new ProductFamilies();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETPRODUCTFAMILIES);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@Name", name.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newProductFamily(reader));
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

        private ProductFamily newProductFamily(IDataRecord record)
        {
            return new ProductFamily()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                NameSpeed = record["NameSpeed"].ToStringSafely(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
            };
        }
    }
}
