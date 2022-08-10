using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class Product : IProduct
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public DesignFamily DesignFamily { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public MixType MixType { get; set; }
    }
}