using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/Products")]
    public class ProductsApiController : ApiController
    {
        [HttpGet]
        [Route("{id:int}")]
        public IHttpActionResult Get(int id)
        {
            var result = new ProductsService().Get(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }
    }
}
