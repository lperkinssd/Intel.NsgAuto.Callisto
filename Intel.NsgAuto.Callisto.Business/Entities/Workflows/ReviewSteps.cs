using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewSteps : List<ReviewStep>
    {
        public ReviewStep GetStepByStageId(int StageId)
        {
            ReviewStep step = null;
            var result = (from p in this
                          where p.ReviewStage.ReviewStageId == StageId
                          select p).FirstOrDefault();
            if (result != null)
            {
                step = result;
            }
            return step;
        }
    }
}
