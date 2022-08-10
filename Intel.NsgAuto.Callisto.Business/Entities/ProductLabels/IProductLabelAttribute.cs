using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ProductLabels
{
    interface IProductLabelAttribute
    {
        long Id { get; set; }
        long ProductLabelId { get; set; }
        ProductLabelAttributeType AttributeType { get; set; }
        string Value { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
