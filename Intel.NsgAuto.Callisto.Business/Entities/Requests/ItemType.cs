namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public class ItemType : IItemType
	{
		public int Id { get; set; }
		public string TypeName { get; set; }
		public string ItemTypeDisplay { get; set; }
		public bool IsActive { get; set; }
	}
}
