namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class ManageBuildCriteria
    {
        public AttributeTypes AttributeTypes { get; set; }
        public Designs Designs { get; set; }
        public IdAndNames FabricationFacilities { get; set; }
        public IdAndNames ProductFamilies { get; set; }
        public IdAndNames Devices { get; set; }
        public IdAndNames Capacities { get; set; }
        public IdAndNames Scodes { get; set; }
        public IdAndNames MediaIPNs { get; set; }
        public BuildCriteria BuildCriteria { get; set; }
        public PrototypeConditions PrototypeConditions { get; set; }
    }
}
