using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public class MATAttribute : IMATAttribute
    {
        public int Id { get; set; }
        public int MATId { get; set; }
        public string Name { get; set; }
        public string NameDisplay { get; set; }
        public string Value { get; set; }
        public string Operator { get; set; }
        public string DataType { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
