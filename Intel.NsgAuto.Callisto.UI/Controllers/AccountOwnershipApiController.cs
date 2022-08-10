using Intel.NsgAuto.Callisto.Business.Applications;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships;
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
    [RoutePrefix("api/AccountOwnership")]
    public class AccountOwnershipApiController : ApiController
    {
        [HttpPost]
        [Route("CreateAccountOwnership")]
        public IHttpActionResult CreateAccountOwnership(AccountOwnership entity)
        {
            EntitySingleMessageResult<AccountOwnerships> result = new AccountOwnershipService().CreateAccountOwnership(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("UpdateAccountOwnership")]
        public IHttpActionResult UpdateAccountOwnership([FromBody] AccountOwnership entity)
        {
            EntitySingleMessageResult<AccountOwnerships> result = new AccountOwnershipService().UpdateAccountOwnership(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("DeleteAccountOwnership/{id:int}")]
        public IHttpActionResult Delete(int id )
        {
            EntitySingleMessageResult<AccountOwnerships> result = new AccountOwnershipService().DeleteAccountOwnership(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }
    }
}