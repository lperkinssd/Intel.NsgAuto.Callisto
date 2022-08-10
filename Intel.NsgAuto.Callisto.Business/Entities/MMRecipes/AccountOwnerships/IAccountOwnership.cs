using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    interface IAccountOwnership
    {
        int Id { get; set; }
        AccountClient AccountClient { get; set; }

        AccountCustomer AccountCustomer { get; set; }
        AccountSubsidiary AccountSubsidiary { get; set; }
        AccountProduct AccountProduct { get; set; }
        String AccountProcess { get; set; }

       // AccountContactRole Approver { get; set; }

        string PCNName { get; set; }

        string AEName { get; set; }

        string CMEName { get; set; }

        string CQEName { get; set; }

        string FAEName { get; set; }

        string FSEName { get; set; }

        bool IsActive { get; set; }

        string OthersName { get; set; }

        string Notes { get; set; }

        string AEManagerName { get; set; }

        string CQEManagerName { get; set; }

        string AEManagerBackupName { get; set; }

        string CQEManagerBackupName { get; set; }

        string Email { get; set; }

        string CreatedBy { get; set; }
         DateTime CreatedOn { get; set; }

         string UpdatedBy { get; set; }
         DateTime UpdatedOn { get; set; }

        bool RecordChanged { get; set; }

        AccountOwnershipContacts AccountOwnershipContacts { get; set; }

    }
}
