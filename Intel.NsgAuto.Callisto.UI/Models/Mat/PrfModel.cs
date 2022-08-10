using Intel.NsgAuto.Callisto.Business.Entities.Mat;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models.Mat
{
    public class PrfModel : LayoutModel
    {
        public PrfRecords PrfRecords { get; set; }
        public MatRecords MatRecords { get; set; }
    }
}