using System;
using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public interface IImportDispositionsResponse
    {
        /// <summary>
        /// Gets/Sets the version for the dispositions imported to the system
        /// </summary>
        int Version { get; set; }
        /// <summary>
        /// Gets/Sets the dispositions
        /// </summary>
        Dispositions Dispositions { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
        DispositionVersions Versions { get; set; }
    }
}