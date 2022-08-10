using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
	public interface IRequestReviewDecision
	{
		Guid RequestId { get; set; }
		int OrderTypeId { get; set; }
		string ProcessId { get; set; }
		int RequestReviewStageId { get; set; }
		int RequestReviewGroupId { get; set; }
		int RequestReviewReviewerId { get; set; }
		string Comment { get; set; }
		bool? IsApproved { get; set; }
		DateTime ReviewedOn { get; set; }
	}
}
