using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class PasVersion
    {
        public int Id { get; set; }
        public int Version { get; set; }
        public bool IsActive { get; set; }
        public bool IsPOR { get; set; }
        public Status Status { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByUserName { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedByUserName { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string OriginalFileName { get; set; }
        public int FileLengthInBytes { get; set; }
        public PasVersionRecords Records { get; set; }
        public PasCombination Combination { get; set; }
    }
}
