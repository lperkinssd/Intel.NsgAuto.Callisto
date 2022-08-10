namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class TaskType : ITaskType
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int? ThresholdTimeLimit { get; set; }
        public string CodeLocation { get; set; }
    }
}
