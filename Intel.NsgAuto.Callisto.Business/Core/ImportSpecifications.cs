using Intel.NsgAuto.Callisto.Business.Entities.Osat;

namespace Intel.NsgAuto.Callisto.Business.Core
{
    public static class ImportSpecifications
    {
        public static PasVersionImportSpecification OsatPas { get; }

        static ImportSpecifications()
        {
            OsatPas = new PasVersionImportSpecification();
        }

        public static class ProductLabels
        {
            public static int HeaderRows = 1;
            public static class ColumnNames
            {
                public const string ProductFamily = "Product Family";
                public const string Customer = "Customer";
                public const string ProductionProductCode = "Product Code";
                public const string ProductFamilyNameSeries = "Product Family Name Series";
                public const string Capacity = "Capacity";
                public const string ModelString = "Model String";
                public const string VoltageCurrent = "Voltage/Current";
                public const string InterfaceSpeed = "Interface Speed";
                public const string OpalType = "Opal Type";
                public const string KCCId = "KCC ID";
                public const string CanadianStringClass = "Canadian String Class";
                public const string DellPN = "DELL PN";
                public const string DellPPIDRev = "DELL PPID Rev";
                public const string DellEMCPN = "DELL EMC PN";
                public const string DellEMCPNRev = "DELL EMC PN Rev";
                public const string HpePN = "HPE PN";
                public const string HpeModelString = "HPE Model String";
                public const string HpeGPN = "HPE GPN";
                public const string HpeCTAssemblyCode = "HPE CT# Assembly Code";
                public const string HpeCTRev = "HPE CT# Rev";
                public const string HpPN = "HP PN";
                public const string HpCTAssemblyCode = "HP CT# Assembly Code";
                public const string HpCTRev = "HP CT# Rev";
                public const string LenovoFRU = "Lenovo FRU";
                public const string Lenovo8ScodePN = "Lenovo 8S Code PN";
                public const string Lenovo8ScodeBCH = "Lenovo 8S Code BCH";
                public const string Lenovo11ScodePN = "Lenovo 11S Code PN";
                public const string Lenovo11ScodeRev = "Lenovo 11S Code Rev";
                public const string Lenovo11ScodePN10 = "Lenovo 11S Code PN 10";
                public const string OracleProductIdentifer = "Oracle Product Identifer";
                public const string OraclePN = "Oracle PN";
                public const string OraclePNRev = "Oracle PN Rev";
                public const string OracleModel = "Oracle Model";
                public const string OraclePkgPN = "Oracle PKG PN";
                public const string OracleMarketingPN = "Oracle Marketing PN";
                public const string CiscoPN = "Cisco PN";
                public const string FujistuCSL = "Fujistu CSL";
                public const string Fujitsu106PN = "Fujitsu 106 PN";
                public const string HitachiModelName = "Hitachi Model Name";
            }

