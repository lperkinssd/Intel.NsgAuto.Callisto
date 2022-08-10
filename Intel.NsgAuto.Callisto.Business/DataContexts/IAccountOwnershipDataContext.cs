using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    interface IAccountOwnershipDataContext
    {
        AccountOwnershipMetaData GetAll(string userId);
        EntitySingleMessageResult<AccountOwnerships> CreateAccountOwnerShip(string userId, AccountOwnership entity);
        EntitySingleMessageResult<AccountOwnerships> UpdateAccountOwnerShip(string userId, AccountOwnership entity);
        EntitySingleMessageResult<AccountOwnerships> DeleteAccountOwnerShip(string userId, int Id);
    }
}
