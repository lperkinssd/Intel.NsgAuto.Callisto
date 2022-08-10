using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.AutoChecker;
using Intel.NsgAuto.Callisto.Business.Entities.AutoChecker.Workflows;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class AutoCheckerService
    {
        public EntitySingleMessageResult<AttributeTypes> CreateAttributeType(string userId, AttributeTypeCreateDto entity)
        {
            return new AutoCheckerDataContext().CreateAttributeType(userId, entity);
        }

        public AttributeTypesMetadata GetAttributeTypesMetadata(string userId)
        {
            return new AutoCheckerDataContext().GetAttributeTypesMetadata(userId);
        }

        public EntitySingleMessageResult<long?> CreateBuildCriteria(string userId, BuildCriteriaCreateDto entity)
        {
            return new AutoCheckerDataContext().CreateBuildCriteria(userId, entity);
        }

        public EntitySingleMessageResult<BuildCriteriaComments> CreateBuildCriteriaComment(string userId, BuildCriteriaCommentCreateDto entity)
        {
            return new AutoCheckerDataContext().CreateBuildCriteriaComment(userId, entity);
        }

        public BuildCombinations GetBuildCombinations(string userId)
        {
            return new AutoCheckerDataContext().GetBuildCombinations(userId);
        }

        public BuildCriteria GetBuildCriteria(string userId, long id)
        {
            return new AutoCheckerDataContext().GetBuildCriteria(userId, id);
        }

        public BuildCriteriaExportConditions GetBuildCriteriaExportConditions(string userId)
        {
            return new AutoCheckerDataContext().GetBuildCriteriaExportConditions(userId);
        }

        public BuildCriteriaAndVersions GetBuildCriteriaAndVersions(string userId, int designId, int fabricationFacilityId, int? testFlowId, int? probeConversionId)
        {
            return new AutoCheckerDataContext().GetBuildCriteriaAndVersions(userId, designId, fabricationFacilityId, testFlowId, probeConversionId);
        }

        public BuildCriterias GetBuildCriterias(string userId, bool? isPOR = null)
        {
            return new AutoCheckerDataContext().GetBuildCriterias(userId, isPOR: isPOR);
        }

        public BuildCriteriaCreate GetBuildCriteriaCreate(string userId, long? id)
        {
            return new AutoCheckerDataContext().GetBuildCriteriaCreate(userId, id);
        }

        public BuildCriteriaDetails GetBuildCriteriaDetails(string userId, long id, long? idCompare = null)
        {
            return new AutoCheckerDataContext().GetBuildCriteriaDetails(userId, id, idCompare);
        }

        public Products GetDesigns(string userId)
        {
            return new AutoCheckerDataContext().GetDesigns(userId);
        }

        public EntitySingleMessageResult<AttributeTypes> UpdateAttributeType(string userId, AttributeTypeUpdateDto entity)
        {
            return new AutoCheckerDataContext().UpdateAttributeType(userId, entity);
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> ApproveBuildCriteria(string userId, ReviewDecisionDto decision)
        {
            return new AutoCheckerDataContext().ApproveBuildCriteria(userId, decision);
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> CancelBuildCriteria(string userId, DraftDecisionDto decision)
        {
            return new AutoCheckerDataContext().CancelBuildCriteria(userId, decision);
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> RejectBuildCriteria(string userId, ReviewDecisionDto decision)
        {
            return new AutoCheckerDataContext().RejectBuildCriteria(userId, decision);
        }

        public EntitySingleMessageResult<BuildCriteriaDetails> SubmitBuildCriteria(string userId, DraftDecisionDto decision)
        {
            return new AutoCheckerDataContext().SubmitBuildCriteria(userId, decision);
        }
    }
}
