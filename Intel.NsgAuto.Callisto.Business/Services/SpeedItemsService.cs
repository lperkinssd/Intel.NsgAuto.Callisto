using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities.Speed;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class SpeedItemsService
    {
        public SpeedItem Get(string userId, string itemId)
        {
            return new SpeedItemsDataContext().Get(userId, itemId);
        }

        public SpeedItemDetailsV2Element GetItemDetailV2Record(string userId, string itemId)
        {
            return new SpeedItemsDataContext().GetItemDetailV2Record(userId, itemId);
        }

        public SpeedItemDetailsV2Elements GetItemDetailV2Records(string userId, string recordType)
        {
            return new SpeedItemsDataContext().GetItemDetailV2Records(userId, recordType);
        }

        public SpeedItemCharacteristicDetailsV2Elements GetItemCharacteristicDetailV2Records(string userId, string itemId)
        {
            return new SpeedItemsDataContext().GetItemCharacteristicDetailV2Records(userId, itemId);
        }
    }
}
