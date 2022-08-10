namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class GenerateFilesRequest
    {
        public string filepath { get; set; }
        public PrfRecords PrfRecords { get; set; }
        public MatRecords MatRecords { get; set; }

    }
}
