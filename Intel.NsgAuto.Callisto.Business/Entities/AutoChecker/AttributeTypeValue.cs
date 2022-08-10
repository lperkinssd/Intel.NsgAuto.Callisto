using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.AutoChecker
{
    public class AttributeTypeValue
    {
        public int Id { get; set; }
        public int AttributeTypeId { get; set; }
        public string Value { get; set; }
        public string ValueDisplay { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
