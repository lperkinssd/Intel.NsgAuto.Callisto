using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class ImportDispositionsResponse : Result, IImportDispositionsResponse
    {
        /// <summary>
        /// Gets/Sets the version for the dispositions imported to the system
        /// </summary>
        public int Version { get; set; }
        /// <summary>
        /// Gets/Sets the dispositions
        /// </summary>
        public Dispositions Dispositions { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public DispositionVersions Versions { get; set; }
    }
}
