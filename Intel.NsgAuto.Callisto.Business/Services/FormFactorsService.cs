using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class FormFactorsService
    {
        public FormFactor Get(string userId, int id)
        {
            return new FormFactorsDataContext().Get(userId, id);
        }

        public FormFactors GetAll(string userId)
        {
            return new FormFactorsDataContext().GetAll(userId);
        }
    }
}
