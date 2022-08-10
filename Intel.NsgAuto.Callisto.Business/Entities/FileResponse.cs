using System.IO;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class FileResponse
    {
        public string Name { get; set; }

        public Stream Content { get; set; }
    }
}
