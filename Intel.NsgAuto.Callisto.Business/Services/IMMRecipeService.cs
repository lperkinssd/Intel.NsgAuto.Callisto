using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public interface IMMRecipeService
    {
        MMRecipes GetAll(string userId);
        MMRecipe Get(string userId, long id);
    }
}
