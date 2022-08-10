using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class BuildCombination
    {
        public int Id { get; set; }
        public bool IsActive { get; set; }
        public Product Design { get; set; }
        public PartUseType PartUseType { get; set; }
        public string MaterialMasterField { get; set; }
        public string IntelLevel1PartNumber { get; set; }
        public string IntelProdName { get; set; }
        public string IntelMaterialPn { get; set; }
        public string AssyUpi { get; set; }
        public string DeviceName { get; set; }
        public string Mpp { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public bool IsPublishable { get; set; }
        public string PublishDisabledBy { get; set; }
        public DateTime? PublishDisabledOn { get; set; }
        public long? PorBuildCriteriaSetId { get; set; }
        public int? OsatId { get; set; }
        public string OsatName { get; set; }
    }
}
