using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class ImportVersion : IImportVersion
    {
        public int Id { get; set; }
        public int Version { get; set; }
        public string WorkWeek { get; set; }
        public bool IsActive { get; set; }
        public bool IsPOR { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
