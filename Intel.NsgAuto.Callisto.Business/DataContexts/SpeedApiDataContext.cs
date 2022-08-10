using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities.Speed;
using Intel.NsgAuto.DataAccess;
using Intel.NsgAuto.DataAccess.Sql;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Data;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public class SpeedApiDataContext
    {
        public SpeedAccessToken CreateAccessToken(string accessToken, string tokenType, int secondsToExpiration, string userId)
        {
            SpeedAccessToken result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_CREATESPEEDACCESSTOKEN);
                dataAccess.AddInputParameter("@AccessToken", accessToken.NullToDBNull());
                dataAccess.AddInputParameter("@TokenType", tokenType.NullToDBNull());
                dataAccess.AddInputParameter("@SecondsToExpiration", secondsToExpiration.NullToDBNull());
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    reader.Read(); // it should always return the token created, so throw exception if this doesn't work
                    result = newAccessToken(reader);
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

        public SpeedAccessToken GetUnexpiredAccessToken(string userId)
        {
            SpeedAccessToken result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoConnectionString, StoredProcedures.SP_GETUNEXPIREDSPEEDACCESSTOKEN);
                dataAccess.AddInputParameter("@UserId", userId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newAccessToken(reader);
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

        private SpeedAccessToken newAccessToken(IDataRecord record)
        {
            return new SpeedAccessToken()
            {
                Id = record["Id"].ToIntegerSafely(),
                AccessToken = record["AccessToken"].ToStringSafely(),
                TokenType = record["TokenType"].ToStringSafely(),
                ExpiresOn = record["ExpiresOn"].ToDateTimeSafely().SpecifyKindUtc(),
                CreatedBy = record["CreatedBy"].ToStringSafely(),
                CreatedOn = record["CreatedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                UpdatedBy = record["UpdatedBy"].ToStringSafely(),
                UpdatedOn = record["UpdatedOn"].ToDateTimeSafely().SpecifyKindUtc()
            };
        }
    }
}
