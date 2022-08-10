using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public interface IProductsService
    {
        Products GetAll(string userId);
        Product Get(string userId, int Id);
    }
}