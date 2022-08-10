using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class ReviewGroupReviewers : List<ReviewGroupReviewer>
    {
        public ReviewGroupReviewer GetById(int GroupId)
        {
            ReviewGroupReviewer group = null;
            var result = (from p in this
                          where p.ReviewGroup.ReviewGroupId == GroupId
                          select p).FirstOrDefault();
            if (result != null)
            {
                group = (ReviewGroupReviewer)result;
            }
            return group;
        }

        public ReviewGroupReviewer GetByName(string GroupName)
        {
            ReviewGroupReviewer group = null;
            var result = (from p in this
                          where p.ReviewGroup.GroupName.Equals(GroupName)
                          select p).FirstOrDefault();
            if (result != null)
            {
                group = (ReviewGroupReviewer)result;
            }
            return group;
        }

        public Reviewer GetByGroupReviewer(int GroupId, int ReviewerId)
        {
            ReviewGroupReviewer group = null;
            Reviewer reviewer = null;
            var result = (from p in this
                          where p.ReviewGroup.ReviewGroupId == GroupId
                          select p).FirstOrDefault();
            if (result != null)
            {
                group = (ReviewGroupReviewer)result;
                reviewer = group.Reviewers.GetById(ReviewerId);
            }
            return reviewer;
        }
    }
}
