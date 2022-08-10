namespace Intel.NsgAuto.Callisto.Business.Entities
{
    interface ITaskType : IReadOnlyTaskType
    {
        new int Id { get; set; }
        new string Name { get; set; }
        new int? ThresholdTimeLimit { get; set; }
        new string CodeLocation { get; set; }
    }
}
