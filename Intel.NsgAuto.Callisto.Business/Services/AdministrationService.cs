using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class AdministrationService
    {
        public string GetPreferredRole(string userId)
        {
            return new AdministrationDataContext().GetPreferredRole(userId);
        }

        public AdministrationResult SavePreferredRole(string userId, string preferredRole)
        {
            return new AdministrationDataContext().SavePreferredRole(userId, preferredRole);
        }
    }
}
