using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class Design : IDesign
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DesignFamily DesignFamily { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