            public static string FieldToColumnName(string fieldName)
            {
                if (fieldName == "ProductFamily") return ColumnNames.ProductFamily;
                else if (fieldName == "Customer") return ColumnNames.Customer;
                else if (fieldName == "ProductionProductCode") return ColumnNames.ProductionProductCode;
                else if (fieldName == "ProductFamilyNameSeries") return ColumnNames.ProductFamilyNameSeries;
                else if (fieldName == "Capacity") return ColumnNames.Capacity;
                else if (fieldName == "ModelString") return ColumnNames.ModelString;
                else if (fieldName == "VoltageCurrent") return ColumnNames.VoltageCurrent;
                else if (fieldName == "InterfaceSpeed") return ColumnNames.InterfaceSpeed;
                else if (fieldName == "OpalType") return ColumnNames.OpalType;
                else if (fieldName == "KCCId") return ColumnNames.KCCId;
                else if (fieldName == "CanadianStringClass") return ColumnNames.CanadianStringClass;
                else if (fieldName == "DellPN") return ColumnNames.DellPN;
                else if (fieldName == "DellPPIDRev") return ColumnNames.DellPPIDRev;
                else if (fieldName == "DellEMCPN") return ColumnNames.DellEMCPN;
                else if (fieldName == "DellEMCPNRev") return ColumnNames.DellEMCPNRev;
                else if (fieldName == "HpePN") return ColumnNames.HpePN;
                else if (fieldName == "HpeModelString") return ColumnNames.HpeModelString;
                else if (fieldName == "HpeGPN") return ColumnNames.HpeGPN;
                else if (fieldName == "HpeCTAssemblyCode") return ColumnNames.HpeCTAssemblyCode;
                else if (fieldName == "HpeCTRev") return ColumnNames.HpeCTRev;
                else if (fieldName == "HpPN") return ColumnNames.HpPN;
                else if (fieldName == "HpCTAssemblyCode") return ColumnNames.HpCTAssemblyCode;
                else if (fieldName == "HpCTRev") return ColumnNames.HpCTRev;
                else if (fieldName == "LenovoFRU") return ColumnNames.LenovoFRU;
                else if (fieldName == "Lenovo8ScodePN") return ColumnNames.Lenovo8ScodePN;
                else if (fieldName == "Lenovo8ScodeBCH") return ColumnNames.Lenovo8ScodeBCH;
                else if (fieldName == "Lenovo11ScodePN") return ColumnNames.Lenovo11ScodePN;
                else if (fieldName == "Lenovo11ScodeRev") return ColumnNames.Lenovo11ScodeRev;
                else if (fieldName == "Lenovo11ScodePN10") return ColumnNames.Lenovo11ScodePN10;
                else if (fieldName == "OracleProductIdentifer") return ColumnNames.OracleProductIdentifer;
                else if (fieldName == "OraclePN") return ColumnNames.OraclePN;
                else if (fieldName == "OraclePNRev") return ColumnNames.OraclePNRev;
                else if (fieldName == "OracleModel") return ColumnNames.OracleModel;
                else if (fieldName == "OraclePkgPN") return ColumnNames.OraclePkgPN;
                else if (fieldName == "OracleMarketingPN") return ColumnNames.OracleMarketingPN;
                else if (fieldName == "CiscoPN") return ColumnNames.CiscoPN;
                else if (fieldName == "FujistuCSL") return ColumnNames.FujistuCSL;
                else if (fieldName == "Fujitsu106PN") return ColumnNames.Fujitsu106PN;
                else if (fieldName == "HitachiModelName") return ColumnNames.HitachiModelName;
                return fieldName;
            }
        }

        public static class MATs
        {
            public static int HeaderRows = 1;
            public static class ColumnNames
            {
                public const string SSDId = "SSD_Id";
                public const string DesignId = "Design_Id";
                public const string Scode = "Scode";
                public const string CellRevision = "Cell_Revision";
                public const string MajorProbeProgramRevision = "Major_Probe_Program_Revision";
                public const string ProbeRevision = "Probe_Revision";
                public const string BurnTapeRevision = "Burn_Tape_Revision";
                public const string CustomTestingReqd = "Custom_Testing_Reqd";
                public const string CustomTestingReqd2 = "Custom_Testing_Reqd2";
                public const string ProductGrade = "Product_Grade";
                public const string PrbConvId = "Prb_Conv_Id";
                public const string FabExcrId = "Fab_Excr_Id";
                public const string FabConvId = "Fab_Conv_Id";
                public const string ReticleWaveId = "Reticle_Wave_Id";
                public const string MediaIPN = "Media_IPN";
                public const string FabFacility = "Fab_Facility";
                public const string MediaType = "Media_Type";
                public const string DeviceName = "Device_Name";
            }

