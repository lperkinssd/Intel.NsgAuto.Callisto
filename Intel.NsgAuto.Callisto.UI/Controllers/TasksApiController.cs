using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/Tasks")]
    public class TasksApiController : ApiController
    {
        [HttpGet]
        [Route("{id:long}")]
        public IHttpActionResult Get(long id)
        {
            var result = new TasksService().Get(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("Open")]
        public IHttpActionResult Open()
        {
            var result = new TasksService().GetAllOpen(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpGet]
        [Route("Recent/{days:int?}")]
        public IHttpActionResult Recent(int? days = null)
        {
            if (!days.HasValue) days = 3;
            var result = new TasksService().GetAllRecent(Functions.GetLoggedInUserId(), days.Value);
            return Ok(result);
        }

        [HttpPost]
        [Route("Resolve/{id:long}")]
        public IHttpActionResult Resolve(long id)
        {
            string userId = Functions.GetLoggedInUserId();
            var result = new TasksService().Resolve(userId, id, userId);
            return Ok(result);
        }

        [HttpPost]
        [Route("ResolveAllAborted/{id:long}")]
        public IHttpActionResult ResolveAllAborted(long id)
        {
            string userId = Functions.GetLoggedInUserId();
            var result = new TasksService().ResolveAllAborted(userId, id, userId);
            return Ok(result);
        }

        [HttpPost]
        [Route("Unresolve/{id:long}")]
        public IHttpActionResult Unresolve(long id)
        {
            var result = new TasksService().Unresolve(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }
    }
}
