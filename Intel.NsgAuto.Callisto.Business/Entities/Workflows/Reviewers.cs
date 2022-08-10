using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class Reviewers : List<Reviewer>
    {
        public Reviewer GetById(int ReviewerId)
        {
            Reviewer reviewer = null;
            var result = (from p in this
                          where p.ReviewerId == ReviewerId
                          select p).FirstOrDefault();
            if (result != null)
            {
                reviewer = (Reviewer)result;
            }
            return reviewer;
        }
    }
}
