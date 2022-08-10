using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public interface IReviewer
    {
		int Id { get; set; }
		string Idsid { get; set; }
		string WWID { get; set; }
		string Name { get; set; }
		string Email { get; set; }
		/// <summary>
		/// Gets\Sets the user attributes
		/// </summary>
		Employee Attributes { get; set; }
		Reviewer Copy();
	}
}
