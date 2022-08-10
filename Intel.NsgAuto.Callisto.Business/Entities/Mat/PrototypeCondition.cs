using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.Mat
{
    public class PrototypeCondition
    {
        public int Id { get; set; }
        public string DesignId { get; set; }
        public string FabricationFacility { get; set; }
        public string Device { get; set; }
        public string ProductFamily { get; set; }
        public string Capacity { get; set; }
        public string Scode { get; set; }
        public string MediaIPN { get; set; }
        public AttributeType AttributeType { get; set; }
        public string ComparisonOperator { get; set; }
        public ComparisonOperation ComparisonOperation { get; set; }
        public LogicalOperation LogicalOperation { get; set; }
        public string Value { get; set; }
    }
}
