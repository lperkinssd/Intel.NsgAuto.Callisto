using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.Workflows;
using Intel.NsgAuto.Shared.DirectoryServices;
using Intel.NsgAuto.Shared.Extensions;
using System.Data;

namespace Intel.NsgAuto.Callisto.Business.Core.Extensions
{
    /// <summary>
    /// Extension methods that are designed to be consistent with the base worflow entities (in Entities/Workflows).
    /// </summary>
    public static class DataReaderReviewExtensions
    {
        /// <summary>
        /// Creates a new review object using the specified data reader. The reader must have at least 4 consecutive result sets in the order:
        /// review stages, review groups, reviewers, and review decisions. The current result set must be the first of those, review stages.
        /// Afterward, the reader will be advanced to the last record of review decisions and any remaining result sets could potentially
        /// be read.
        /// </summary>
        public static Review NewReview(this IDataReader reader)
        {
            Review result = new Review();

            // #1 result set: review stages
            while (reader.Read())
            {
                ReviewStep step = new ReviewStep()
                {
                    ReviewStage = reader.NewReviewStage(),
                };
                result.ReviewSteps.Add(step);
            }

            // #2 result set: review groups
            reader.NextResult();
            while (reader.Read())
            {
                ReviewGroupReviewer groupReviewer = new ReviewGroupReviewer()
                {
                    ReviewGroup = reader.NewReviewGroup(),
                };
                result.ReviewSteps.GetStepByStageId(groupReviewer.ReviewGroup.ReviewStageId).ReviewGroupReviewers.Add(groupReviewer);
            }

            // #3 result set: reviewers
            reader.NextResult();
            while (reader.Read())
            {
                Reviewer reviewer = reader.NewReviewer();
                result.ReviewSteps.GetStepByStageId(reviewer.ReviewStageId).ReviewGroupReviewers.GetById(reviewer.ReviewGroupId).Reviewers.Add(reviewer);
            }

            // #4 result set: review decisions
            reader.NextResult();
            while (reader.Read())
            {
                ReviewDecision decision = new ReviewDecision()
                {
                    Id = reader["Id"].ToLongSafely(),
                    SnapshotReviewerId = reader["SnapshotReviewerId"].ToLongSafely(),
                    VersionId = reader["VersionId"].ToLongSafely(),
                    ReviewStageId = reader["ReviewStageId"].ToIntegerSafely(),
                    ReviewGroupId = reader["ReviewGroupId"].ToIntegerSafely(),
                    ReviewerId = reader["ReviewerId"].ToIntegerSafely(),
                    IsApproved = reader["IsApproved"].ToNullableBooleanSafely(),
                    Comment = reader["Comment"].ToStringSafely(),
                    ReviewedOn = reader["ReviewedOn"].ToDateTimeSafely().SpecifyKindUtc(),
                };
                Reviewer reviewer = result.ReviewSteps.GetStepByStageId(decision.ReviewStageId).ReviewGroupReviewers.GetById(decision.ReviewGroupId).Reviewers.GetById(decision.ReviewerId);
                switch (decision.IsApproved)
                {
                    case null:
                        reviewer.ReviewStatus = ReviewStatus.Open;
                        reviewer.ReviewStatusText = "open";
                        break;
                    case true:
                        reviewer.ReviewStatus = ReviewStatus.Approved;
                        reviewer.ReviewStatusText = "approved";
                        break;
                    case false:
                        reviewer.ReviewStatus = ReviewStatus.Rejected;
                        reviewer.ReviewStatusText = "rejected";
                        break;
                }
                reviewer.Comment = decision.Comment;
                reviewer.ReviewDate = decision.ReviewedOn;
            }

            result.PrepareAfterDataBind();

            return result;
        }

