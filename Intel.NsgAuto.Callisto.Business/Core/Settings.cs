using Intel.NsgAuto.Shared.Extensions;
using System.Configuration;
using System.IO;

namespace Intel.NsgAuto.Callisto.Business.Core
{
    public static class Settings
    {
        static Settings()
        {
            bool valueBool;
            int valueInt;

            // exact values from config file
            AutoCheckerCriteriaAuthorUserRole = ConfigurationManager.AppSettings["AUTOCHECKERCRITERIAAUTHORROLE"].ToStringSafely();
            AutoCheckerCriteriaAuthorNpsgUserRole = ConfigurationManager.AppSettings["AUTOCHECKERCRITERIAAUTHORNPSGROLE"].ToStringSafely();
            BaseUrl = ConfigurationManager.AppSettings["BASEURL"].ToStringSafely();
            CallistoConnectionString = ConfigurationManager.ConnectionStrings["CALLISTO"].ToStringSafely();
            CallistoCommonConnectionString = ConfigurationManager.ConnectionStrings["CALLISTOCOMMON"].ToStringSafely();
            DirectoryFiles = ConfigurationManager.AppSettings["DIRECTORYFILES"].ToStringSafely();
            DirectoryLogs = ConfigurationManager.AppSettings["DIRECTORYLOGS"].ToStringSafely();
            DirectoryOutput = ConfigurationManager.AppSettings["DIRECTORYOUTPUT"].ToStringSafely();
            DirectoryOutputOptane = ConfigurationManager.AppSettings["DIRECTORYOUTPUTOPTANE"].ToStringSafely();
            DirectoryOutputNand = ConfigurationManager.AppSettings["DIRECTORYOUTPUTNAND"].ToStringSafely();
            DirectoryTemp = ConfigurationManager.AppSettings["DIRECTORYTEMP"].ToStringSafely();
            EnvironmentName = ConfigurationManager.AppSettings["ENVIRONMENTNAME"].ToStringSafely();
            FTPLocation = ConfigurationManager.AppSettings["FTPLOCATION"].ToStringSafely();
            OdmSLotIOGPickupLocation = ConfigurationManager.AppSettings["ODMSLOTIOGPICKUPLOCATION"].ToStringSafely();
            OdmSLotNPSGPickupLocation = ConfigurationManager.AppSettings["ODMSLOTNPSGPICKUPLOCATION"].ToStringSafely();
            ODMEmailListOptane = ConfigurationManager.AppSettings["ODMEMAILLISTOPTANE"].ToStringSafely();
            ODMEmailListNand = ConfigurationManager.AppSettings["ODMEMAILLISTNAND"].ToStringSafely();
            ODMMailSubject = ConfigurationManager.AppSettings["ODMMAILSUBJECT"].ToStringSafely();
            OdmMatAuthorUserRole = ConfigurationManager.AppSettings["ODMMATAUTHORUSERROLE"].ToStringSafely();
            OdmMatAuthorNpsgUserRole = ConfigurationManager.AppSettings["ODMMATAUTHORUSERNPSGROLE"].ToStringSafely();
            OdmPrfAuthorUserRole = ConfigurationManager.AppSettings["ODMPRFAUTHORUSERROLE"].ToStringSafely();
            OdmPrfAuthorNpsgUserRole = ConfigurationManager.AppSettings["ODMPRFAUTHORUSERNPSGROLE"].ToStringSafely();
            CallistoOptaneUserRole = ConfigurationManager.AppSettings["CALLISTOOPTANEUSERROLE"].ToStringSafely();
            CallistoNandUserRole = ConfigurationManager.AppSettings["CALLISTONANDUSERROLE"].ToStringSafely();
            OdmQualFilterAuthorUserRole = ConfigurationManager.AppSettings["ODMQUALFILTERAUTHORROLE"].ToStringSafely();
            OdmQualFilterAuthorNpsgUserRole = ConfigurationManager.AppSettings["ODMQUALFILTERAUTHORNPSGROLE"].ToStringSafely();
            OsatCriteriaAuthorUserRole = ConfigurationManager.AppSettings["OSATCRITERIAAUTHORROLE"].ToStringSafely();
            OsatCriteriaAuthorNpsgUserRole = ConfigurationManager.AppSettings["OSATCRITERIAAUTHORNPSGROLE"].ToStringSafely();

            OsatCriteriaEmailsDisabled = bool.TryParse(ConfigurationManager.AppSettings["OSATCRITERIAEMAILSDISABLED"].ToStringSafely()?.ToLower(), out valueBool) ? valueBool : false;
            OsatPasAuthorUserRole = ConfigurationManager.AppSettings["OSATPASAUTHORROLE"].ToStringSafely();
            OsatPasAuthorNpsgUserRole = ConfigurationManager.AppSettings["OSATPASAUTHORNPSGROLE"].ToStringSafely();
            ProxyServer = ConfigurationManager.AppSettings["PROXYSERVER"].ToStringSafely();
            ProxyPort = int.TryParse(ConfigurationManager.AppSettings["PROXYPORT"].ToStringSafely(), out valueInt) ? valueInt : 911;
            RelativePathErrors = ConfigurationManager.AppSettings["RELATIVEPATHTERRORS"].ToStringSafely();
            RelativePathOdmQfOutput = ConfigurationManager.AppSettings["RELATIVEPATHTODMQFOUTPUT"].ToStringSafely();
            RelativePathOsatPasVersion = ConfigurationManager.AppSettings["RELATIVEPATHTOSATPASVERSION"].ToStringSafely();
            RelativePathOsatQfExport = ConfigurationManager.AppSettings["RELATIVEPATHTOSATQFEXPORT"].ToStringSafely();
            RelativePathOsatQfImport = ConfigurationManager.AppSettings["RELATIVEPATHTOSATQFIMPORT"].ToStringSafely();
            RelativePathOsatQfOutput = ConfigurationManager.AppSettings["RELATIVEPATHTOSATQFOUTPUT"].ToStringSafely();
            ScheduledServiceAccount = ConfigurationManager.AppSettings["SCHEDULEDSERVICEACCOUNT"].ToStringSafely();
            SmtpServer = ConfigurationManager.AppSettings["SMTPSERVER"].ToStringSafely();
            SmtpServerPort = int.TryParse(ConfigurationManager.AppSettings["SMTPSERVERPORT"].ToStringSafely(), out valueInt) ? valueInt : 25;
            SuperUserRole = ConfigurationManager.AppSettings["SUPERUSERROLE"].ToStringSafely();
            SupportEmailAddress = ConfigurationManager.AppSettings["SUPPORTEMAILADDRESS"].ToStringSafely();
            SystemEmailAddress = ConfigurationManager.AppSettings["SYSTEMEMAILADDRESS"].ToStringSafely();

            // calculated values
            try
            {
                PathErrors = Path.Combine(DirectoryLogs, RelativePathErrors);
            }
            catch { }
            try
            {
                ODMFilterOutputPath = Path.Combine(DirectoryOutput, RelativePathOdmQfOutput);
                ODMFilterOutputPathOptane = DirectoryOutputOptane;
                ODMFilterOutputPathNand = DirectoryOutputNand;
            }
            catch { }
            try
            {
                PathOsatPasVersion = Path.Combine(DirectoryFiles, RelativePathOsatPasVersion);
            }
            catch { }
            try
            {
                PathOsatQfExport = Path.Combine(DirectoryFiles, RelativePathOsatQfExport);
            }
            catch { }
            try
            {
                PathOsatQfImport = Path.Combine(DirectoryFiles, RelativePathOsatQfImport);
            }
            catch { }
            try
            {
                PathOsatQfOutput = Path.Combine(DirectoryOutput, RelativePathOsatQfOutput);
            }
            catch { }
        }

