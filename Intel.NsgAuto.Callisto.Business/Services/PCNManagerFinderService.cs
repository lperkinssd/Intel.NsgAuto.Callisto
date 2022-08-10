using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder;

namespace Intel.NsgAuto.Callisto.Business.Services
{
   public class PCNManagerFinderService : IPCNManagerFinderService
    {
        public PCNManagerMetadata GetAll(string userId)
        {
            return new PCNManagerFinderDataContext().GetAll(userId);
        }

        public EntitySingleMessageResult<Approvers> GetApproverList(string userId, PCNManagerFilter entity)
        {
            return new PCNManagerFinderDataContext().GetApprovers(entity, userId);
        }
    }
}
