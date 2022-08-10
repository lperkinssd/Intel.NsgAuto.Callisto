using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public interface IProductsDataContext
    {
        Products GetAll(string userId);
        Product Get(string userId, int Id);
    }
}