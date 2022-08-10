using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public interface ITaskMessage
    {
        long Id { get; set; }
        long TaskId { get; set; }
        string Type { get; set; }
        string Text { get; set; }
        DateTime CreatedOn { get; set; }
    }
}
