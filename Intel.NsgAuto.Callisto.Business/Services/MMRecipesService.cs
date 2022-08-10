using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.MMRecipes;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class MMRecipesService : IMMRecipeService
    {
        public MMRecipes GetAll(string userId)
        {
            return new MMRecipesDataContext().GetAll(userId);
        }

        public MMRecipes GetReviewables(string userId)
        {
            return new MMRecipesDataContext().GetReviewables(userId);
        }

        public MMRecipeDetails SimulateDetails(string userId, string pcode)
        {
            return new MMRecipesDataContext().SimulateDetails(userId, pcode);
        }

        public MMRecipe Get(string userId, long id)
        {
            return new MMRecipesDataContext().Get(userId, id);
        }

        public MMRecipeDetails GetDetails(string userId, long id)
        {
            return new MMRecipesDataContext().GetDetails(userId, id);
        }

        public EntitySingleMessageResult<MMRecipeDetails> Approve(string userId, ReviewDecisionDto decision)
        {
            return new MMRecipesDataContext().Approve(userId, decision);
        }

        public EntitySingleMessageResult<MMRecipeDetails> Cancel(string userId, long id)
        {
            return new MMRecipesDataContext().Cancel(userId, id);
        }

        public EntitySingleMessageResult<MMRecipeDetails> Reject(string userId, ReviewDecisionDto decision)
        {
            return new MMRecipesDataContext().Reject(userId, decision);
        }

        public EntitySingleMessageResult<MMRecipeDetails> Submit(string userId, long id)
        {
            return new MMRecipesDataContext().Submit(userId, id);
        }

        public SingleMessageResult Update(string userId, MMRecipeUpdate model)
        {
            return new MMRecipesDataContext().Update(userId, model);
        }
    }
}
