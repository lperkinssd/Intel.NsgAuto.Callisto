using System.Web.Mvc;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models.Mat;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class MatController : LayoutController
    {

        // GET: AutoChecker/AttributeTypes
        public ActionResult AttributeTypes()
        {
            AttributeTypesModel model = CreateLayout(new AttributeTypesModel());
            //model.Entity = new MatService().GetAttributeTypesMetadata(Functions.GetLoggedInUserId());
            return View(model);
        }

        // GET: AutoChecker/BuildCriteriaDetails
        public ActionResult BuildCriteriaDetails(long? id)
        {
            if (!id.HasValue) return RedirectToAction("ListBuildCriteriaPOR");
            BuildCriteriaModel model = CreateLayout(new BuildCriteriaModel());
            // idCompare = 0 parameter below signifies it is the initial request and the value should be determined in the db
            model.Entity = new MatService().GetBuildCriteriaDetails(Functions.GetLoggedInUserId(), id.Value, 0);
            return View(model);
        }

        public ActionResult CreateBuildCriteria(long? id)
        {
            ViewData["Id"] = id;
            CreateBuildCriteriaModel model = CreateLayout(new CreateBuildCriteriaModel());
            //model.Entity = new AutoCheckerService().GetBuildCriteriaCreate(Functions.GetLoggedInUserId(), id);
            return View(model);
        }

        /// <summary>
        /// This screen will list all the designs in the system.
        /// Have the distinct list of designs merged from SPEED after daily data pull
        /// </summary>
        /// <returns></returns>
        // GET: AutoChecker/Designs
        public ActionResult Designs()
        {
            return View();
        }

        // GET: AutoChecker/CreateCriteria
        public ActionResult CreateCriteria()
        {
            //CreateCriteriaModel model = null;
            //try
            //{
            //    // create the model with layout
            //    model = CreateLayout(new CreateCriteriaModel());
            //    AutoCheckerService service = new AutoCheckerService();
            //    string userId = Functions.GetLoggedInUserId();
            //    model.AttributeTypes = service.GetAttributeTypes(userId);
            //    model.FabricationFacilities = service.GetFabricationFacilities(userId);
            //    model.ProbeConversionIds = service.GetProbeConversionIds(userId);
            //    model.Products = service.GetProducts(userId);
            //    model.TestFlows = service.GetTestFlows(userId);
            //}
            //catch (Exception ex)
            //{
            //    // TO DO: Handle Exception & Log
            //    throw ex;
            //}
            //finally
            //{
            //}

            //return View(model);
            return View();
        }
        /// <summary>
        /// Ability to cancel and\or submit
        /// </summary>
        /// <returns></returns>
        // GET: AutoChecker/PreviewCriteria
        public ActionResult PreviewCriteria()
        {
            return View();
        }
        /// <summary>
        /// Ability to view the build criteria and reviewers will use the review section - 
        /// </summary>
        /// <returns></returns>
        // GET: AutoChecker/ReviewCriteria
        public ActionResult ReviewCriteria()
        {
            return View();
        }
        /// <summary>
        /// View a list of all active build crietria definitions with version numbers and design id, fab facitlity (4 criteria metadata columns), submitted by
        /// </summary>
        /// <returns></returns>
        // GET: AutoChecker/Criteria
        public ActionResult Criteria()
        {
            return View();
        }

        // GET: MAT/ListBuildCriteriaExportConditions
        public ActionResult ListBuildCriteriaExportConditions()
        {
            ListBuildCriteriaExportModel model = CreateLayout(new ListBuildCriteriaExportModel());
            model.Conditions = new MatService().GetBuildCriteriaExportConditions(Functions.GetLoggedInUserId());
            return View(model);
        }
        // GET: Mat/ListBuildCriteriaPOR
        public ActionResult ListBuildCriteriaPOR()
        {
            ListBuildCriteriaModel model = CreateLayout(new ListBuildCriteriaModel());
            model.IsPOR = true;
            model.BuildCriterias = new MatService().GetBuildCriterias(Functions.GetLoggedInUserId(), isPOR: model.IsPOR);
            return View("ListBuildCriteria", model);
        }

        // GET: Mat/ListBuildCriteriaNonPOR
        public ActionResult ListBuildCriteriaNonPOR()
        {
            ListBuildCriteriaModel model = CreateLayout(new ListBuildCriteriaModel());
            model.IsPOR = false;
            model.BuildCriterias = new MatService().GetBuildCriterias(Functions.GetLoggedInUserId(), isPOR: model.IsPOR);
            return View("ListBuildCriteria", model);
        }

        public ActionResult ListBuildCriterias(int id)
        {
            ViewData["Id"] = id;
            var model = CreateLayout(new ListBuildCriteriaModel());
            return View(model);
        }

        public ActionResult ListPRFs()
        {
            PrfModel model = CreateLayout(new PrfModel());
            return View(model);
        }

        public ActionResult ListMats(string id)
        {
            if (id == null) id = "999AVV";
            ViewData["MMNumber"] = id;
            ListBuildCriteriaModel model = CreateLayout(new ListBuildCriteriaModel());
            return View(model);
        }

        public ActionResult ImportPrf()
        {
            var model = CreateLayout(new PrfModel());
            return View(model);
        }
        public ActionResult ListPrfVersions()
        {
            var model = CreateLayout(new PrfModel());
            return View(model);
        }

        public ActionResult PrfVersionDetails2(int? id)
        {
            if (!id.HasValue) return RedirectToAction("ListPrfVersions");
            var model = CreateLayout(new PrfModel());
            return View(model);
        }

        public ActionResult PrfVersionDetails(int? id)
        {
            if (!id.HasValue) return RedirectToAction("ListPrfVersions");
            var model = CreateLayout(new PrfModel());
            //model.Entity = new OsatService().GetPrfVersionDetails(Functions.GetLoggedInUserId(), id.Value);
            return View(model);
        }

        // TODO
        #region TODO
        /// <summary>
        /// This is the home page for Auto checker
        /// On landing here, autochecker users will get their dashboard
        /// </summary>
        /// <returns></returns>
        // GET: AutoChecker
        public ActionResult Index()
        {
            return View();
        }
        #endregion

    }
}