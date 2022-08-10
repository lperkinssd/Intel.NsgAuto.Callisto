using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class LotDisposition : ILotDisposition
    {
        public int Id { get; set; }
        public int ScenarioId { get; set; }
        public int OdmQualFilterId { get; set; }
        public int LotDispositionReasonId { get; set; }
        public string Notes { get; set; }
        public int LotDispositionActionId { get; set; }
    }
}
