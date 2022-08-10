namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
   public class VersionName :IVersionName
    {
        public int Id { get; set; }

        public int Osatid { get; set; }
        public string Name { get; set; }
        public string VName { get; set; }
        public int StatusId { get; set; }
        public int VersionId { get; set; }
        public string CreatedBy { get; set; }
        public int ImportId { get; set; }
    }
}
