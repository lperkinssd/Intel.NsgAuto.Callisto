namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface IExplanation
    {
        string SubConName { get; set; }
        string SSD_Id { get; set; }
        string InventoryLocation { get; set; }
        string MMNumber { get; set; }
        string LocationType { get; set; }
        string Category { get; set; }
        string SLot { get; set; }
        string SCode { get; set; }
        string MediaIPN { get; set; }
        string PorMajorProbeProgramRevision { get; set; }
        string ActualMajorProbeProgramRevision { get; set; }
        string PorBurnTapeRevision { get; set; }
        string ActualBurnTapeRevision { get; set; }
        string PorCellRevision { get; set; }
        string ActualCellRevision { get; set; }
        string PorCustomTestingRequired { get; set; }
        string ActualCustomTestingRequired { get; set; }
        string PorFabConvId { get; set; }
        string ActualFabConvId { get; set; }
        string PorFabExcrId { get; set; }
        string ActualFabExcrId { get; set; }
        string PorProductGrade { get; set; }
        string ActualProductGrade { get; set; }
        string PorReticleWaveId { get; set; }
        string ActualReticleWaveId { get; set; }
        string PorFabFacility { get; set; }
        string ActualFabFacility { get; set; }
        string PorProbeRev { get; set; }
        string ActualProbeRev { get; set; }
        
    }
}
