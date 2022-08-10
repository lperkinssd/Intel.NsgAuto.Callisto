using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterExport
    {
        public int Id { get; set; }

        public string CreatedBy { get; set; }

        public string CreatedByUserName { get; set; }

        public DateTime CreatedOn { get; set; }

        public string UpdatedBy { get; set; }

        public string UpdatedByUserName { get; set; }

        public DateTime UpdatedOn { get; set; }

        public DateTime? GeneratedOn { get; set; }

        public DateTime? DeliveredOn { get; set; }

        public string FileName { get; set; }

        public int? FileLengthInBytes { get; set; }

        public QualFilterFiles Files { get; set; }
    }
}
