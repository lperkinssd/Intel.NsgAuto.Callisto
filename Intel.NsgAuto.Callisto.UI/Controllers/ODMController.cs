using System;
using System.Web.Mvc;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.Business.Logging;
using Intel.NsgAuto.Callisto.UI.Models;
using Intel.NsgAuto.Callisto.UI.Models.Odm;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class ODMController : LayoutController
    {
        // GET: ODM
        public ActionResult Index()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }

        // GET: ODM/MAT
        public ActionResult MAT()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }
        // GET: ODM/MediaAttributes
        public ActionResult MediaAttributes()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }

        // GET: ODM/PRF
        public ActionResult PRF()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }
        // GET: ODM/QF
        public ActionResult QF()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }
        // GET: ODM/WIP
        public ActionResult WIP()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }

        public ActionResult QualFilterExplanations()
        {
            OdmExplainabilityReportModel model = null;
            try
            {
                model = CreateLayout(new Models.OdmExplainabilityReportModel());
                OdmService service = new OdmService();
                model.Report = service.GetExplainabilityReport(Functions.GetLoggedInUserId());
                model.BadSlots = model.Report.BadSlots;
                model.Explanations = model.Report.Explanations;
            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);

        }

        public ActionResult QFScenarios()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());

            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }

        public ActionResult QFHistoricalScenarios()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw;
            }
            finally
            {
            }

            return View(model);
        }

        public ActionResult QFRemovableSLotReport()
        {
            ODMModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new Models.ODMModel());
            }
            catch (Exception ex)
            {
                Log.Error(ex);
                throw;
            }
            finally
            {
            }

            return View(model);
        }

        /// <summary>
        /// Action for the disposition screen where we disposition lots and FIDs
        /// as either qualified or non qualified
        /// </summary>
        /// <returns></returns>
        public ActionResult Dispositions()
        {
            DispositionsModel model = null;
            try
            {
                // create the model with layout
                model = CreateLayout(new DispositionsModel());
                model.Versions = new OdmService().GetDispositionVersions(Functions.GetLoggedInUserId());
            }
            catch (Exception ex)
            {
                // TO DO: Handle Exception & Log
                throw ex;
            }
            finally
            {
            }

            return View(model);
        }
    }
}