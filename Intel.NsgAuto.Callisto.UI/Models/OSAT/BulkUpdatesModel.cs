using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.Osat;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.Web.Mvc.Models;
using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.UI.Models.OSAT
{
    public class BulkUpdatesModel : LayoutModel
    {
        public Review Review { get; set; }
        public List<KeyValuePair<int, string>> Designs { get; set; }
        public Product Design { get; set; }

        public OsatMetaData OsatMetaData { get; set; }

        public int SelectedOsatId { get; set; }

        public int SelectedDesignId { get; set; }
        public int SelectedStatusId { get; set; }
        public int SelectedVersionId { get; set; }
        public string CreatedBy { get; set; }
        public int SelectedImportId { get; set; }
    }
}