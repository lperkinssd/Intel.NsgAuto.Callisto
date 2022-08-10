using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public interface IRequestRequestor
	{
		int Id { get; set; }
		string Name { get; set; }
		string Idsid { get; set; }
		string Wwid { get; set; }
		string Email { get; set; }
		bool IsActive { get; set; }
		Employee Requestor { get; set; }
	}
}
