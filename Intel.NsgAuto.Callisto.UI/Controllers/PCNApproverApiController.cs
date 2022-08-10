using Intel.NsgAuto.Callisto.Business.Applications;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers;
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
    [RoutePrefix("api/PCNApprover")]
    public class PCNApproverApiController : ApiController
    {
        [HttpPost]
        [Route("GetApproverList")]
        public IHttpActionResult GetApproverList(PCNApproverFilter entity)
        {
            EntitySingleMessageResult<Approvers> result = new PCNApproverService().GetApproverList(Functions.GetLoggedInUserId(), entity);
            return Ok(result);
            
        }
    }
}
