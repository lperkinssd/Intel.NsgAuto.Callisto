using System;
using System.Data;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
   public class OsatBuildCriteriaSetBulkImportPending
    {
        public OsatBuildCriteriaSetBulkImportPending()
        {
            Id = Guid.NewGuid().ToString();
        }
        public string Id { get; }
        public int DesignId { get; set; }
        public string FileName { get; set; }
        public string CurrentFile { get; set; }
        public DataSet UploadedDataSet { get; set; }
        public int FileLengthInBytes { get; set; }
    }
}
