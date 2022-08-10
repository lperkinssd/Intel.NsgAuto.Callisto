namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class ComparisonOperation
    {
        public int Id { get; set; }
        public string Key { get; set; }
        public string KeyTreadstone { get; set; }
        public string Name { get; set; }
        public OperandType OperandType { get; set; }
    }
}
