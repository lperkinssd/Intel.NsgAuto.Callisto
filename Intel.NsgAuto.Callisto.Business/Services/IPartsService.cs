using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public interface IPartsService
    {
        Part Get(string userId, int Id);
        Parts GetAll(string userId, int? productId);
    }
}