        public static string AutoCheckerCriteriaAuthorUserRole { get; }
        public static string AutoCheckerCriteriaAuthorNpsgUserRole { get; }


        public static string BaseUrl { get; }

        public static string CallistoConnectionString { get; }

        public static string CallistoCommonConnectionString { get; }

        public static string DirectoryFiles { get; }

        public static string DirectoryLogs { get; }

        public static string DirectoryOutput { get; }
        public static string DirectoryOutputOptane { get; }
        public static string DirectoryOutputNand { get; }

        public static string DirectoryTemp { get; }

        public static string EnvironmentName { get; }

        public static string FTPLocation { get; }
        public static string OdmSLotIOGPickupLocation { get; }   
        public static string OdmSLotNPSGPickupLocation { get; }         
        public static string ODMEmailListOptane { get; }
        public static string ODMEmailListNand { get; }

        public static string ODMFilterOutputPath { get; }
        public static string ODMFilterOutputPathOptane { get; }
        public static string ODMFilterOutputPathNand { get; }
        public static string ODMMailSubject { get; }

        public static string OdmMatAuthorUserRole { get; }

        public static string OdmMatAuthorNpsgUserRole { get; }

        public static string OdmPrfAuthorUserRole { get; }

        public static string OdmPrfAuthorNpsgUserRole { get; }
        public static string CallistoOptaneUserRole { get; }

        public static string CallistoNandUserRole { get; }

        public static string OdmQualFilterAuthorUserRole { get; }
        public static string OdmQualFilterAuthorNpsgUserRole { get; }


        public static string OsatCriteriaAuthorUserRole { get; }
        public static string OsatCriteriaAuthorNpsgUserRole { get; }

        public static bool OsatCriteriaEmailsDisabled { get; }

        public static string OsatPasAuthorUserRole { get; }

        public static string OsatPasAuthorNpsgUserRole { get; }

        public static string PathErrors { get; }

        public static string PathOsatQfOutput { get; }

        public static string PathOsatQfExport { get; }

        public static string PathOsatQfImport { get; }

        public static string PathOsatPasVersion { get; }

        public static string ProxyServer { get; }

        public static int ProxyPort { get; }

        public static string RelativePathErrors { get; }

        public static string RelativePathOdmQfOutput { get; }

        public static string RelativePathOsatPasVersion { get; }

        public static string RelativePathOsatQfExport { get; }

        public static string RelativePathOsatQfImport { get; }

        public static string RelativePathOsatQfOutput { get; }

        public static string ScheduledServiceAccount { get; }

        public static string SmtpServer { get; }

        public static int SmtpServerPort { get; }

        public static string SuperUserRole { get; }

        public static string SupportEmailAddress { get; }

        public static string SystemEmailAddress { get; }

        public static string GetOdmEmailRecipients(string odmName, string process)
        {
            return ConfigurationManager.AppSettings[$"ODMEMAILLIST_{process}_{odmName.ToUpper()}"].ToStringSafely();
        }
    }
}
