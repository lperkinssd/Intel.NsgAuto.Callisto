using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models.OSAT;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class OSATController : LayoutController
    {
        AdministrationService _adminService = new AdministrationService();

        public ActionResult AttributeTypes()
        {
            AttributeTypesModel model = CreateLayout(new AttributeTypesModel());
            model.Entity = new OsatService().GetAttributeTypesManage(Functions.GetLoggedInUserId());
            return View(model);
        }

        public ActionResult BuildCriteriaSetDetails(long? id)
        {
            if (!id.HasValue) return RedirectToAction("ListDesigns");
            BuildCriteriaDetailsModel model = CreateLayout(new BuildCriteriaDetailsModel());
            // idCompare = 0 parameter below signifies it is the initial request and the value should be determined in the db
            model.Entity = new OsatService().GetBuildCriteriaSetDetails(Functions.GetLoggedInUserId(), id.Value, 0);
            if (model?.Entity?.BuildCriteriaSet == null) return RedirectToAction("ListDesigns");
            return View(model);
        }

        public ActionResult CreateBuildCriteriaSet(long? id, int? buildCombinationId)
        {
            BuildCriteriaCreateModel model = CreateLayout(new BuildCriteriaCreateModel());
            model.Entity = new OsatService().GetBuildCriteriaSetCreate(Functions.GetLoggedInUserId(), id, buildCombinationId);
            return View(model);
        }

        public ActionResult DesignSummary(int? id)
        {
            var model = CreateLayout(new DesignSummaryModel());

            var preferredRole = _adminService.GetPreferredRole(Functions.GetLoggedInUserId());
            var designFamilyId = preferredRole.Contains("Callisto_Optane_User") ? 2 : 1;

            model.Entity = new OsatService().GetDesignSummary(Functions.GetLoggedInUserId(), id, designFamilyId);
            return View(model);
        }

        public ActionResult Index()
        {
            var model = CreateLayout(new OSATModel());
            return View(model);
        }

        public ActionResult ListBuildCombinationBuildCriteriaSets(int id)
        {
            // id is the build combination id; named id for url route rules
            var model = CreateLayout(new ListBuildCombinationBuildCriteriasModel());
            model.Entity = new OsatService().GetBuildCombinationAndBuildCriteriaSets(Functions.GetLoggedInUserId(), id);
            return View(model);
        }

        public ActionResult ListDesigns()
        {
            var model = CreateLayout(new ListDesignsModel());
            model.Products = new ProductsService().GetAll(Functions.GetLoggedInUserId());
            return View(model);
        }

        public ActionResult ListPasVersions()
        {
            var model = CreateLayout(new ListPasVersionsModel());
            model.Entity = new OsatService().GetPasVersionListAndImport(Functions.GetLoggedInUserId());
            return View(model);
        }

        public ActionResult PasVersionDetails(int? id)
        {
            if (!id.HasValue) return RedirectToAction("ListPasVersions");
            var model = CreateLayout(new PasVersionDetailsModel());
            model.Entity = new OsatService().GetPasVersionDetails(Functions.GetLoggedInUserId(), id.Value);
            if (model?.Entity?.Version == null) return RedirectToAction("ListPasVersions");
            return View(model);
        }

        public ActionResult QualFilter(int id = 0, int osatId = 2)
        {
            var model = CreateLayout(new QualFilterModel());
            model.Entity = new OsatService().GetQualFilter(Functions.GetLoggedInUserId(), designId: id, osatId: osatId);
            return View(model);
        }

        public ActionResult ListQualFilterExports()
        {
            var model = CreateLayout(new ListQualFilterExportsModel());
            model.Entity = new OsatService().GetQualFilterExportsListAndPublish(Functions.GetLoggedInUserId());
            return View(model);
        }

        public ActionResult QualFilterExportDetails(int? id)
        {
            if (!id.HasValue) return RedirectToAction("ListQualFilterExports");
            var model = CreateLayout(new QualFilterExportDetailsModel());
            model.Entity = new OsatService().GetQualFilterExportDetails(Functions.GetLoggedInUserId(), id.Value);
            if (model?.Entity?.Export == null) return RedirectToAction("ListQualFilterExports");
            return View(model);
        }

        public ActionResult ListQualFilterImports()
        {
            var model = CreateLayout(new ListQualFilterImportsModel());
            model.Entity = new OsatService().GetQualFilterImportsList(Functions.GetLoggedInUserId());
            return View(model);
        }

        public ActionResult QualFilterImportDetails(int? id)
        {
            if (!id.HasValue) return RedirectToAction("ListQualFilterImports");
            var model = CreateLayout(new QualFilterImportDetailsModel());
            model.Entity = new OsatService().GetQualFilterImportDetails(Functions.GetLoggedInUserId(), id.Value);
            if (model?.Entity?.Import == null) return RedirectToAction("ListQualFilterImports");
            return View(model);
        }

            public ActionResult BulkUpdates(int? id, int? Osatid)
            {
                var model = CreateLayout(new BulkUpdatesModel());
                model.Designs = new ProductsService().GetAll(Functions.GetLoggedInUserId()).Select(x => new KeyValuePair<int, string>(x.Id, x.Name)).ToList();
                model.OsatMetaData = new OsatService().GetAll(Functions.GetLoggedInUserId());
                model.SelectedImportId = id.GetValueOrDefault(0);
                model.SelectedOsatId = Osatid.GetValueOrDefault(0);

                return View(model);
            }
        }
}