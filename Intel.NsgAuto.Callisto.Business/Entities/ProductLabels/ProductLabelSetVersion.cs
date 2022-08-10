using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ProductLabels
{
    public class ProductLabelSetVersion : IProductLabelSetVersion
    {
        public int Id { get; set; }
        public int Version { get; set; }
        public bool IsActive { get; set; }
        public bool IsPOR { get; set; }
        public Status Status { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
