using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/Customers")]
    public class CustomersApiController : ApiController
    {
        [HttpGet]
        [Route("")]
        public IHttpActionResult GetAll()
        {
            Customers result = new CustomersService().GetAll(Functions.GetLoggedInUserId());
            return Ok(result);
        }
    }
}
