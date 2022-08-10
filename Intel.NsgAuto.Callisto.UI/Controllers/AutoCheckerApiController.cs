using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.AutoChecker;
using Intel.NsgAuto.Callisto.Business.Entities.AutoChecker.Workflows;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Net;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/AutoCheckerApi")]
    public class AutoCheckerApiController : ApiController
    {
        [HttpPost]
        [Route("CreateAttributeType")]
        public IHttpActionResult CreateAttributeType(AttributeTypeCreateDto entity)
        {
            EntitySingleMessageResult<AttributeTypes> result = new AutoCheckerService().CreateAttributeType(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("UpdateAttributeType")]
        public IHttpActionResult UpdateAttributeType(AttributeTypeUpdateDto entity)
        {
            EntitySingleMessageResult<AttributeTypes> result = new AutoCheckerService().UpdateAttributeType(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("CreateBuildCriteria")]
        public IHttpActionResult CreateBuildCriteria(BuildCriteriaCreateDto entity)
        {
            var result = new AutoCheckerService().CreateBuildCriteria(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("CreateBuildCriteriaComment")]
        public IHttpActionResult CreateBuildCriteriaComment(BuildCriteriaCommentCreateDto entity)
        {
            var result = new AutoCheckerService().CreateBuildCriteriaComment(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpGet]
        [Route("BuildCriteria/{id:long}")]
        public IHttpActionResult GetBuildCriteria(long id)
        {
            BuildCriteria result = new AutoCheckerService().GetBuildCriteria(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("BuildCriteriaDetails/{id:long}")]
        public IHttpActionResult GetBuildCriteriaDetails(long id, long? idCompare = null)
        {
            BuildCriteriaDetails result = new AutoCheckerService().GetBuildCriteriaDetails(Functions.GetLoggedInUserId(), id, idCompare);
            return Ok(result);
        }

        [HttpGet]
        [Route("BuildCriteriaAndVersions")]
        public IHttpActionResult GetBuildCriteriaAndVersions(int designId, int fabricationFacilityId, int? testFlowId = null, int? probeConversionId = null)
        {
            BuildCriteriaAndVersions result = new AutoCheckerService().GetBuildCriteriaAndVersions(Functions.GetLoggedInUserId(), designId, fabricationFacilityId, testFlowId, probeConversionId);
            return Ok(result);
        }

        [HttpPost]
        [Route("ApproveBuildCriteria")]
        public IHttpActionResult ApproveBuildCriteria(ReviewDecisionDto decision)
        {
            var result = new AutoCheckerService().ApproveBuildCriteria(Functions.GetLoggedInUserId(), decision);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("CancelBuildCriteria")]
        public IHttpActionResult CancelBuildCriteria(DraftDecisionDto decision)
        {
            var result = new AutoCheckerService().CancelBuildCriteria(Functions.GetLoggedInUserId(), decision);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("RejectBuildCriteria")]
        public IHttpActionResult RejectBuildCriteria(ReviewDecisionDto decision)
        {
            var result = new AutoCheckerService().RejectBuildCriteria(Functions.GetLoggedInUserId(), decision);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("SubmitBuildCriteria")]
        public IHttpActionResult SubmitBuildCriteria(DraftDecisionDto decision)
        {
            var result = new AutoCheckerService().SubmitBuildCriteria(Functions.GetLoggedInUserId(), decision);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }
    }
}