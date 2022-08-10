using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Osat
{
    public class PasCombination
    {
        public int Id { get; set; }
        public Osat Osat { get; set; }
        public DesignFamily DesignFamily { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
