using Intel.NsgAuto.Callisto.Business.Applications;

namespace Intel.NsgAuto.Callisto.App.OsatQfExport
{
    class Program
    {
        static void Main(string[] args)
        {
            var application = new OsatQualFilterExportApplication();
            application.Start();
        }
    }
}
