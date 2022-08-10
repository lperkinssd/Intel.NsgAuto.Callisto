using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface ILotDisposition
    {
        int Id { get; set; }
        int ScenarioId { get; set; }
        int OdmQualFilterId { get; set; }
        int LotDispositionReasonId { get; set; }
        string Notes { get; set; }
        int LotDispositionActionId { get; set; }
    }
}
