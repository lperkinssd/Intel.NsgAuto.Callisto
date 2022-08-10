using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class AttributeType
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string NameDisplay { get; set; }
        public AttributeDataType DataType { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
