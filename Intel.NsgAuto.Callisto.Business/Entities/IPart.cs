using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public interface IPart
    {
        int Id { get; set; }
        string IntelLevel1PartName { get; set; }
        bool IsActive { get; set; }
        string IntelProductName { get; set; }
        string PRQStage { get; set; }
        string MM { get; set; }
        string IntelPartName { get; set; }
        string TestUPI { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
