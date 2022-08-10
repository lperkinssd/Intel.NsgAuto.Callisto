namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedItem : SpeedItemDetailsV2Element
    {
        public SpeedItemCharacteristicDetailsV2Elements Characteristics { get; set; }

        public SpeedAssociatedItems ParentItems { get; set; }

        public SpeedAssociatedItems ChildItems { get; set; }
    }
}
