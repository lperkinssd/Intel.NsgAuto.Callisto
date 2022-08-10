using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ProductLabels
{
    public interface IProductLabelSetVersion
    {
        int Id { get; set; }
        int Version { get; set; }
        bool IsActive { get; set; }
        bool IsPOR { get; set; }
        Status Status { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
