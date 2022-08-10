using Intel.NsgAuto.Callisto.Business.Entities.MATs.Workflows;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models;
using Intel.NsgAuto.Web.Mvc.Controllers;
using Intel.NsgAuto.Web.Mvc.Core;
using Intel.NsgAuto.Web.Mvc.Models;
using System;
using System.Web.Mvc;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    public class MATVersionsController : LayoutController
    {
        public ActionResult Index()
        {
            return RedirectToAction("List");
        }

        public ActionResult List()
        {
            MATVersionsModel model = CreateLayout(new MATVersionsModel());
            return View(model);
        }

        // GET: MATVersions/Details/{id:int}
        public ActionResult Details(int? id)
        {

            MATVersionModel model = null;
            try
            {
                if (!id.HasValue) return RedirectToAction("List");
                // create the model with layout
                model = CreateLayout(new Models.MATVersionModel());
                MATVersionsService service = new MATVersionsService();
                model.Version = service.GetMATVersionDetails(id.Value, Functions.GetLoggedInUserId());
                model.Review = model.Version.Review;
                model.MATs = model.Version.MATRecords;
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

            ////if (!id.HasValue) return RedirectToAction("List");
            ////MATVersionModel model = CreateLayout(new MATVersionModel());
            ////string userId = Functions.GetLoggedInUserId();
            ////MATVersionsService service = new MATVersionsService();
            ////service.GetMATVersionDetails(userId, id.Value);

            //////MATVersionsService service = new MATVersionsService();
            //////model.Version = service.Get(userId, id.Value);
            //////model.MATs = service.GetMATs(userId, id.Value);

            //////// This will create the snapshot tables when the status changes
            //////// from Draft to Submitted for this version and will not be 
            //////// created again until the next version is Submitted
            //////if(model.Version.Status.Name != "Draft")
            //////{
            //////    MATReviewResponse response = service.GetReviewSteps(userId, id.Value);
            //////    model.Review = (MATReview)response.Review;
            //////}

            ////return View(model);
        }
    }
}