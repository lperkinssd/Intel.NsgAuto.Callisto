using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Web.Mvc.Models;
using Newtonsoft.Json;

namespace Intel.NsgAuto.Callisto.UI.Models
{
    public class MATVersionsModel : LayoutModel
    {
        public MATVersions Versions { get; set; }
        public string GetJsonVersions()
        {
            return JsonConvert.SerializeObject(Versions);
        }
    }
}