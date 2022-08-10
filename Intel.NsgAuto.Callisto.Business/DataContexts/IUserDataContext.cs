using Intel.NsgAuto.Callisto.Business.Entities.App;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    internal interface IUserDataContext
    {
        User InitializeSession(string sessionId, User user);
    }
}