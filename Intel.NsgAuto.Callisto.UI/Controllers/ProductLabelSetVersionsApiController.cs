using Intel.NsgAuto.Callisto.Business.Entities.ProductLabels;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Net;
using System.Web;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/ProductLabelSetVersions")]
    public class ProductLabelSetVersionsApiController : ApiController
    {
        [HttpGet]
        [Route("")]
        public IHttpActionResult GetAll()
        {
            ProductLabelSetVersions result = new ProductLabelSetVersionsService().GetAll(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("Active")]
        public IHttpActionResult Active()
        {
            ProductLabelSetVersions result = new ProductLabelSetVersionsService().GetAll(Functions.GetLoggedInUserId(), true);
            return Ok(result);
        }

        [HttpGet]
        [Route("GetProductLabels/{id:int}")]
        public IHttpActionResult GetProductLabels(int id)
        {
            ProductLabels result = new ProductLabelSetVersionsService().GetProductLabels(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpPost]
        [Route("Import")]
        public IHttpActionResult Import()
        {
            HttpFileCollection files = HttpContext.Current.Request.Files;
            if (files.Count == 1)
            {
                HttpPostedFile file = files[0];
                ProductLabelSetVersionImportResult result = new ProductLabelSetVersionsService().Import(Functions.GetLoggedInUserId(), file.InputStream, file.FileName);
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
        [Route("Approve/{id:int}")]
        public IHttpActionResult Approve(int id)
        {
            var result = new ProductLabelSetVersionsService().Approve(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Cancel/{id:int}")]
        public IHttpActionResult Cancel(int id)
        {
            var result = new ProductLabelSetVersionsService().Cancel(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Reject/{id:int}")]
        public IHttpActionResult Reject(int id)
        {
            var result = new ProductLabelSetVersionsService().Reject(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Submit/{id:int}")]
        public IHttpActionResult Submit(int id)
        {
            var result = new ProductLabelSetVersionsService().Submit(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }
    }
}
