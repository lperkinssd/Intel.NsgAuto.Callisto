using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.App
{
    public interface IProcess
    {
        string Id { get; set; }
        string Name { get; set; }
        bool IsActive { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}