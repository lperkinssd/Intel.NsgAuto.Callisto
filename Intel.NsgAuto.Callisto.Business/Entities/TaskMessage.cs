using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class TaskMessage : ITaskMessage
    {
        public long Id { get; set; }
        public long TaskId { get; set; }
        public string Type { get; set; }
        public string Text { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
