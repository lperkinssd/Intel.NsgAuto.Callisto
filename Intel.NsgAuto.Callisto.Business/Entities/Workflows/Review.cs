namespace Intel.NsgAuto.Callisto.Business.Entities.Workflows
{
    public class Review
    {
        public bool IsCompleted { get; set; }
        public ReviewSteps ReviewSteps { get; set; }

        public Review()
        {
            IsCompleted = false;
            ReviewSteps = new ReviewSteps();
        }

        public void PrepareAfterDataBind()
        {
            SetStatuses();

            ReviewSteps = CreateSteps(0, ReviewSteps);

            // set the current stage and return its status
            // if it is approved, then it is the last stage with all steps approved, so the review is complete
            // this method also sets parent stages status, so the UI can do its thing
            if (SetCurrentStage(ReviewSteps) == ReviewStatus.Approved) IsCompleted = true;
        }

        #region helpers
        private static ReviewSteps CreateSteps(int parentStageId, ReviewSteps source)
        {
            if (source == null) return null;

            ReviewSteps steps = new ReviewSteps();
            foreach (ReviewStep step in source)
            {
                if (step.ReviewStage.ParentStageId == parentStageId)
                {
                    steps.Add(new ReviewStep()
                    {
                        Status = step.Status,
                        StatusText = step.StatusText,
                        IsCurrentStage = step.IsCurrentStage,
                        ReviewStage = step.ReviewStage,
                        ReviewGroupReviewers = step.ReviewGroupReviewers,
                        ChildSteps = CreateSteps(step.ReviewStage.ReviewStageId, source)
                    });
                }
            }
            return steps;
        }

        private void SetStatuses()
        {
            if (ReviewSteps == null) return;

            int numGroups;
            int numGroupApprovals;
            int numGroupRejects;
            foreach (ReviewStep step in ReviewSteps)
            {
                numGroups = step.ReviewGroupReviewers.Count;
                numGroupApprovals = 0;
                numGroupRejects = 0;

                foreach (ReviewGroupReviewer groupReviewer in step.ReviewGroupReviewers)
                {
                    int numReviewApproved = 0;
                    int numReviewRejected = 0;

                    // group statuses
                    foreach (Reviewer reviewer in groupReviewer.Reviewers)
                    {
                        if (reviewer.ReviewStatus == ReviewStatus.Rejected)
                        {
                            numReviewRejected++;
                            break;
                        }
                        else if (reviewer.ReviewStatus == ReviewStatus.Approved)
                        {
                            numReviewApproved++;
                        }
                    }

                    if (numReviewRejected > 0) // group is rejected if there is even one rejection
                    {
                        groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Rejected;
                        groupReviewer.ReviewGroup.ReviewStatusText = "rejected";
                        numGroupRejects++;
                    }
                    else if (numReviewApproved > 0) // group is approved if there are no rejections and at least one approval
                    {
                        groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Approved;
                        groupReviewer.ReviewGroup.ReviewStatusText = "approved";
                        numGroupApprovals++;
                    }
                    else // otherwise group is still open
                    {
                        groupReviewer.ReviewGroup.ReviewStatus = ReviewStatus.Open;
                        groupReviewer.ReviewGroup.ReviewStatusText = "open";
                    }
                }

                // step statuses
                if (numGroups == numGroupApprovals && numGroups > 0) // step is approved if all of its groups are approved
                {
                    step.Status = ReviewStatus.Approved;
                    step.StatusText = "approved";
                }
                else if (numGroupRejects > 0) // step is rejected if any of its groups are rejected
                {
                    step.Status = ReviewStatus.Rejected;
                    step.StatusText = "rejected";
                }
                else // otherwise step is still open
                {
                    step.Status = ReviewStatus.Open;
                    step.StatusText = "open";
                }
            }
        }

        /// <summary>
        /// Recursively loops throught the Steps, finding which one is the "current stage"
        /// Its the first one with a status of "reject" or "open", and any parallel stages.
        /// If none are found, then the steps are completed.
        /// </summary>
        /// <param name="steps">The steps to look through.</param>
        /// <returns>status of the current stage.  If value is ReviewStatus.Approved, then 
        /// the steps are all approved</returns>
        //bool isParentCurrentStage = false;
        private static ReviewStatus SetCurrentStage(ReviewSteps steps)
        {
            //1. first step (step 1) is always open
            //2. If my previous step (say step 1) is approved, then I will be open to decisions
            //3. If my previous step (say step 1) told me to be open, I will be open to decisions.
            ReviewStatus reviewStatus = ReviewStatus.Open;
            bool isFirstStep;
            bool isPreviousStepApproved;
            ReviewStep step;
            if (steps != null)
            {
                for (int index = 0; index < steps.Count; index++)
                {
                    step = steps[index];
                    // 1. First step is always open. So identify the first step.
                    isFirstStep = (index == 0);
                    if (isFirstStep)
                    {
                        // child or parent, if it is the very first step & not yet approved, is open.
                        // 1. First step is always open. So identify the first step.
                        reviewStatus = step.Status;
                        step.StatusText = reviewStatus.ToString().ToLower();
                        step.IsCurrentStage = (step.Status != ReviewStatus.Approved);
                        isPreviousStepApproved = !step.IsCurrentStage;
                    }
                    else
                    {
                        // if current step is approved, then it is not open
                        if (step.Status == ReviewStatus.Approved)
                        {
                            step.IsCurrentStage = false;
                            reviewStatus = step.Status;
                            step.StatusText = reviewStatus.ToString().ToLower();
                        }
                        else
                        {
                            if (step.Status == ReviewStatus.Rejected)
                            {
                                reviewStatus = step.Status;
                                step.IsCurrentStage = true;
                                //break;
                            }
                            else
                            {
                                step.IsCurrentStage = false;
                                reviewStatus = step.Status;
                                step.StatusText = reviewStatus.ToString().ToLower();
                                // 2. If my previous step (say step 1) is approved, then I will be open to decisions
                                ReviewStep prevStep = steps[index - 1]; // safe, since this is not first step
                                if (prevStep != null)
                                {
                                    isPreviousStepApproved = (prevStep.Status == ReviewStatus.Approved);
                                    step.IsCurrentStage = isPreviousStepApproved;
                                }
                            }
                        }
                    }
                }
            }
            return reviewStatus;
        }
        #endregion
    }
}
