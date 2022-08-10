using Intel.NsgAuto.Callisto.Business.Entities.Workflows;

namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class BuildCriteriaDetails
    {
        public BuildCriteria BuildCriteria { get; set; }
        public BuildCriteria BuildCriteriaCompare { get; set; }
        public BuildCriterias BuildCriteriasCompare { get; set; }
        public BuildCriteriaComparisonResults ComparisonResults { get; set; }
        public Review Review { get; set; }
    }
}
