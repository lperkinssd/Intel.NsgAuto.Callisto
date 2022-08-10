using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public class RequestReviewDecision : IRequestReviewDecision
	{
		public Guid RequestId { get; set; }
		public int OrderTypeId { get; set; }
		public string ProcessId { get; set; }
		public int RequestReviewStageId { get; set; }
		public int RequestReviewGroupId { get; set; }
		public int RequestReviewReviewerId { get; set; }
		public string Comment { get; set; }
		public bool? IsApproved { get; set; }
		public DateTime ReviewedOn { get; set; }
	}
}
