using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterFile
    {
        public int Id { get; set; }

        public int ExportId { get; set; }

        public string Name { get; set; }

        public Osat Osat { get; set; }

        public Product Design { get; set; }

        public string CreatedBy { get; set; }

        public string CreatedByUserName { get; set; }

        public DateTime CreatedOn { get; set; }

        public string UpdatedBy { get; set; }

        public string UpdatedByUserName { get; set; }

        public DateTime UpdatedOn { get; set; }

        public DateTime? GeneratedOn { get; set; }

        public DateTime? DeliveredOn { get; set; }

        public QualFilterSheets Sheets { get; set; }
    }
}
