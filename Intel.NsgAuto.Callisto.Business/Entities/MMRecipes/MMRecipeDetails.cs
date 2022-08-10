using Intel.NsgAuto.Callisto.Business.Entities.Workflows;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes
{
    public class MMRecipeDetails
    {
        public MMRecipe MMRecipe { get; set; }
        public CustomerQualStatuses CustomerQualStatuses { get; set; }
        public PLCStages PLCStages { get; set; }
        public Review Review { get; set; }
    }
}
