using System;
using System.Web.Mvc;
using Intel.NsgAuto.Callisto.Business.Logging;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models.AutoChecker;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using log4net;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class AutoCheckerController : LayoutController
    {
       
        // GET: AutoChecker/AttributeTypes
        public ActionResult AttributeTypes()
        {
            AttributeTypesModel model = CreateLayout(new AttributeTypesModel());

            try
            {

                model.Entity = new AutoCheckerService().GetAttributeTypesMetadata(Functions.GetLoggedInUserId());
                
            }
            catch(Exception ex)
            {
                Log.Error(ex);
            }
            return View(model);
        }

        // GET: AutoChecker/BuildCriteriaDetails
        public ActionResult BuildCriteriaDetails(long? id)
        {
            if (!id.HasValue) return RedirectToAction("ListBuildCriteriaPOR");
            BuildCriteriaModel model = CreateLayout(new BuildCriteriaModel());
            try
            {
                // idCompare = 0 parameter below signifies it is the initial request and the value should be determined in the db
                model.Entity = new AutoCheckerService().GetBuildCriteriaDetails(Functions.GetLoggedInUserId(), id.Value, 0);
                if (model?.Entity?.BuildCriteria == null) return RedirectToAction("ListBuildCriteriaPOR");
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }

            return View(model);
        }

        // GET: AutoChecker/CreateBuildCriteria
        public ActionResult CreateBuildCriteria(long? id)
        {
            CreateBuildCriteriaModel model = CreateLayout(new CreateBuildCriteriaModel());
            try
            {
                model.Entity = new AutoCheckerService().GetBuildCriteriaCreate(Functions.GetLoggedInUserId(), id);
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }

            return View(model);
        }

        // GET: AutoChecker/ListBuildCriteriaExportConditions
        public ActionResult ListBuildCriteriaExportConditions()
        {
            ListBuildCriteriaExportModel model = CreateLayout(new ListBuildCriteriaExportModel());
            try
            {
                model.Conditions = new AutoCheckerService().GetBuildCriteriaExportConditions(Functions.GetLoggedInUserId());
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            return View(model);
        }

        // GET: AutoChecker/ListBuildCriteriaPOR
        public ActionResult ListBuildCriteriaPOR()
        {
            ListBuildCriteriaModel model = CreateLayout(new ListBuildCriteriaModel());
            try
            {
                model.IsPOR = true;
                model.BuildCriterias = new AutoCheckerService().GetBuildCriterias(Functions.GetLoggedInUserId(), isPOR: model.IsPOR);
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            return View("ListBuildCriteria", model);
        }

        // GET: AutoChecker/ListBuildCriteriaNonPOR
        public ActionResult ListBuildCriteriaNonPOR()
        {
            ListBuildCriteriaModel model = CreateLayout(new ListBuildCriteriaModel());
            try
            {
                model.IsPOR = false;
                model.BuildCriterias = new AutoCheckerService().GetBuildCriterias(Functions.GetLoggedInUserId(), isPOR: model.IsPOR);
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            return View("ListBuildCriteria", model);
        }

        public ActionResult ListDesigns()
        {
            var model = CreateLayout(new ListDesignsModel());
            try
            {
                model.Products = new ProductsService().GetAll(Functions.GetLoggedInUserId());
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
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