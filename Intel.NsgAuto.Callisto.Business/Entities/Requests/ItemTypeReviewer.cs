namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public class ItemTypeReviewer : IItemTypeReviewer
    {
        public int Id { get; set; }
        public int ReviewerId { get; set; }
        public int ReviewItemTypeId { get; set; }
        public string Reviewer { get; set; }
        public string ItemType { get; set; }
    }
}
