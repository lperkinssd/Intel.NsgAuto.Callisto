using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.PCNManagerFinder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    interface IPCNManagerFinderDataContext
    {
        PCNManagerMetadata GetAll(string userId);

        EntitySingleMessageResult<Approvers> GetApprovers(PCNManagerFilter PCNApproverFilter, string userId);

    }
}
