namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaSetCreate
    {
        public AttributeDataTypes AttributeDataTypes { get; set; }
        public AttributeTypes AttributeTypes { get; set; }
        public AttributeTypeValues AttributeTypeValues { get; set; }
        public BuildCombination BuildCombination { get; set; }
        public BuildCombinations BuildCombinations { get; set; }
        public BuildCriteriaSet BuildCriteriaSet { get; set; }
        public Products Designs { get; set; }
        public BuildCriteriaSetTemplates SetTemplates { get; set; }
        public LongIdAndNames Versions { get; set; }

        public  Osats Osats { get;set;}
    }
}
