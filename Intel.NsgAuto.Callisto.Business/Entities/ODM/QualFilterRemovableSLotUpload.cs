using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class QualFilterRemovableSLotUpload
    {
		public int Version { get; set; }
		public DateTime CreatedDate { get; set; }
		public string OdmName { get; set; }
		public string SourceFileName { get; set; }
		public DateTime ProcessedOn { get; set; }
		public int RemovableCount { get; set; }
		public int TotalCount { get; set; }
	}
}