        public static EmailTemplate NewEmailTemplate(this IDataRecord record)
        {
            return new EmailTemplate()
            {
                Id = record["Id"].ToIntegerSafely(),
                Name = record["Name"].ToStringSafely(),
                IsHtml = record["IsHtml"].ToStringSafely().ToBooleanSafely(),
                Subject = record["Subject"].ToStringSafely(),
                BodyXsl = new EmailTemplateBodyXsl()
                {
                    Id = record["BodyXslId"].ToIntegerSafely(),
                    Name = record["BodyXslName"].ToStringSafely(),
                    Value = record["BodyXslValue"].ToStringSafely(),
                },
                BodyXml = record["BodyXml"].ToStringSafely(),
            };
        }

        public static EmailTemplates NewEmailTemplates(this IDataReader reader)
        {
            EmailTemplates result = new EmailTemplates();
            while (reader.Read())
            {
                result.Add(reader.NewEmailTemplate());
            }
            return result;
        }

        public static Employee NewEmployee(this IDataRecord record)
        {
            return new Employee()
            {
                Name = record["Name"].ToStringSafely(),
                Idsid = record["Idsid"].ToStringSafely(),
                WWID = record["Wwid"].ToStringSafely(),
                Email = record["Email"].ToStringSafely(),
            };
        }

        public static ReviewEmail NewReviewEmail(this IDataRecord record)
        {
            return new ReviewEmail()
            {
                EmailTemplateId = record["EmailTemplateId"].ToIntegerSafely(),
                To = record["To"].ToStringSafely(),
                Cc = record["Cc"].ToStringSafely(),
                Bcc = record["Bcc"].ToStringSafely(),
                RecipientName = record["RecipientName"].ToStringSafely(),
                VersionDescription = record["VersionDescription"].ToStringSafely(),
                ReviewAtDescription = record["ReviewAtDescription"].ToStringSafely(),
            };
        }

        public static ReviewEmails NewReviewEmails(this IDataReader reader)
        {
            ReviewEmails result = new ReviewEmails();
            while (reader.Read())
            {
                result.Add(reader.NewReviewEmail());
            }
            return result;
        }

        public static Reviewer NewReviewer(this IDataRecord record)
        {
            return new Reviewer()
            {
                Id = record["Id"].ToLongSafely(),
                VersionId = record["VersionId"].ToLongSafely(),
                ReviewStageId = record["ReviewStageId"].ToIntegerSafely(),
                ReviewGroupId = record["ReviewGroupId"].ToIntegerSafely(),
                ReviewerId = record["ReviewerId"].ToIntegerSafely(),
                Idsid = record["Idsid"].ToStringSafely(),
                Wwid = record["Wwid"].ToStringSafely(),
                Employee = record.NewEmployee(),
            };
        }

        public static ReviewGroup NewReviewGroup(this IDataRecord record)
        {
            return new ReviewGroup()
            {
                Id = record["Id"].ToLongSafely(),
                VersionId = record["VersionId"].ToLongSafely(),
                ReviewStageId = record["ReviewStageId"].ToIntegerSafely(),
                ReviewGroupId = record["ReviewGroupId"].ToIntegerSafely(),
                GroupName = record["GroupName"].ToStringSafely(),
                DisplayName = record["DisplayName"].ToStringSafely(),
                IsCheckListCompleted = true,
            };
        }

        public static ReviewStage NewReviewStage(this IDataRecord record)
        {
            return new ReviewStage()
            {
                Id = record["Id"].ToLongSafely(),
                VersionId = record["VersionId"].ToLongSafely(),
                ReviewStageId = record["ReviewStageId"].ToIntegerSafely(),
                StageName = record["StageName"].ToStringSafely(),
                DisplayName = record["DisplayName"].ToStringSafely(),
                Sequence = record["Sequence"].ToIntegerSafely(),
                ParentStageId = record["ParentStageId"].ToIntegerSafely(),
                IsNextInParallel = (bool)record["IsNextInParallel"].ToNullableBooleanSafely(),
            };
        }
    }
}
