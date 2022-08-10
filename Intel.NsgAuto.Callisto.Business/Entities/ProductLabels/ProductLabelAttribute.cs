using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ProductLabels
{
    public class ProductLabelAttribute : IProductLabelAttribute
    {
        public long Id { get; set; }
        public long ProductLabelId { get; set; }
        public ProductLabelAttributeType AttributeType { get; set; }
        public string Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
