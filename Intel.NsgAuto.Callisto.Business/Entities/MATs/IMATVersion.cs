using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public interface IMATVersion
    {
        int Id { get; set; }
        int Version { get; set; }
        bool IsActive { get; set; }
        IdAndName Status { get; set; }
        bool IsPOR { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
