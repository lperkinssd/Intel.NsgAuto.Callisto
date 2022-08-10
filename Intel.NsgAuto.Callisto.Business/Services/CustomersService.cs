using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class CustomersService
    {
        public Customer Get(string userId, int id)
        {
            return new CustomersDataContext().Get(userId, id);
        }

        public Customers GetAll(string userId)
        {
            return new CustomersDataContext().GetAll(userId);
        }
    }
}
