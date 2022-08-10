using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class FrameworkService: IFrameworkService
    {
        public User InitializeSession(string sessionId, User user)
        {
            return new UserDataContext().InitializeSession(sessionId, user);
        }
    }
}
