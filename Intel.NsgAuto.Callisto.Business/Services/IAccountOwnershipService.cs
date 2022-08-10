using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    interface IAccountOwnershipService
    {
        AccountOwnershipMetaData GetAll(string userId);

        EntitySingleMessageResult<AccountOwnerships> CreateAccountOwnership(string userId, AccountOwnership entity);

        EntitySingleMessageResult<AccountOwnerships> UpdateAccountOwnership(string userId, AccountOwnership entity);

        EntitySingleMessageResult<AccountOwnerships> DeleteAccountOwnership(string userId, int Id);
    }
}
