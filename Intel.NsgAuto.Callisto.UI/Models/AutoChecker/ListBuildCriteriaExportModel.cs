using Intel.NsgAuto.Callisto.Business.Entities.AutoChecker;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models.AutoChecker
{
    public class ListBuildCriteriaExportModel : LayoutModel
    {
        public BuildCriteriaExportConditions Conditions { get; set; }
    }
}