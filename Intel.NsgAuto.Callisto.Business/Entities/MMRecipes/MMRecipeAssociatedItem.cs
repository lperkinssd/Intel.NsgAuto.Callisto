namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes
{
    public class MMRecipeAssociatedItem
    {
        public int MATId { get; set; }
        public SpeedItemCategory SpeedItemCategory { get; set; }
        public string ItemId { get; set; }
        public string Revision { get; set; }
        public SpeedBomAssociationType SpeedBomAssociationType { get; set; }
    }
}
