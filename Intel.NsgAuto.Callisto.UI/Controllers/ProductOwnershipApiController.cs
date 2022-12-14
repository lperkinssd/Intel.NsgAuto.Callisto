using Intel.NsgAuto.Callisto.Business.Applications;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships;
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
    [RoutePrefix("api/ProductOwnership")]
    public class ProductOwnershipApiController : ApiController
    {
        [HttpPost]
        [Route("CreateProductOwnership")]
        public IHttpActionResult CreateProductOwnership(ProductOwnership entity)
        {
            EntitySingleMessageResult<ProductOwnerships> result = new ProductOwnershipService().CreateProductOwnership(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("DeleteProductOwnership/{id:int}")]
        public IHttpActionResult Delete(int id)
        {
            var result = new ProductOwnershipService().DeleteProductOwnership(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("UpdateProductOwnership")]
        public IHttpActionResult UpdateProductOwnership(ProductOwnership entity)
        {
                EntitySingleMessageResult<ProductOwnerships> result = new ProductOwnershipService().UpdateProductOwnership(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }
    }
}