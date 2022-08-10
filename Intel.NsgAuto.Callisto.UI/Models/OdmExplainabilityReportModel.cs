using Intel.NsgAuto.Callisto.Business.Entities.ODM;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models
{
    public class OdmExplainabilityReportModel : LayoutModel
    {
        public ExplainabilityReport Report { get; set; }
        public Slots BadSlots { get; set; }
        public Explanations Explanations { get; set; }
    }
}