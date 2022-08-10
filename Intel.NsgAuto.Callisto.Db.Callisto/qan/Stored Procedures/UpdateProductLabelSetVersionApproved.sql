-- ==============================================================================
-- Author       : bricschx
-- Create date  : 2020-09-24 16:07:41.713
-- Description  : Approves a product label version
-- Example      : EXEC [qan].[UpdateProductLabelSetVersionApproved] 'bricschx', 1
-- ==============================================================================
CREATE PROCEDURE [qan].[UpdateProductLabelSetVersionApproved]
(
	  @UserId VARCHAR(25)
	, @Id INT
	, @Override BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT;
	DECLARE @CurrentStatus VARCHAR(25);
	DECLARE @NewStatusId INT;

	-- For now just setting to a complete status as would happen when the last reviewer approves
	-- TODO: complete approval/review process
	SELECT @NewStatusId = MIN([Id]) FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Complete';
	SELECT @Count = COUNT(*), @CurrentStatus = MIN(S.[Name]) FROM [qan].[ProductLabelSetVersions] AS V WITH (NOLOCK) LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (V.[StatusId] = S.[Id]) WHERE V.[Id] = @Id;

	IF (@Count > 0 AND @NewStatusId IS NOT NULL AND ((@CurrentStatus IN ('Submitted', 'In Review') /* TODO: UserId validation, e.g.: AND @UserId IN (ValidReviewUserIds) */) OR @Override = 1))
	BEGIN
		UPDATE [qan].[ProductLabelSetVersions] SET [IsPOR] = 0, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [IsPOR] = 1;
		UPDATE [qan].[ProductLabelSetVersions] SET [IsPOR] = 1, [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;
	END;

	EXEC [qan].[GetProductLabelSetVersions] @UserId, @Id;

END