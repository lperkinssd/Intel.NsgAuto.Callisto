using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System;
using System.Net;
using System.Web;
using System.Web.Helpers;
using System.Web.Http;
using System.Web.Http.Results;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/MATVersionsApi")]
    public class MATVersionsApiController : ApiController
    {
        [HttpGet]        
        public JsonResult<MATVersions> GetAll()
        {
            MATVersions result = new MATVersionsService().GetAll(Functions.GetLoggedInUserId());
            return Json(result);
        }

        [HttpGet]
        [Route("Active")]
        public JsonResult<MATVersions> Active()
        {
            MATVersions result = new MATVersionsService().GetAll(Functions.GetLoggedInUserId(), true);
            return Json(result);
        }

        [HttpGet]
        [Route("Get/{id:int}")]
        public JsonResult<MATVersion> Get(int id)
        {
            var result = new MATVersionsService().Get(Functions.GetLoggedInUserId(), id);
            return Json(result);
        }

        [HttpGet]
        [Route("GetMATs/{id:int}")]
        public JsonResult<MATs> GetMATs(int id)
        {
            MATs result = new MATVersionsService().GetMATs(Functions.GetLoggedInUserId(), id);
            return Json(result);
        }

        [HttpPost]
        [Route("Import")]
        public IHttpActionResult Import()
        {
            HttpFileCollection files = HttpContext.Current.Request.Files;
            if (files.Count == 1)
            {
                HttpPostedFile file = files[0];
                MATVersionImportResponse result = new MATVersionsService().Import(Functions.GetLoggedInUserId(), file.InputStream, file.FileName);
                if (result.Succeeded) return Ok(result);
                else
                {
                    string message;
                    if (result.Messages != null && result.Messages.Count > 0) message = result.Messages[0];
                    else message = "The file could not be imported.";
                    return BadRequest(message);
                }
            }
            else
            {
                string message;
                if (files.Count == 0) message = "A file is required.";
                else message = "Multiple files are not supported.";
                return BadRequest(message);
            }
        }

        [HttpPost]
        [Route("Approve")]
        //[Route("Approve/{id:int}")]
        //[HttpPost]
        //[Route("api/MATVersionsApi/Approve")]
        [ActionName("Approve")]
        public JsonResult<EntitySingleMessageResult<MATVersion>> Approve(ReviewDecision decision)
        {
            var result = new MATVersionsService().Approve(Functions.GetLoggedInUserId(), decision);
            return Json(result);
            //if (result.Succeeded) return Ok(result);
            //else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Cancel/{id:int}")]
        //[HttpPost]
        //[Route("api/MATVersionsApi/Cancel")]
        [ActionName("Cancel")]
        public JsonResult<EntitySingleMessageResult<MATVersion>> Cancel(int id)
        {
            var result = new MATVersionsService().Cancel(Functions.GetLoggedInUserId(), id);
            return Json(result);
            //if (result.Succeeded) return Ok(result);
            //else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Reject")]
        //[Route("Reject/{id:int}")]
        //[HttpPost]
        //[Route("api/MATVersionsApi/Reject")]
        [ActionName("Reject")]
        public JsonResult<EntitySingleMessageResult<MATVersion>> Reject(ReviewDecision decision)
        {
            var result = new MATVersionsService().Reject(Functions.GetLoggedInUserId(), decision);
            return Json(result);
            //if (result.Succeeded) return Ok(result);
            //else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Submit/{id:int}")]
        //[HttpPost]
        //[Route("api/MATVersionsApi/Submit")]
        public JsonResult<EntitySingleMessageResult<MATVersion>> Submit(int id)
        {
            EntitySingleMessageResult<MATVersion> result = new MATVersionsService().Submit(Functions.GetLoggedInUserId(), id);
            //EntitySingleMessageResult<MATVersion> result = new EntitySingleMessageResult<MATVersion>();
            return Json(result);

        }
    }
}