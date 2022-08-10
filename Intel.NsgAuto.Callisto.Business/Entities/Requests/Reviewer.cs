using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public class Reviewer : IReviewer
	{
		public int Id { get; set; }
		public string Idsid { get; set; }
		public string WWID { get; set; }
		public string Name { get; set; }
		public string Email { get; set; }
		/// <summary>
		/// Gets\Sets the user attributes
		/// </summary>
		public Employee Attributes { get; set; }

		public Reviewer Copy()
		{
			return new Reviewer()
			{
				Id = this.Id,
				Attributes = new Employee()
				{
					Idsid = this.Attributes.Idsid,
					WWID = this.Attributes.WWID,
					Name = this.Attributes.Name,
					Email = this.Attributes.Email
				}
			};
		}
	}
}
