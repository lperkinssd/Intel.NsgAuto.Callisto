using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class OsatBuildCriteriaSetBulkUpdateImport
	{
        public int Id { get; set; }
        public string OriginalFileName { get; set; }
        public string CurrentFile { get; set; }
        public int FileLengthInBytes { get; set; }
        public int DesignId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
	}
}
