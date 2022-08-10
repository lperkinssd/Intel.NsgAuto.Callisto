using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public interface ITask : IReadOnlyTask
    {
        new long Id { get; set; }
        new TaskType TaskType { get; set; }
        new string Status { get; set; }
        new DateTime StartDateTime { get; set; }
        new DateTime? EndDateTime { get; set; }
        new DateTime? AbortDateTime { get; set; }
        new DateTime? ResolvedDateTime { get; set; }
        new string ResolvedBy { get; set; }
        new byte? ProgressPercent { get; set; }
        new string ProgressText { get; set; }
    }
}
