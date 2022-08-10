using Intel.NsgAuto.Callisto.Business.Entities.App;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public interface IFrameworkService
    {
        User InitializeSession(string sessionId, User user);
    }
}