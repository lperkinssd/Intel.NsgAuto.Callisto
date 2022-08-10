using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Callisto.Business.Entities.MATs.Workflows;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models
{
    public class MATVersionModel : LayoutModel
    {
        public MATVersion Version { get; set; }

        public MATs MATs { get; set; }

        public MATReview Review { get; set; }
    }
}