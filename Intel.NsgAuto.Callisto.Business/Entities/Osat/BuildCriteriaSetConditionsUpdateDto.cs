namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaSetConditionsUpdateDto
    {
        public BuildCriteriaSetConditionsUpdateDto()
        {
            Conditions = new BuildCriteriaConditions();
        }
        public int BuildCriteriaSetId { get; set; }
        public int BuildCriteriaSetStatusId { get; set; }
        public int BuildCombinationId { get; set; }
        public int BuildCriteriaId { get; set; }
        public string PackageDieTypeName { get; set; }
        public string BuildCriteriaName { get; set; }
        public BuildCriteriaConditions Conditions { get; set; }
        public string PartNumberDecode { get; set; }
        public string DeviceName { get; set; }
    }
}