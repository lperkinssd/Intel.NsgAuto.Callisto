using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public interface IReviewDecision
    {
        long Id { get; set; }
        long VersionId { get; set; }
        int ReviewStageId { get; set; }
        int ReviewGroupId { get; set; }
        int ReviewerId { get; set; }
        bool? IsApproved { get; set; }
        string Comment { get; set; }
        DateTime ReviewedOn { get; set; }
    }
}
