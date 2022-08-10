using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Intel.NsgAuto.Callisto.Business.Services
{
    interface IPCNApproverService
    {
        PCNApproverMetadata GetAll(string userId);

        EntitySingleMessageResult<Approvers> GetApproverList(string userId, PCNApproverFilter entity);
    }
}
