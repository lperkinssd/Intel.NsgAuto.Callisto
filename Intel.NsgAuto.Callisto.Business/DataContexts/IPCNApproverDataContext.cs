using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNApprovers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    interface IPCNApproverDataContext
    {
        PCNApproverMetadata GetAll(string userId);

        EntitySingleMessageResult<Approvers> GetApprovers(PCNApproverFilter PCNApproverFilter, string userId);
        
    }
}
