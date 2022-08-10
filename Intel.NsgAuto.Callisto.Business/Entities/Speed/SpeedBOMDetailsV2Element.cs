using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedBOMDetailsV2Element
    {
        public int? BillOfMaterialId { get; set; }
        public string ParentItemId { get; set; }
        public string ChildItemId { get; set; }
        public string ParentItemRevisionNbr { get; set; }
        public string ProductLifeCycleManagementParentItemNbr { get; set; }
        public string ProductLifeCycleManagementChildItemNbr { get; set; }
        public string ProductLifeCycleManagementParentItemRevisionNbr { get; set; }
        public string ParentBusinessUnitId { get; set; }
        public string ParentBusinessUnitNm { get; set; }
        public int? BillOfMaterialFindNbr { get; set; }
        public string BillOfMaterialAssociationTypeCd { get; set; }
        public string BillOfMaterialAssociationTypeNm { get; set; }
        public string BillOfMaterialStructureTypeNm { get; set; }
        public decimal? ChildQty { get; set; }
        public string NoExplosionInd { get; set; }
        public string CreateAgentId { get; set; }
        public DateTime? CreateDtm { get; set; }
        public string ChangeAgentId { get; set; }
        public DateTime? ChangeDtm { get; set; }
    }
}
