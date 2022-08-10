using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public class RequestRequestor : IRequestRequestor
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public string Idsid { get; set; }
		public string Wwid { get; set; }
		public string Email { get; set; }
		public bool IsActive { get; set; }
		public Employee Requestor { get; set; }

	}
}
