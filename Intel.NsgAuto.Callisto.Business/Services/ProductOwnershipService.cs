using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.ProductOwnerships;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class ProductOwnershipService : IProductOwnershipService
    {
        public ProductOwnershipMetaData GetAll(string userId)
        {
            return new ProductOwnershipDataContext().GetAll(userId);
        }

        public EntitySingleMessageResult<ProductOwnerships> CreateProductOwnership(string userId, ProductOwnership entity)
        {
            return new ProductOwnershipDataContext().CreateProductOwnerShip(userId,entity);
        }

        public EntitySingleMessageResult<ProductOwnerships> UpdateProductOwnership(string userId, ProductOwnership entity)
        {
            return new ProductOwnershipDataContext().UpdateProductOwnerShip(userId, entity);
        }

        public EntitySingleMessageResult<ProductOwnerships> DeleteProductOwnership(string userId, int Id)
        {
            return new ProductOwnershipDataContext().DeleteProductOwnerShip(userId, Id);
        }


    }
}
