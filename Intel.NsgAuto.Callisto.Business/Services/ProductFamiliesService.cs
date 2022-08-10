using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class ProductFamiliesService
    {
        public ProductFamily Get(string userId, int id)
        {
            return new ProductFamiliesDataContext().Get(userId, id);
        }

        public ProductFamilies GetAll(string userId)
        {
            return new ProductFamiliesDataContext().GetAll(userId);
        }
    }
}
