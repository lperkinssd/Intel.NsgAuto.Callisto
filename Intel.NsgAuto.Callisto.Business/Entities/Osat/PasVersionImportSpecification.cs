using Intel.NsgAuto.Callisto.Business.Entities.Imports;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class PasVersionImportSpecification : ReadOnlySpecification
    {
        public PasVersionImportSpecification() : base(isFirstRowColumnRow: true, worksheetName: "Data")
        {
            AddField(new ReadOnlyField(name: "ProductGroup", columnName: "Product Group"));
            AddField(new ReadOnlyField(name: "Project", columnName: "Project", columnRequired: true));
            AddField(new ReadOnlyField(name: "IntelProdName", columnName: "Intel Prod Name", columnRequired: true));
            AddField(new ReadOnlyField(name: "IntelLevel1PartNumber", columnName: "INTEL Level 1.0 Part Number", columnRequired: true));
            AddField(new ReadOnlyField(name: "Line1TopSideMarking", columnName: "Line 1 Top Side Marking"));
            AddField(new ReadOnlyField(name: "CopyrightYear", columnName: "Copy Right Year", displayName: "Copyright Year"));
            AddField(new ReadOnlyField(name: "SpecNumberField", columnName: "(S) Spec Number Field", displayName: "Spec Number Field", columnRequired: true));
            AddField(new ReadOnlyField(name: "MaterialMasterField", columnName: "(30P) Material Master Field", displayName: "Material Master Field", columnRequired: true));
            AddField(new ReadOnlyField(name: "MaxQtyPerMedia", columnName: "Max Qty Per Media ", displayName: "Max Qty Per Media"));
            AddField(new ReadOnlyField(name: "Media", columnName: "Media"));
            AddField(new ReadOnlyField(name: "RoHsCompliant", columnName: "RoHS, Compliant"));
            AddField(new ReadOnlyField(name: "LotNo", columnName: "Lot No"));
            AddField(new ReadOnlyField(name: "FullMediaReqd", columnName: "Full Media Req’d"));
            AddField(new ReadOnlyField(name: "SupplierPartNumber", columnName: "Supplier Part Number"));
            AddField(new ReadOnlyField(name: "IntelMaterialPn", columnName: "Intel Material P/N*", columnRequired: true));
            AddField(new ReadOnlyField(name: "TestUpi", columnName: "Test UPI", columnRequired: true));
            AddField(new ReadOnlyField(name: "PgTierAndSpeedInfo", columnName: "PG Tier and SPEED Info"));
            AddField(new ReadOnlyField(name: "AssyUpi", columnName: "Assy UPI (Intel UPI) ", displayName: "Assy UPI (Intel UPI)", columnRequired: true));
            AddField(new ReadOnlyField(name: "DeviceName", columnName: "Device Name", columnRequired: true));
            AddField(new ReadOnlyField(name: "Mpp", columnName: "MPP"));
            AddField(new ReadOnlyField(name: "SortUpi", columnName: "SORT UPI"));
            AddField(new ReadOnlyField(name: "ReclaimUpi", columnName: "Reclaim UPI"));
            AddField(new ReadOnlyField(name: "ReclaimMm", columnName: "Reclaim MM"));
            AddField(new ReadOnlyField(name: "ProductNaming", columnName: "Product Naming"));
            AddField(new ReadOnlyField(name: "TwoDidApproved", columnName: "2DID Approved (Yes/No)"));
            AddField(new ReadOnlyField(name: "TwoDidStartedWw", columnName: "2DID Started WW"));
            AddField(new ReadOnlyField(name: "Did", columnName: "DID"));
            AddField(new ReadOnlyField(name: "Group", columnName: "Group"));
            AddField(new ReadOnlyField(name: "Note", columnName: "Note"));
        }
    }
}
