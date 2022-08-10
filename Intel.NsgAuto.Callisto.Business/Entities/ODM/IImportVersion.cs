using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface IImportVersion
    {
        int Id { get; set; }
        int Version { get; set; }
        string WorkWeek { get; set; }
        bool IsActive { get; set; }
        bool IsPOR { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
    }
}
