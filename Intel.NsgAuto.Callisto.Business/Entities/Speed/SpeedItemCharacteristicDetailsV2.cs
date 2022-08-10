namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedItemCharacteristicDetailsV2 : SpeedBaseAPIResponse
    {
        public string name { get; set; }
        public SpeedItemCharacteristicDetailsV2Elements elements { get; set; }
    }
}
