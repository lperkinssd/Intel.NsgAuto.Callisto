using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;
using Intel.NsgAuto.Callisto.Business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.App.OdmQfPublisher
{
    class Program
    {
        static int Main(string[] args)
        {
            int retval = -1;
            Result result = null;

            try
            {
                OdmService service = new OdmService();
                //result = new OdmService().PublishScenario(Settings.ScheduledServiceAccount, null);
                result = new OdmService().PublishScenarioNand(Settings.ScheduledServiceAccount, null);
                result = new OdmService().PublishScenarioOptane(Settings.ScheduledServiceAccount, null);
                retval = 1;
            }
            catch (Exception ex)
            {
                result = new Result();
                result.Messages = new List<string>();
                result.Messages.Add(ex.Message.ToString());
            }

            Console.WriteLine(result.Messages[0].ToString());

            return retval;
        }
    }
}
