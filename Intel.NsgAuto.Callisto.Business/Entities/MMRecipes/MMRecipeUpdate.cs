using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes
{
    public class MMRecipeUpdate
    {
        public long Id { get; set; }
        public DateTime? PRQDate { get; set; }
        public int? CustomerQualStatusId { get; set; }
        public int? PLCStageId { get; set; }
    }
}
