using Intel.NsgAuto.Web.Mvc.Core;
using System;
using System.Web.Http;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Services;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/Administration")]
    public class AdministrationApiController : ApiController
    {
        [HttpGet]
        [Route("GetPreferredRole")]
        public IHttpActionResult GetPreferredRole()
        {
            string preferredRole = new AdministrationService().GetPreferredRole(Functions.GetLoggedInUserId());
            return Ok(preferredRole);
        }

        [HttpPost]
        //[Route("SavePreferredRole")]
        [Route("SavePreferredRole/{currentSelectedRole}")]
        public IHttpActionResult SavePreferredRole(string currentSelectedRole)
        {
            AdministrationResult result = new AdministrationService().SavePreferredRole(Functions.GetLoggedInUserId(), currentSelectedRole);
            return Ok(result);
        }
    }
}