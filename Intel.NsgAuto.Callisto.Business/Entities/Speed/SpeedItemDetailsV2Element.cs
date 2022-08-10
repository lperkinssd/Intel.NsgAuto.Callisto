using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedItemDetailsV2Element
    {
        public DateTime? PullDateTime { get; set; }
        public string ItemId { get; set; }
        public string ProductLifeCycleManagementItemNbr { get; set; }
        public string ItemDsc { get; set; }
        public string ItemFullDsc { get; set; }
        public string CommodityCd { get; set; }
        public string ItemClassNm { get; set; }
        public string ProductLifeCycleManagementClassNm { get; set; }
        public string ProductLifeCycleManagementUserItemTypeNm { get; set; }
        public string ItemRevisionId { get; set; }
        public string EffectiveRevisionCd { get; set; }
        public string CurrentRevisionCd { get; set; }
        public string ItemOwningSystemNm { get; set; }
        public string MakeBuyNm { get; set; }
        public decimal? NetWeightQty { get; set; }
        public string UnitOfMeasureCd { get; set; }
        public string MaterialTypeCd { get; set; }
        public decimal? GrossWeightQty { get; set; }
        public string UnitOfWeightDim { get; set; }
        public string GlobalTradeIdentifierNbr { get; set; }
        public string BusinessUnitId { get; set; }
        public string BusinessUnitNm { get; set; }
        public DateTime? LastClassChangeDt { get; set; }
        public DateTime? OwningSystemLastModificationDtm { get; set; }
        public string CreateAgentId { get; set; }
        public DateTime? CreateDtm { get; set; }
        public string ChangeAgentId { get; set; }
        public DateTime? ChangeDtm { get; set; }
    }
}
