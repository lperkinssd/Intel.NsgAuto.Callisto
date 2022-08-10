using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes;
using System;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public interface IMMRecipesDataContext
    {
        MMRecipe Get(string userId, long id);
    }
}