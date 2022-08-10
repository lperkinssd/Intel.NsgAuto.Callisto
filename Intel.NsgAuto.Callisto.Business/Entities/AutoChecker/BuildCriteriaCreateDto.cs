namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCriteriaCreateDto
    {
        public int DesignId { get; set; }
        public int FabricationFacilityId { get; set; }
        public int? TestFlowId { get; set; }
        public int? ProbeConversionId { get; set; }
        public BuildCriteriaConditionsCreateDto Conditions { get; set; }
        public string Comment { get; set; }
        public bool RestrictToExistingCombinations { get; set; }
    }
}
