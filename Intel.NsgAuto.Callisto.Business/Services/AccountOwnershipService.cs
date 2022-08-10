using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class AccountOwnershipService :IAccountOwnershipService
    {
        public AccountOwnershipMetaData GetAll(string userId)
        {
            return new AccountOwnershipDataContext().GetAll(userId);
        }

        public EntitySingleMessageResult<AccountOwnerships> CreateAccountOwnership(string userId, AccountOwnership entity)
        {
            return new AccountOwnershipDataContext().CreateAccountOwnerShip(userId, entity);
        }

        public EntitySingleMessageResult<AccountOwnerships> UpdateAccountOwnership(string userId, AccountOwnership entity)
        {
            return new AccountOwnershipDataContext().UpdateAccountOwnerShip(userId, entity);
        }

        public EntitySingleMessageResult<AccountOwnerships> DeleteAccountOwnership(string userId, int Id)
        {
            return new AccountOwnershipDataContext().DeleteAccountOwnerShip(userId, Id);
        }

    }
}
