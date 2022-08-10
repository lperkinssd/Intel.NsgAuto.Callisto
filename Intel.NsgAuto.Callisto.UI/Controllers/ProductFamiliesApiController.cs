using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/ProductFamilies")]
    public class ProductFamiliesApiController : ApiController
    {
        [HttpGet]
        [Route("")]
        public IHttpActionResult GetAll()
        {
            ProductFamilies result = new ProductFamiliesService().GetAll(Functions.GetLoggedInUserId());
            return Ok(result);
        }
    }
}
