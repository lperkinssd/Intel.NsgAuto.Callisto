using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    interface IProductOwnershipDataContext
    {
        ProductOwnershipMetaData GetAll(string userId);
        EntitySingleMessageResult<ProductOwnerships> CreateProductOwnerShip(string userId, ProductOwnership entity);
        EntitySingleMessageResult<ProductOwnerships> UpdateProductOwnerShip(string userId, ProductOwnership entity);
        EntitySingleMessageResult<ProductOwnerships> DeleteProductOwnerShip(string userId, int Id);

    }
}
