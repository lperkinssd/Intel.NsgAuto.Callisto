using System;
using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public interface IReviewer
    {
        long Id { get; set; }
        long VersionId { get; set; }
        int ReviewStageId { get; set; }
        int ReviewGroupId { get; set; }
        int ReviewerId { get; set; }
        string Wwid { get; set; }
        string Idsid { get; set; }
        Employee Employee { get; set; }
        ReviewStatus ReviewStatus { get; set; }
        string ReviewStatusText { get; set; }
        string Comment { get; set; }
        DateTime ReviewDate { get; set; }
    }
}
