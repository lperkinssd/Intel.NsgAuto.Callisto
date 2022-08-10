using System;
using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Logging;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Services;

namespace Intel.NsgAuto.Callisto.App.OdmQfSLotTracker
{
    class Program
    {
        public static string[] ODMs = {"PTI", "PEGATRON", "KINGSTON" };

        static int Main(string[] args)
        {
            log4net.Config.XmlConfigurator.Configure();

            if (args == null || args.Length != 1)
            {
                Console.WriteLine("Usage: Intel.NsgAuto.Callisto.App.OdmQfSLotTracker IOG | Intel.NsgAuto.Callisto.App.OdmQfSLotTracker NPSG");
                return -2;
            }

            string targetCompany = args[0];
            if (targetCompany != "IOG" && targetCompany != "NPSG")
            {
                Console.WriteLine("Usage: Intel.NsgAuto.Callisto.App.OdmQfSLotTracker IOG | Intel.NsgAuto.Callisto.App.OdmQfSLotTracker NPSG");
                return -2;
            }

            try
            {
                CompanyType companyType = (targetCompany == "IOG") ? CompanyType.Iog : CompanyType.Npsg;

                OdmService service = new OdmService();
                service.ProcessRemovableSLots(Settings.ScheduledServiceAccount, companyType);
                return 0;
            }

            catch (Exception ex)
            {
                Log.Error(targetCompany + " - Error occurred during processing Removable SLots: ", ex);
                return -1;
            }           
        }
    }
}
