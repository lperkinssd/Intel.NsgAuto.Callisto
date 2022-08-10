using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/ODMApi")]
    public class ODMApiController : ApiController
    {
        [HttpPost]
        [Route("CreateLotDisposition")]
        public IHttpActionResult CreateLotDisposition(LotDispositionDto lotDisposition)
        {
            Result result = new OdmService().CreateLotDisposition(Functions.GetLoggedInUserId(), lotDisposition);
            return Ok(result);
        }

        [HttpPost]
        [Route("SaveLotDispositions")]
        public IHttpActionResult SaveLotDispositions(LotDispositions lotDispositions)
        {
            Result result = new OdmService().SaveLotDispositions(Functions.GetLoggedInUserId(), lotDispositions);
            return Ok(result);
        }


        [HttpGet]
        [Route("GetLotDispositionReasons")]
        public IHttpActionResult GetLotDispositionReasons()
        {
            IdAndNames result = new OdmService().GetLotDispositionReasons(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("GetMatVersionDetails/{id:int}")]
        public IHttpActionResult GetMatVersionDetails(int id)
        {
            MatVersions result = new OdmService().GetMatVersionDetails(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("GetMatVersions")]
        public IHttpActionResult GetMatVersions()
        {
            ImportVersions result = new OdmService().GetMatVersions(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpPost]
        [Route("ImportMat")]
        public IHttpActionResult ImportMat()
        {
            HttpFileCollection files = HttpContext.Current.Request.Files;
            if (files.Count == 1)
            {
                HttpPostedFile file = files[0];
                ImportResult result = new OdmService().ImportMAT(Functions.GetLoggedInUserId(), file.InputStream, file.FileName);
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

        [HttpGet]
        [Route("GetQualFilterScenario/{id:int}")]
        public IHttpActionResult GetQualFilterScenario(int id)
        {
            QualFilterScenario result = new OdmService().GetQualFilterScenario(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("GetQualFilterHistoricalScenario/{id:int}")]
        public IHttpActionResult GetQualFilterHistoricalScenario(int id)
        {
            QualFilterScenario result = new OdmService().GetQualFilterHistoricalScenario(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }


        [HttpGet]
        [Route("GetQualFilterScenarioVersions")]
        public IHttpActionResult GetQualFilterScenarioVersions()
        {
            QualFilterScenarioVersions result = new OdmService().GetQualFilterScenarioVersions(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("GetQualFilterScenarioVersionsDaily")]
        public IHttpActionResult GetQualFilterScenarioVersionsDaily()
        {
            QualFilterScenarioVersions result = new OdmService().GetQualFilterScenarioVersionsDaily(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("GetOdmQualFilterScenarioHistoricalVersions")]
        public IHttpActionResult GetOdmQualFilterScenarioHistoricalVersions()
        {
            QualFilterScenarioVersions result = new OdmService().GetOdmQualFilterScenarioHistoricalVersions(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("GetQualFilterRemovableSLotUploads/{loadToDate}")]
        public IHttpActionResult GetQualFilterRemovableSLotUploads(DateTime loadToDate)
        {
            QualFilterRemovableSLotUploads uploads = new OdmService().GetQualFilterRemovableSLotUploads(Functions.GetLoggedInUserId(), loadToDate);
            QualFilterRemovableSLotUploadResponse result = new QualFilterRemovableSLotUploadResponse();

            result.KingstonUploads = uploads.Where(u => u.OdmName == "KINGSTON").ToList();
            result.PegatronUploads = uploads.Where(u => u.OdmName == "PEGATRON").ToList();
            result.PTIUploads = uploads.Where(u => u.OdmName == "PTI").ToList();

            return Ok(result);
        }

        [HttpGet]
        [Route("DownloadOdmUploadedFile/{odmName}/{sourceFileName}")]
        public HttpResponseMessage DownloadOdmUploadedFile(string odmName, string sourceFileName)
        {
            string odmFolder = String.Format(Intel.NsgAuto.Callisto.Business.Core.Settings.OdmSLotNPSGPickupLocation, odmName);
            
            string filePath = System.IO.Path.Combine(odmFolder, "Archive");
            filePath = System.IO.Path.Combine(filePath, sourceFileName + ".csv");

            if (!System.IO.File.Exists(filePath)) 
                return Request.CreateResponse(HttpStatusCode.NotFound);

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
            byte[] bytes = System.IO.File.ReadAllBytes(filePath);
            response.Content = new ByteArrayContent(bytes);
            response.Content.Headers.ContentLength = bytes.LongLength;
            response.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentDisposition.FileName = sourceFileName + ".csv";
            response.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(MimeMapping.GetMimeMapping(sourceFileName + ".csv"));
            return response;
        }

        [HttpGet]
        [Route("GetPrfVersionDetails/{id:int}")]
        public IHttpActionResult GetPrfVersionDetails(int id)
        {
            PrfVersions result = new OdmService().GetPrfVersionDetails(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("GetPrfVersions")]
        public IHttpActionResult GetPrfVersions()
        {
            ImportVersions result = new OdmService().GetPrfVersions(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpPost]
        [Route("ImportPrf")]
        public IHttpActionResult ImportPrf()
        {
            HttpFileCollection files = HttpContext.Current.Request.Files;
            if (files.Count == 1)
            {
                HttpPostedFile file = files[0];
                ImportResult result = new OdmService().ImportPRF(Functions.GetLoggedInUserId(), file.InputStream, file.FileName);
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

        //[HttpGet]
        //[Route("GetLatestOdmQualFilter")]
        //public IHttpActionResult GetLatestOdmQualFilter()
        //{
        //    OdmQualFilters result = new OdmService().GetLatestOdmQualFilter(Functions.GetLoggedInUserId());
        //    return Ok(result);
        //}

        [HttpPost]
        [Route("RunQualFilter")]
        public IHttpActionResult RunQualFilter()
        {
            Result result = new OdmService().RunQualFilter(Functions.GetLoggedInUserId());
            if (result.Succeeded) return Ok(result);
            else
            {
                string message;
                if (result.Messages != null && result.Messages.Count > 0) message = result.Messages[0];
                else message = "The file could not be imported.";
                return BadRequest(message);
            }

        }

        [HttpGet]
        [Route("RunScenario")]
        public IHttpActionResult RunScenario()
        {
            Result result = new OdmService().RunScenario(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("PublishScenario/{id:int}")]
        public IHttpActionResult PublishScenario(int id)
        {
            Result result = new OdmService().PublishScenario(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("GetOdmLotWipDetails")]
        public JsonResult<OdmWips> GetOdmLotWipDetails(string sLot, string mediaIPN, string sCode, string odmName)
        {
            OdmWips result = new OdmService().GetOdmLotWipDetails(sLot, mediaIPN, sCode, odmName, Functions.GetLoggedInUserId());
            return Json(result);
        }

        [HttpGet]
        [Route("GetRemovableSLotDetails")]
        public JsonResult<QualFilterRemovableSLots> GetRemovableSLotDetails(int version, string odmName)
        {
            QualFilterRemovableSLots result = new OdmService().GetRemovableSLotDetails(Functions.GetLoggedInUserId(), version, odmName);
            return Json(result);
        }

        [HttpGet]
        [Route("GetProhibitedTimeRanges")]
        public IHttpActionResult GetProhibitedTimeRanges()
        {
            string timeRanges = new OdmService().GetProhibitedTimeRanges(Functions.GetLoggedInUserId());
            return Ok(timeRanges);
        }

        [HttpGet]
        [Route("ClearArchiveOdmManualDisposition")]
        public IHttpActionResult ClearArchiveOdmManualDisposition()
        {
            Result result = new OdmService().ClearArchiveOdmManualDisposition(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpPost]
        [Route("ImportDispositions")]
        public JsonResult<ImportDispositionsResponse> ImportDispositions()
        {
            ImportDispositionsResponse response = null;
            HttpFileCollection files = HttpContext.Current.Request.Files;
            if (files.Count == 1)
            {
                HttpPostedFile file = files[0];
                response = new OdmService().ImportDispositions(file.InputStream, file.FileName, Functions.GetLoggedInUserId());
            }           
            return Json(response);
        }

        [HttpGet]
        [Route("GetDispositionsByVersion/{id:int}")]
        public JsonResult<Dispositions> GetDispositionsByVersion(int id)
        {
            Dispositions result = new OdmService().GetDispositionsByVersion(id, Functions.GetLoggedInUserId());
            return Json(result);
        }

        [HttpGet]
        [Route("CheckProhibitedScenarioRunTime")]
        public IHttpActionResult CheckProhibitedScenarioRunTime()
        {
            Result result = new OdmService().CheckProhibitedScenarioRunTime(Functions.GetLoggedInUserId());
            return Ok(result);
        }
    }
}