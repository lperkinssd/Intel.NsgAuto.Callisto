using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class PCNApproverService: IPCNApproverService
    {

        public PCNApproverMetadata GetAll(string userId)
        {
            return new PCNApproverDataContext().GetAll(userId);
        }

       public EntitySingleMessageResult<Approvers> GetApproverList(string userId, PCNApproverFilter entity)
        {
            return new PCNApproverDataContext().GetApprovers(entity,userId);
        }
    }
}
