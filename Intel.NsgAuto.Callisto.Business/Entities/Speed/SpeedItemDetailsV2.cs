namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedItemDetailsV2 : SpeedBaseAPIResponse
    {
        public string name { get; set; }
        public SpeedItemDetailsV2Elements elements { get; set; }
    }
}
