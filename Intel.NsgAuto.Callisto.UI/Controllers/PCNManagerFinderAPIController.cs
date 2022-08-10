using Intel.NsgAuto.Callisto.Business.Applications;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Shared.Extensions;
using Intel.NsgAuto.Web.Mvc.Core;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;
namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/PCNManagerFinder")]
    public class PCNManagerFinderApiController : ApiController
    {
        [HttpPost]
        [Route("GetApproverList")]
        public IHttpActionResult GetApproverList(PCNManagerFilter entity)
        {
            EntitySingleMessageResult<Approvers> result = new PCNManagerFinderService().GetApproverList(Functions.GetLoggedInUserId(), entity);
            return Ok(result);

        }
    }
}