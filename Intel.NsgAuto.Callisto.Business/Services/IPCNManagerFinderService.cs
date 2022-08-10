using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace Intel.NsgAuto.Callisto.Business.Services
{
    interface IPCNManagerFinderService
    {
        PCNManagerMetadata GetAll(string userId);

        EntitySingleMessageResult<Approvers> GetApproverList(string userId, PCNManagerFilter entity);
    }
}
