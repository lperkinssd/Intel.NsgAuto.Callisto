using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface IDispositionVersion
    {
        int Version { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}