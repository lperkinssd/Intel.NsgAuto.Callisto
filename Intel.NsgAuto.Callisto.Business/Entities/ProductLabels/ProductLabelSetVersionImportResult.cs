using Intel.NsgAuto.Callisto.Business.Core;

namespace Intel.NsgAuto.Callisto.Business.Entities.ProductLabels
{
    public class ProductLabelSetVersionImportResult : ImportResult
    {
        public ProductLabelSetVersion Version { get; set; }

        public override int RecordNumberToRowNumber(int recordNumber)
        {
            return recordNumber + ImportSpecifications.ProductLabels.HeaderRows;
        }

        public override string FieldNameDescription(string fieldName)
        {
            return ImportSpecifications.ProductLabels.FieldToColumnName(fieldName);
        }

    }
}
