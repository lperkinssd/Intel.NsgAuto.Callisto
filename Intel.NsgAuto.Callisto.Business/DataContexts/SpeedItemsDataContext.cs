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
    public class SpeedItemsDataContext
    {
        public SpeedItem Get(string userId, string itemId)
        {
            return get(userId, itemId);
        }

        public SpeedItemDetailsV2Element GetItemDetailV2Record(string userId, string itemId)
        {
            SpeedItemDetailsV2Elements items = getItemDetailV2Records(userId, itemId: itemId);
            if (items.Count > 0) return items[0];
            return null;
        }

        public SpeedItemDetailsV2Elements GetItemDetailV2Records(string userId, string recordType)
        {
            return getItemDetailV2Records(userId, recordType: recordType);
        }

        public SpeedItemCharacteristicDetailsV2Element GetItemCharacteristicDetailV2Record(string userId, int characteristicId)
        {
            SpeedItemCharacteristicDetailsV2Elements items = getItemCharacteristicDetailV2Records(userId, characteristicId: characteristicId);
            if (items.Count > 0) return items[0];
            return null;
        }

        public SpeedItemCharacteristicDetailsV2Elements GetItemCharacteristicDetailV2Records(string userId, string itemId)
        {
            return getItemCharacteristicDetailV2Records(userId, itemId: itemId);
        }

        private SpeedItem get(string userId, string itemId)
        {
            SpeedItem result = null;
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_GETSPEEDITEM);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@ItemId", itemId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        result = newItem(reader);

                        reader.NextResult();
                        result.Characteristics = new SpeedItemCharacteristicDetailsV2Elements();
                        while (reader.Read())
                        {
                            result.Characteristics.Add(newItemCharacteristicDetailsV2Element(reader));
                        }

                        reader.NextResult();
                        result.ParentItems = new SpeedAssociatedItems();
                        while (reader.Read())
                        {
                            result.ParentItems.Add(newAssociatedItem(reader));
                        }

                        reader.NextResult();
                        result.ChildItems = new SpeedAssociatedItems();
                        while (reader.Read())
                        {
                            result.ChildItems.Add(newAssociatedItem(reader));
                        }
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

        private SpeedItemDetailsV2Elements getItemDetailV2Records(string userId, string itemId = null, string recordType = null)
        {
            SpeedItemDetailsV2Elements result = new SpeedItemDetailsV2Elements();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_GETSPEEDITEMDETAILV2RECORDS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@ItemId", itemId.NullToDBNull());
                dataAccess.AddInputParameter("@RecordType", recordType.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newItemDetailsV2Element(reader));
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

        private SpeedItemCharacteristicDetailsV2Elements getItemCharacteristicDetailV2Records(string userId, int? characteristicId = null, string itemId = null)
        {
            SpeedItemCharacteristicDetailsV2Elements result = new SpeedItemCharacteristicDetailsV2Elements();
            ISqlDataAccess dataAccess = null;
            try
            {
                dataAccess = new DataAccessFactory().CreateSqlDataAccess(Settings.CallistoCommonConnectionString, StoredProcedures.SP_GETSPEEDITEMCHARACTERISTICDETAILV2RECORDS);
                dataAccess.AddInputParameter("@UserId", userId);
                dataAccess.AddInputParameter("@ItemId", itemId.NullToDBNull());
                dataAccess.AddInputParameter("@CharacteristicId", characteristicId.NullToDBNull());
                using (IDataReader reader = dataAccess.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(newItemCharacteristicDetailsV2Element(reader));
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

        private SpeedItem newItem(IDataRecord record)
        {
            SpeedItem result = new SpeedItem();
            populateItemDetailsV2Element(result, record);
            return result;
        }

        private SpeedItemDetailsV2Element newItemDetailsV2Element(IDataRecord record)
        {
            SpeedItemDetailsV2Element result = new SpeedItemDetailsV2Element();
            populateItemDetailsV2Element(result, record);
            return result;
        }

        private void populateItemDetailsV2Element(SpeedItemDetailsV2Element item, IDataRecord record)
        {
            item.PullDateTime = record["PullDateTime"].ToNullableDateTimeSafely().SpecifyKindUtc();
            item.ItemId = record["ItemId"].ToStringSafely();
            item.ItemDsc = record["ItemDsc"].ToStringSafely();
            item.ItemFullDsc = record["ItemFullDsc"].ToStringSafely();
            item.CommodityCd = record["CommodityCd"].ToStringSafely();
            item.ItemClassNm = record["ItemClassNm"].ToStringSafely();
            item.ItemRevisionId = record["ItemRevisionId"].ToStringSafely();
            item.EffectiveRevisionCd = record["EffectiveRevisionCd"].ToStringSafely();
            item.CurrentRevisionCd = record["CurrentRevisionCd"].ToStringSafely();
            item.ItemOwningSystemNm = record["ItemOwningSystemNm"].ToStringSafely();
            item.MakeBuyNm = record["MakeBuyNm"].ToStringSafely();
            item.NetWeightQty = record["NetWeightQty"].ToNullableDecimalSafely();
            item.UnitOfMeasureCd = record["UnitOfMeasureCd"].ToStringSafely();
            item.MaterialTypeCd = record["MaterialTypeCd"].ToStringSafely();
            item.GrossWeightQty = record["GrossWeightQty"].ToNullableDecimalSafely();
            item.UnitOfWeightDim = record["UnitOfWeightDim"].ToStringSafely();
            item.GlobalTradeIdentifierNbr = record["GlobalTradeIdentifierNbr"].ToStringSafely();
            item.BusinessUnitId = record["BusinessUnitId"].ToStringSafely();
            item.BusinessUnitNm = record["BusinessUnitNm"].ToStringSafely();
            item.LastClassChangeDt = record["LastClassChangeDt"].ToNullableDateTimeSafely().SpecifyKindUtc();
            item.OwningSystemLastModificationDtm = record["OwningSystemLastModificationDtm"].ToNullableDateTimeSafely().SpecifyKindUtc();
            item.CreateAgentId = record["CreateAgentId"].ToStringSafely();
            item.CreateDtm = record["CreateDtm"].ToNullableDateTimeSafely().SpecifyKindUtc();
            item.ChangeAgentId = record["ChangeAgentId"].ToStringSafely();
            item.ChangeDtm = record["ChangeDtm"].ToNullableDateTimeSafely().SpecifyKindUtc();
        }

        private SpeedItemCharacteristicDetailsV2Element newItemCharacteristicDetailsV2Element(IDataRecord record)
        {
            return new SpeedItemCharacteristicDetailsV2Element()
            {
                PullDateTime = record["PullDateTime"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                ItemId = record["ItemId"].ToStringSafely(),
                CharacteristicId = record["CharacteristicId"].ToNullableIntSafely(),
                CharacteristicNm = record["CharacteristicNm"].ToStringSafely(),
                CharacteristicDsc = record["CharacteristicDsc"].ToStringSafely(),
                CharacteristicValueTxt = record["CharacteristicValueTxt"].ToStringSafely(),
                CharacteristicSequenceNbr = record["CharacteristicSequenceNbr"].ToNullableIntSafely(),
                CharacteristicLastModifiedDt = record["CharacteristicLastModifiedDt"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                CharacteristicLastModifiedUsr = record["CharacteristicLastModifiedUsr"].ToStringSafely(),
                CreateAgentId = record["CreateAgentId"].ToStringSafely(),
                CreateDtm = record["CreateDtm"].ToNullableDateTimeSafely().SpecifyKindUtc(),
                ChangeAgentId = record["ChangeAgentId"].ToStringSafely(),
                ChangeDtm = record["ChangeDtm"].ToNullableDateTimeSafely().SpecifyKindUtc(),
            };
        }

        private SpeedAssociatedItem newAssociatedItem(IDataRecord record)
        {
            return new SpeedAssociatedItem()
            {
                RootItemId = record["RootItemId"].ToStringSafely(),
                ItemId = record["ItemId"].ToStringSafely(),
            };
        }
    }
}
