using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class GenerateFilesResponse
    {
        public List<string> successResponse { get; set; }
        public List<string> errorResponse { get; set; }
    }
}
