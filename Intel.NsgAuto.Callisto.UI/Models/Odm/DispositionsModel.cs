using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;
using Intel.NsgAuto.Callisto.UI.HtmlHelpers;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models.Odm
{
    public class DispositionsModel : LayoutModel
    {
        public DispositionVersions Versions { get; set; }
        public DispositionVersions GetVersions()
        {
            return this.Versions;
        }
    }
}