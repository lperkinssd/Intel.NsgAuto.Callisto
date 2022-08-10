using Intel.NsgAuto.Web.Mvc.Core;
using System;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/Application")]
    public class ApplicationApiController : ApiController
    {
        [HttpGet]
        [Route("LoggedInUserId")]
        public IHttpActionResult LoggedInUserId()
        {
            return Ok(Functions.GetLoggedInUserId());
        }

        [HttpGet]
        [Route("TestOk")]
        public IHttpActionResult TestOk()
        {
            return Ok("Test ok request data");
        }

        [HttpGet]
        [Route("TestNotFound")]
        public IHttpActionResult TestNotFound()
        {
            return NotFound();
        }

        [HttpGet]
        [Route("TestBadRequest")]
        public IHttpActionResult TestBadRequest()
        {
            return BadRequest("Test bad request message");
        }

        [HttpGet]
        [Route("TestException")]
        public IHttpActionResult TestException()
        {
            throw new Exception("Test exception message");
        }
    }
}
