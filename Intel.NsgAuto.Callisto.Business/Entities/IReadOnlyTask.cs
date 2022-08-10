using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public interface IReadOnlyTask
    {
        long Id { get; }
        IReadOnlyTaskType TaskType { get; }
        string Status { get; }
        DateTime StartDateTime { get; }
        DateTime? EndDateTime { get; }
        DateTime? AbortDateTime { get; }
        DateTime? ResolvedDateTime { get; }
        string ResolvedBy { get; set; }
        byte? ProgressPercent { get; set; }
        string ProgressText { get; set; }
    }
}
