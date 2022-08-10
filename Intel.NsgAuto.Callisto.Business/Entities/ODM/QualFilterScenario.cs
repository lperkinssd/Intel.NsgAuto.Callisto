namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class QualFilterScenario
    {
        public QualFilterScenarioVersion Version { get; set; }
        public PrfVersions Prfs { get; set; }
        public MatVersions Mats { get; set; }
        public NonQualifiedMedias NonQualifieds { get; set; }
        public NonQualifiedMediasRaw NonQualifiedsRaw { get; set; }
        public NonQualifiedMediaExceptions NonQualifiedMediaExceptions { get; set; }
        public ComparisonLotDispositions Comparisons { get; set; }
        public OdmWips OdmWips { get; set; }
        public LotShips LotShips { get; set; }
        public LotDispositionReasons LotDispositionReasons { get; set; }
        public LotDispositionActions LotDispositionActions { get; set; }
        public QualFilterScenarioInfo QualFilterScenarioInfo { get; set; }
    }
}
