using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedItemCharacteristicDetailsV2Element
    {
        public DateTime? PullDateTime { get; set; }
        public string ItemId { get; set; }
        public int? CharacteristicId { get; set; }
        public string CharacteristicNm { get; set; }
        public string CharacteristicDsc { get; set; }
        public string ProductLifeCycleManagementItemNbr { get; set; }
        public string ProductLifeCycleAttributeGroupNm { get; set; }
        public string ProductLifeCycleCharacteristicNm { get; set; }
        public string ProductLifeCycleAttributeValueTypeTxt { get; set; }
        public string CharacteristicValueTxt { get; set; }
        public int? CharacteristicSequenceNbr { get; set; }
        public DateTime? CharacteristicLastModifiedDt { get; set; }
        public string CharacteristicLastModifiedUsr { get; set; }
        public string CreateAgentId { get; set; }
        public DateTime? CreateDtm { get; set; }
        public string ChangeAgentId { get; set; }
        public DateTime? ChangeDtm { get; set; }
    }
}
