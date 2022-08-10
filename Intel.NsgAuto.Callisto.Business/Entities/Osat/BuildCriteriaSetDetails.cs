using Intel.NsgAuto.Callisto.Business.Entities.Workflows;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCriteriaSetDetails
    {
        public BuildCriteriaSet BuildCriteriaSet { get; set; }
        public BuildCriteriaSet BuildCriteriaSetCompare { get; set; }
        public BuildCriteriaSets BuildCriteriaSetsCompare { get; set; }
        public BuildCriteriaSetComparisonResults ComparisonResults { get; set; }
        public Review Review { get; set; }
    }
}
