namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCriteriaCreate
    {
        public AttributeTypes AttributeTypes { get; set; }
        public AttributeTypeValues AttributeTypeValues { get; set; }
        public BuildCombinations BuildCombinations { get; set; }
        public BuildCriteria BuildCriteria { get; set; }
        public AttributeDataTypes AttributeDataTypes { get; set; }
        public FabricationFacilities FabricationFacilities { get; set; }
        public ProbeConversions ProbeConversions { get; set; }
        public Products Designs { get; set; }
        public BuildCriteriaTemplates Templates { get; set; }
        public TestFlows TestFlows { get; set; }
        public LongIdAndNames Versions { get; set; }
    }
}
