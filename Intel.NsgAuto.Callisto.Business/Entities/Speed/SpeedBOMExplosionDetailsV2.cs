namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedBOMExplosionDetailsV2 : SpeedBaseAPIResponse
    {
        public string name { get; set; }
        public SpeedBOMExplosionDetailsV2Elements elements { get; set; }
    }
}
