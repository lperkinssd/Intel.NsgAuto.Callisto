namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedBOMDetailsV2 : SpeedBaseAPIResponse
    {
        public string name { get; set; }
        public SpeedBOMDetailsV2Elements elements { get; set; }
    }
}
