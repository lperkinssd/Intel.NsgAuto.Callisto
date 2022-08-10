namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public interface IItemType
	{
		int Id { get; set; }
		string TypeName { get; set; }
		string ItemTypeDisplay { get; set; }
		bool IsActive { get; set; }
	}
}
