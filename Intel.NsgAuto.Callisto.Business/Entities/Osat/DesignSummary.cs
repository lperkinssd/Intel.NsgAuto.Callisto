namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class DesignSummary
    {
        public Products Designs { get; set; }
        public Product SelectedDesign { get; set; }
        public BuildCombinations BuildCombinations { get; set; }

        public Osats Osats { get; set; }
    }
}
