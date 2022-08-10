using System.Collections.Generic;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterFiles : List<QualFilterFile>
    {
        public QualFilterFiles() { }

        public QualFilterFiles(IEnumerable<QualFilterFile> files) : base(files) { }
    }
}
