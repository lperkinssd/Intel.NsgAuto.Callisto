using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/SpeedItems")]
    public class SpeedItemsApiController : ApiController
    {
        [HttpGet]
        [Route("OfType/{type}")]
        public IHttpActionResult GetAllOfType(string type)
        {
            var result = new SpeedItemsService().GetItemDetailV2Records(Functions.GetLoggedInUserId(), type);
            return Ok(result);
        }
    }
}
