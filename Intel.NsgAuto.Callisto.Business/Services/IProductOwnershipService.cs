using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    interface IProductOwnershipService
    {
        ProductOwnershipMetaData GetAll(string userId);
        EntitySingleMessageResult<ProductOwnerships> CreateProductOwnership(string userId, ProductOwnership entity);

        EntitySingleMessageResult<ProductOwnerships> UpdateProductOwnership(string userId, ProductOwnership entity);
        EntitySingleMessageResult<ProductOwnerships> DeleteProductOwnership(string userId, int Id);

    }
}
