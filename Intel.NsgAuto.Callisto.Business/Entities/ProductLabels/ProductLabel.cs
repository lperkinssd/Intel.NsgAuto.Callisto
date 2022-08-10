using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ProductLabels
{
    public class ProductLabel
    {
        public long Id { get; set; }
        public string ProductionProductCode { get; set; }
        public ProductFamily ProductFamily { get; set; }
        public Customer Customer { get; set; }
        public ProductFamilyNameSeries ProductFamilyNameSeries { get; set; }
        public string Capacity { get; set; }
        public string ModelString { get; set; }
        public string VoltageCurrent { get; set; }
        public string InterfaceSpeed { get; set; }
        public OpalType OpalType { get; set; }
        public string KCCId { get; set; }
        public ProductLabelAttributes Attributes { get; set; }
        public string CanadianStringClass { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
