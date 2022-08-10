using Intel.NsgAuto.Callisto.Business.Applications;

namespace Intel.NsgAuto.Callisto.App.OsatQfImport
{
    class Program
    {
        static void Main(string[] args)
        {
            string directory = null;
            if (args.Length > 0) directory = args[0];
            var application = new OsatQualFilterImportApplication(directory);
            application.Start();
        }
    }
}
