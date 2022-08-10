using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class Task : ITask
    {
        public long Id { get; set; }
        public TaskType TaskType { get; set; }
        IReadOnlyTaskType IReadOnlyTask.TaskType
        {
            get
            {
                return TaskType;
            }
        }
        public string Status { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime? EndDateTime { get; set; }
        public DateTime? AbortDateTime { get; set; }
        public DateTime? ResolvedDateTime { get; set; }
        public string ResolvedBy { get; set; }
        public byte? ProgressPercent { get; set; }
        public string ProgressText { get; set; }
        public int ElapsedMinutes { get; set; }
        public bool Problematic { get; set; }
    }
}
