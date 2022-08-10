using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class QualFilterScenarioInfo
    {
		public int LotShipVersion { get; set; }
		public DateTime? LotShipLoadTime { get; set; }
		public int WipVersion { get; set; }
		public DateTime? WipLoadTime { get; set; }
		public int PrfVersion { get; set; }
		public DateTime? PrfImportTime { get; set; }
		public int MatVersion { get; set; }
		public DateTime? MatImportTime { get; set; }
	}
}
