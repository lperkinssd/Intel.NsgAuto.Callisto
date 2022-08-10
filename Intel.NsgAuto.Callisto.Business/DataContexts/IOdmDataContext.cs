using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public interface IOdmDataContext
    {
        void ProcessRemovableSLots(string userId, string procName, string pickupLocation, string logPrefix);
        CheckProhibitedScenarioRunTimeResponse CheckProhibitedScenarioRunTime(string userId, string process);
    }
}
