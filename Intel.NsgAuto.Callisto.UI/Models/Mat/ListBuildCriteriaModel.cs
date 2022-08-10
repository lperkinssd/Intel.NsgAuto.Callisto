using Intel.NsgAuto.Callisto.Business.Entities.Mat;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models.Mat
{
    public class ListBuildCriteriaModel : LayoutModel
    {
        public BuildCriterias BuildCriterias { get; set; }
        public bool IsPOR { get; set; }
    }
}