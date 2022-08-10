using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public class Review
    {
        public int Id { get; set; }
        public string Idsid { get; set; }
        public string WWID { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public int RequestId { get; set; }
        public Reviewer Reviewer { get; set; }
        public IdAndName Status { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
