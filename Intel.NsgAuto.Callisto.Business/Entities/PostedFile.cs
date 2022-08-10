using System.IO;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class PostedFile
    {
        public int ContentLength { get; set; }
        public string ContentType { get; set; }
        public string OriginalExtension { get; set; }
        public string OriginalFileName { get; set; }
        public string OriginalFilePath { get; set; }
        public string UploadFilePath { get; set; }
    }
}
