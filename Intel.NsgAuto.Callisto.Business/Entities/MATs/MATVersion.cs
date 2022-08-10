using Intel.NsgAuto.Callisto.Business.Entities.MATs.Workflows;
using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public class MATVersion : IMATVersion
    {
        public int Id { get; set; }
        public int Version { get; set; }
        public bool IsActive { get; set; }
        public IdAndName Status { get; set; }
        public bool IsPOR { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }

        public MATs MATRecords { get; set; }

        public MATReview Review { get; set; }
    }
}
