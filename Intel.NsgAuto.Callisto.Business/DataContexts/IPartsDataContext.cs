using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public interface IPartsDataContext
    {
        Parts GetAll(string userId, int? productId);
        Part Get(string userId, int Id);
    }
}
