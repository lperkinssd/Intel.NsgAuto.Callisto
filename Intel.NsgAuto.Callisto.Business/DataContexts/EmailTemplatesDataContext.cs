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
    public class EmailTemplatesDataContext
    {
        public EmailTemplate Get(int id)
        {
            return get(id: id);
        }

        public EmailTemplate Get(string name)
        {
            return get(name: name);
        }

        private EmailTemplate get(int? id = null, string name = null)
        {
            EmailTemplate result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETEMAILTEMPLATES);
                dataAccess.AddInputParameter("@Id", id.NullToDBNull());
                dataAccess.AddInputParameter("@Name", name.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newEmailTemplate(reader);
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

        private EmailTemplate newEmailTemplate(IDataRecord record)
        {
            return new EmailTemplate()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                IsHtml = record["IsHtml"].ToStringSafely().ToBooleanSafely(),
                Subject = record["Subject"].ToStringSafely(),
                BodyXsl = new EmailTemplateBodyXsl()
                {
                    Id = record["BodyXslId"].ToIntegerSafely(),
                    Name = record["BodyXslName"].ToStringSafely(),
                    Value = record["BodyXslValue"].ToStringSafely(),
                },
                BodyXml = record["BodyXml"].ToStringSafely(),
            };
        }
    }
}
