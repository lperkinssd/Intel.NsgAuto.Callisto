namespace Intel.NsgAuto.Callisto.Business.Entities.ProductLabels
{
    public interface IProductLabelImport
    {
        int RecordNumber { get; set; }
        string ProductFamily { get; set; }
        string Customer { get; set; }
        string ProductionProductCode { get; set; }
        string ProductFamilyNameSeries { get; set; }
        string Capacity { get; set; }
        string ModelString { get; set; }
        string VoltageCurrent { get; set; }
        string InterfaceSpeed { get; set; }
        string OpalType { get; set; }
        string KCCId { get; set; }
        string CanadianStringClass { get; set; }
        string DellPN { get; set; }
        string DellPPIDRev { get; set; }
        string DellEMCPN { get; set; }
        string DellEMCPNRev { get; set; }
        string HpePN { get; set; }
        string HpeModelString { get; set; }
        string HpeGPN { get; set; }
        string HpeCTAssemblyCode { get; set; }
        string HpeCTRev { get; set; }
        string HpPN { get; set; }
        string HpCTAssemblyCode { get; set; }
        string HpCTRev { get; set; }
        string LenovoFRU { get; set; }
        string Lenovo8ScodePN { get; set; }
        string Lenovo8ScodeBCH { get; set; }
        string Lenovo11ScodePN { get; set; }
        string Lenovo11ScodeRev { get; set; }
        string Lenovo11ScodePN10 { get; set; }
        string OracleProductIdentifer { get; set; }
        string OraclePN { get; set; }
        string OraclePNRev { get; set; }
        string OracleModel { get; set; }
        string OraclePkgPN { get; set; }
        string OracleMarketingPN { get; set; }
        string CiscoPN { get; set; }
        string FujistuCSL { get; set; }
        string Fujitsu106PN { get; set; }
        string HitachiModelName { get; set; }
    }
}
