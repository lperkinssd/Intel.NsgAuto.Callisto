using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class ProductsService: IProductsService
    {
        public Products GetAll(string userId)
        {
            return new ProductsDataContext().GetAll(userId);
        }

        public Product Get(string userId, int Id)
        {
            return new ProductsDataContext().Get(userId, Id);
        }
    }
}
