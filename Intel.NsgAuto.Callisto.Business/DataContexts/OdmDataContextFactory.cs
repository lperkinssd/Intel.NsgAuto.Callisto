using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Intel.NsgAuto.Shared.DirectoryServices;
using Intel.NsgAuto.Callisto.Business.Core;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public enum CompanyType
    {
        Iog = 0,
        Npsg = 1
    }

    public class OdmDataContextFactory
    {
        public IIogNpsgDataContext CreateOdmDataContext(string userId)
        {
            return CreateOdmDataContext(getUserCompanyType(userId));
        }

        public IIogNpsgDataContext CreateOdmDataContext(CompanyType companyType)
        {
            switch (companyType)
            {
                case CompanyType.Iog:
                    return new OdmIogDataContext();

                case CompanyType.Npsg:
                    return new OdmNpsgDataContext();

                default:
                    throw new ArgumentException("Unknow Company Type.");
            }
        }

        public IOdmIogDataContext CreateOdmIogDataContext()
        {
            return new OdmIogDataContext();
        }

        public IOdmNpsgDataContext CreateOdmNpsgDataContext()
        {
            return new OdmNpsgDataContext();
        }

        private CompanyType getUserCompanyType(string userId)
        {
            CompanyType companyType = CompanyType.Iog;
            Employee user = new EmployeeDataProvider().GetUser(userId);

            if (user.Roles.Contains(Settings.SuperUserRole))
            {
                string preferredRole = new AdministrationDataContext().GetPreferredRole(userId);
                if (!string.Equals(preferredRole, Settings.CallistoOptaneUserRole, StringComparison.OrdinalIgnoreCase))
                {
                    companyType = CompanyType.Npsg;
                }
            }
            else if (!user.Roles.Contains(Settings.CallistoOptaneUserRole))
            {
                companyType = CompanyType.Npsg;
            }

            return companyType;
        }
    }
}
