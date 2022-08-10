using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public interface IRequestStatusReport
	{
		Guid Id { get; set; }
		string Process { get; set; }
		string Product { get; set; }
		string Layer { get; set; }
		string TapeoutId { get; set; }
		string Project { get; set; }
		string Stage { get; set; }
		int StageSequence { get; set; }
		string Group { get; set; }
		RequestStatus RequestStatus { get; set; }
		string GroupStatus { get; set; }
	}
}
