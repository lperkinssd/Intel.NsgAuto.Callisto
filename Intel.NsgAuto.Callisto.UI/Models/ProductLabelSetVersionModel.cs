using Intel.NsgAuto.Callisto.Business.Entities.ProductLabels;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models
{
    public class ProductLabelSetVersionModel : LayoutModel
    {
        public ProductLabelSetVersion Version { get; set; }

        public ProductLabels ProductLabels { get; set; }

        public string LoggedInUserId { get; set; }
    }
}