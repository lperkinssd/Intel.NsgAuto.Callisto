using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    public class AccountOwnership : IAccountOwnership
    {
        public int Id { get; set; }
        public AccountClient AccountClient { get; set; }

        public AccountCustomer AccountCustomer { get; set; }
        public AccountSubsidiary AccountSubsidiary { get; set; }
        public AccountProduct AccountProduct { get; set; }
        public String AccountProcess { get; set; }



        public AccountContactRole PCN { get; set; }

        public bool IsActive { get; set; }
        public string PCNName { get; set; }

        public string AEName { get; set; }

        public string CMEName { get; set; }

        public string CQEName { get; set; }

        public string FAEName { get; set; }

        public string FSEName { get; set; }



        public string OthersName { get; set; }

        public string Notes { get; set; }

        public string AEManagerName { get; set; }

        public string CQEManagerName { get; set; }

        public string AEManagerBackupName { get; set; }

        public string CQEManagerBackupName { get; set; }
        public string Email { get; set; }


        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }

        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }

        public bool RecordChanged { get;set;}

        public AccountOwnershipContacts AccountOwnershipContacts { get; set; }
    }
}
