namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public interface IReadOnlyTaskType
    {
        int Id { get; }
        string Name { get; }
        int? ThresholdTimeLimit { get; }
        string CodeLocation { get; }
    }
}