            public static string FieldToColumnName(string fieldName)
            {
                if (fieldName == "SSDId") return "SSD Id";
                else if (fieldName == "DesignId") return "Design Id";
                else if (fieldName == "Scode") return "Scode";
                else if (fieldName == "CellRevision") return "Cell Revision";
                else if (fieldName == "MajorProbeProgramRevision") return "Major Probe Program Revision";
                else if (fieldName == "ProbeRevision") return "Probe Revision";
                else if (fieldName == "BurnTapeRevision") return "Burn Tape Revision";
                else if (fieldName == "CustomTestingReqd") return "Custom Testing Reqd";
                else if (fieldName == "CustomTestingReqd2") return "Custom Testing Reqd2";
                else if (fieldName == "ProductGrade") return "Product Grade";
                else if (fieldName == "PrbConvId") return "Prb Conv Id";
                else if (fieldName == "FabExcrId") return "Fab Excr Id";
                else if (fieldName == "FabConvId") return "Fab Conv Id";
                else if (fieldName == "ReticleWaveId") return "Reticle Wave Id";
                else if (fieldName == "MediaIPN") return "Media IPN";
                else if (fieldName == "FabFacility") return "Fab Facility";
                else if (fieldName == "MediaType") return "Media Type";
                else if (fieldName == "DeviceName") return "Device Name";
                return fieldName;
            }
        }

        public static class OdmMATs
        {
            public static int HeaderRows = 1;
            public static class ColumnNames
            {
                public const string Ww = "WW";
                public const string SSDId = "SSD_Id";
                public const string DesignId = "Design_Id";
                public const string Scode = "Scode";
                public const string CellRevision = "Cell_Revision";
                public const string MajorProbeProgramRevision = "Major_Probe_Program_Revision";
                public const string ProbeRevision = "Probe_Revision";
                public const string BurnTapeRevision = "Burn_Tape_Revision";
                public const string CustomTestingReqd = "Custom_Testing_Reqd";
                public const string CustomTestingReqd2 = "Custom_Testing_Reqd2";
                public const string ProductGrade = "Product_Grade";
                public const string PrbConvId = "Prb_Conv_Id";
                public const string FabExcrId = "Fab_Excr_Id";
                public const string FabConvId = "Fab_Conv_Id";
                public const string ReticleWaveId = "Reticle_Wave_Id";
                public const string MediaIPN = "Media_IPN";
                public const string FabFacility = "Fab_Facility";
                public const string MediaType = "Media_Type";
                public const string DeviceName = "Device_Name";
            }

            public static string FieldToColumnName(string fieldName)
            {
                if (fieldName == "WW") return "Work Week";
                else if (fieldName == "SSDId") return "SSD Id";
                else if (fieldName == "DesignId") return "Design Id";
                else if (fieldName == "Scode") return "Scode";
                else if (fieldName == "CellRevision") return "Cell Revision";
                else if (fieldName == "MajorProbeProgramRevision") return "Major Probe Program Revision";
                else if (fieldName == "ProbeRevision") return "Probe Revision";
                else if (fieldName == "BurnTapeRevision") return "Burn Tape Revision";
                else if (fieldName == "CustomTestingReqd") return "Custom Testing Reqd";
                else if (fieldName == "CustomTestingReqd2") return "Custom Testing Reqd2";
                else if (fieldName == "ProductGrade") return "Product Grade";
                else if (fieldName == "PrbConvId") return "Prb Conv Id";
                else if (fieldName == "FabExcrId") return "Fab Excr Id";
                else if (fieldName == "FabConvId") return "Fab Conv Id";
                else if (fieldName == "ReticleWaveId") return "Reticle Wave Id";
                else if (fieldName == "MediaIPN") return "Media IPN";
                else if (fieldName == "FabFacility") return "Fab Facility";
                else if (fieldName == "MediaType") return "Media Type";
                else if (fieldName == "DeviceName") return "Device Name";
                return fieldName;
            }
        }

        public static class OdmPRFs
        {
            public static int HeaderRows = 1;
            public static class ColumnNames
            {
                public const string Ww = "WW";
                public const string ODMDescription = "odm_desc";
                public const string SSDFamilyName = "ssd_family_name";
                public const string MMNumber = "mm_number";
                public const string ProductCode = "Product_Code";
                public const string SSDName = "ssd_name";
            }

            public static string FieldToColumnName(string fieldName)
            {
                if (fieldName == "WW") return "Work Week";
                else if (fieldName == "ODMDescription") return "ODM Description";
                else if (fieldName == "SSDFamilyName") return "SSD Family Name";
                else if (fieldName == "MMNumber") return "MM Number";
                else if (fieldName == "ProductCode") return "Product Code";
                else if (fieldName == "SSDName") return "SSD Name";
                return fieldName;
            }

        }
    }
}
