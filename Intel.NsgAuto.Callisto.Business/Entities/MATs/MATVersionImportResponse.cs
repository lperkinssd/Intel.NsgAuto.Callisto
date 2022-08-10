using Intel.NsgAuto.Callisto.Business.Core;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public class MATVersionImportResponse : ImportResult
    {
        public MATVersion Version { get; set; }

        public MATs Mats { get; set; }

        public override int RecordNumberToRowNumber(int recordNumber)
        {
            return recordNumber + ImportSpecifications.MATs.HeaderRows;
        }

        public override string FieldNameDescription(string fieldName)
        {
            return ImportSpecifications.MATs.FieldToColumnName(fieldName);
        }

    }
}
