using Intel.NsgAuto.Callisto.Business.Entities.AutoChecker;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models.AutoChecker
{
    public class ListBuildCriteriaModel : LayoutModel
    {
        public BuildCriterias BuildCriterias { get; set; }
        public bool IsPOR { get; set; }
    }
}