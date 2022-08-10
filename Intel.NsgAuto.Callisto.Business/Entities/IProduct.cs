using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public interface IProduct
    {
        int Id { get; set; }
        string Name { get; set; }
        bool IsActive { get; set; }
        DesignFamily DesignFamily { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}