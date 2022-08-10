using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedBOMExplosionDetailsV2Element
    {
        public string RootItemId { get; set; }
        public string RootItemRevisionNbr { get; set; }
        public string RootProductLifeCycleManagementItemNbr { get; set; }
        public string RootProductLifeCycleManagementItemRevisionNbr { get; set; }
        public int? BillOfMaterialLevelNbr { get; set; }
        public int? ParentBillOfMaterialRowNbr { get; set; }
        public int? BillOfMaterialRowNbr { get; set; }
        public string ParentItemId { get; set; }
        public string ParentItemRevisionNbr { get; set; }
        public string ChildItemId { get; set; }
        public string ChildItemRevisionNbr { get; set; }
        public string ProductLifeCycleManagementParentItemNbr { get; set; }
        public string ProductLifeCycleManagementParentItemRevisionNbr { get; set; }
        public string ProductLifeCycleManagementChildItemNbr { get; set; }
        public string ProductLifeCycleManagementChildItemRevisionNbr { get; set; }
        public string ItemDsc { get; set; }
        public string ReleaseStatusCd { get; set; }
        public string ReleaseStatusNm { get; set; }
        public string ProductLifeCycleManagementStatusNm { get; set; }
        public string ProductLifeCycleManagementLifecyclePhaseNm { get; set; }
        public DateTime? ItemRevisionCreateDtm { get; set; }
        public decimal? ChildQuantityRequiredNbr { get; set; }
        public string UnitOfMeasureCd { get; set; }
        public string UnitOfWeightCd { get; set; }
        public int? BillOfMaterialFindNbr { get; set; }
        public string BillOfMaterialTypeCd { get; set; }
        public string BillOfMaterialAssociationTypeNm { get; set; }
        public string BillOfMaterialStructureTypeNm { get; set; }
        public string CommodityCd { get; set; }
        public string CommodityCodeDsc { get; set; }
        public string MaterialTypeCd { get; set; }
        public string ItemTypeCd { get; set; }
        public string ItemClassDsc { get; set; }
        public string ProductLifeCycleManagementItemClassNm { get; set; }
        public string ProductLifeCycleManagementUserItemTypeNm { get; set; }
        public string ItemRevisionProjectCd { get; set; }
        public string BusinessUnitId { get; set; }
        public string BusinessUnitNm { get; set; }
        public string MakeBuyNm { get; set; }
        public string SortOrderNbr { get; set; }
        public string NoExplosionInd { get; set; }
        public string CreateAgentId { get; set; }
        public DateTime? CreateDtm { get; set; }
        public string ChangeAgentId { get; set; }
        public DateTime? ChangeDtm { get; set; }
    }
}
