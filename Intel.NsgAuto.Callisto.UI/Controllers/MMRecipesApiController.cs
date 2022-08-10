using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Net;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/MMRecipes")]
    public class MMRecipesApiController : ApiController
    {
        [HttpGet]
        [Route("{id:long}")]
        public IHttpActionResult Get(long id)
        {
            var result = new MMRecipesService().Get(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("")]
        public IHttpActionResult GetAll()
        {
            var result = new MMRecipesService().GetAll(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("GetReviewables")]
        public IHttpActionResult GetReviewables()
        {
            var result = new MMRecipesService().GetReviewables(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpPost]
        [Route("Approve")]
        public IHttpActionResult Approve(ReviewDecisionDto decision)
        {
            var result = new MMRecipesService().Approve(Functions.GetLoggedInUserId(), decision);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Cancel/{id:int}")]
        public IHttpActionResult Cancel(int id)
        {
            var result = new MMRecipesService().Cancel(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Reject")]
        public IHttpActionResult Reject(ReviewDecisionDto decision)
        {
            var result = new MMRecipesService().Reject(Functions.GetLoggedInUserId(), decision);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Submit/{id:int}")]
        public IHttpActionResult Submit(int id)
        {
            var result = new MMRecipesService().Submit(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("Update")]
        public IHttpActionResult Update(MMRecipeUpdate model)
        {
            var result = new MMRecipesService().Update(Functions.GetLoggedInUserId(), model);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }
    }
}
