using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Web.Mvc.Models;
using Newtonsoft.Json;

namespace Intel.NsgAuto.Callisto.UI.Models
{
    public class MATVersionImportModel : LayoutModel
    {
        public IdAndNames Versions { get; set; }
        public MATVersion VersionSelected { get; set; }

        public string GetJsonVersion()
        {
            return JsonConvert.SerializeObject(VersionSelected);
        }

        public string GetJsonVersions()
        {
            return JsonConvert.SerializeObject(Versions);
        }
    }
}