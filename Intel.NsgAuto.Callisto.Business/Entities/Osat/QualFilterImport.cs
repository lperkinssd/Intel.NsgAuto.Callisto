using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterImport
    {
        public int Id { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByUserName { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedByUserName { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string FileName { get; set; }
        public int FileLengthInBytes { get; set; }
        public bool MessageErrorsExist { get; set; }
        public bool AllowBuildCriteriaActions { get; set; }
        public Product Design { get; set; }
    }
}
