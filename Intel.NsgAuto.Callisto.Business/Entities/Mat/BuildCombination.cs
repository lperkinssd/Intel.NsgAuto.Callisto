using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class BuildCombination
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Design Design { get; set; }
        public IdAndName FabricationFacility { get; set; }
        public IdAndName ProductFamily { get; set; }
        public IdAndName Capacity { get; set; }
        public IdAndName Scode { get; set; }
        public IdAndName MediaIPN { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
