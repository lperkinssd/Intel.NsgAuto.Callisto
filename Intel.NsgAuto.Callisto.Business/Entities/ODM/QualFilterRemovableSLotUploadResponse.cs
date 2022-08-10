using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class QualFilterRemovableSLotUploadResponse : Result
    {
        public List<QualFilterRemovableSLotUpload> KingstonUploads { get; set; }
        public List<QualFilterRemovableSLotUpload> PegatronUploads { get; set; }
        public List<QualFilterRemovableSLotUpload> PTIUploads { get; set; }
    }
}
