namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class QualFilterRecord
    {
        public long Id { get; set; }

        public int ExportId { get; set; }

        public int ExportFileId { get; set; }

        public bool BuildCombinationIsPublishable { get; set; }

        public long BuildCriteriaId { get; set; }

        public long BuildCriteriaSetId { get; set; }

        public Status BuildCriteriaSetStatus { get; set; }

        public int BuildCriteriaOrdinal { get; set; }

        public int OsatId { get; set; }

        public string OsatName { get; set; }

        public int DesignId { get; set; }

        public string DesignName { get; set; }

        public int DesignFamilyId { get; set; }

        public string DesignFamilyName { get; set; }

        public int PackageDieTypeId { get; set; }

        public string PackageDieTypeName { get; set; }

        public string FilterDescription { get; set; }

        public string DeviceName { get; set; }

        public string PartNumberDecode { get; set; }

        public string IntelLevel1PartNumber { get; set; }

        public string IntelProdName { get; set; }

        public string MaterialMasterField { get; set; }

        public string AssyUpi { get; set; }

        public bool IsEngineeringSample { get; set; }

        public QualFilterAttributeValues AttributeValues { get; set; }
    }
}
