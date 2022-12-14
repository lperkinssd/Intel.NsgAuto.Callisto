using Intel.NsgAuto.Shared.DirectoryServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.App
{
    public interface IUser
    {
        /// <summary>
        /// Gets\Sets the user attributes
        /// </summary>
        Employee Attributes { get; set; }

        /// <summary>
        /// Gets\Sets the process speciic roles for the employee.
        /// This is only a placeholder property
        /// </summary>
        ProcessRoles ProcessRoles { get; set; }
    }
}
