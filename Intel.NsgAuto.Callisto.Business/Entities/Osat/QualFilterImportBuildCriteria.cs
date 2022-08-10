namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterImportBuildCriteria
    {
        public long Id { get; set; }

        public int ImportId { get; set; }

        public int? GroupIndex { get; set; }

        public int? GroupSourceIndex { get; set; }

        public int? CriteriaIndex { get; set; }

        public int? CriteriaSourceIndex { get; set; }

        public BuildCriteria BuildCriteria { get; set; }

        public BuildCriteriaSet BuildCriteriaSet { get; set; }
    }
}
