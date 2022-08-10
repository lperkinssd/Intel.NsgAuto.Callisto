using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class ComparisonLotDisposition
    {
        public int Id { get; set; }
        public string SubConName { get; set; }
        public string SsdId { get; set; }
        public string InventoryLocation { get; set; }
        public string MMNumber { get; set; }
        public string LocationType { get; set; }
        public string Category { get; set; }
        public string SLot { get; set; }
        public string DesignId { get; set; }
        public string SCode { get; set; }
        public string MediaIPN { get; set; }
        public string PorMajorProbeProgramRevision { get; set; }
        public string ActualMajorProbeProgramRevision { get; set; }
        public string PorBurnTapeRevision { get; set; }
        public string ActualBurnTapeRevision { get; set; }
        public string PorCellRevision { get; set; }
        public string ActualCellRevision { get; set; }
        public string PorCustomTestingRequired { get; set; }
        public string ActualCustomTestingRequired { get; set; }
        public string PorFabConvId { get; set; }
        public string ActualFabConvId { get; set; }
        public string PorFabExcrId { get; set; }
        public string ActualFabExcrId { get; set; }
        public string PorProductGrade { get; set; }
        public string ActualProductGrade { get; set; }
        public string PorReticleWaveId { get; set; }
        public string ActualReticleWaveId { get; set; }
        public string PorFabFacility { get; set; }
        public string ActualFabFacility { get; set; }
        public string PorProbeRev { get; set; }
        public string ActualProbeRev { get; set; }
        public int? LotDispositionReasonId { get; set; }
        public string LotDispositionReason { get; set; }
        public string Notes { get; set; }
        public int? LotDispositionActionId { get; set; }
        public string LotDispositionActionName { get; set; }
        public string LotDispositionDisplayText { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedOn { get; set; }  

        // Note: LotDispositionReason and LotDispositionAction have separate fields rather than using the object
        //       because the devextreme code has to have the field name in the grid for the Excel function to
        //       get the Name and Text values. It cannot get the value from the dropdown list. It gets it from
        //       the text control behind the dropdown control.
    }
}
