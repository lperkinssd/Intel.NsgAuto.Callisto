namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaSetCreateDto
    {
        public int? BuildCombinationId { get; set; }
        public BuildCriteriasCreateDto BuildCriterias { get; set; }
        public string Comment { get; set; }
    }
}
