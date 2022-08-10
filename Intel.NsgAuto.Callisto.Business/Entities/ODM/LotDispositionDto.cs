namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class LotDispositionDto
    {
        public int Id { get; set; }
        public int ScenarioId { get; set; }
        public int OdmQualFilterId { get; set; }
        public int LotDispoistionReasonId { get; set; }
        public string Notes { get; set; }
        public int LotDispoistionActionId { get; set; }
    }
}
