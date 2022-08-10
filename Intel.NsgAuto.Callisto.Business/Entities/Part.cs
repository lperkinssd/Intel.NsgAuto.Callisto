using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class Part : IPart
    {
        public int Id { get; set; }
        public string IntelLevel1PartName { get; set; }
        public bool IsActive { get; set; }
        public string IntelProductName { get; set; }
        public string PRQStage { get; set; }
        public string MM { get; set; }
        public string IntelPartName { get; set; }
        public string TestUPI { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
