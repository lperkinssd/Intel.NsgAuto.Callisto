using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public interface IReview
    {
        int Id { get; set; }
        string Idsid { get; set; }
        string WWID { get; set; }
        string Name { get; set; }
        string Email { get; set; }
        int RequestId { get; set; }
        Reviewer Reviewer { get; set; }
        IdAndName Status { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
