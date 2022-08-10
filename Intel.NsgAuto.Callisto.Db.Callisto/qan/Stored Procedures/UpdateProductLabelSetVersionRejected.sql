-- ==============================================================================
-- Author       : bricschx
-- Create date  : 2020-09-24 15:57:50.847
-- Description  : Rejects a product label version
-- Example      : EXEC [qan].[UpdateProductLabelSetVersionRejected] 'bricschx', 1
-- ==============================================================================
CREATE PROCEDURE [qan].[UpdateProductLabelSetVersionRejected]
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

	SELECT @NewStatusId = MIN([Id]) FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Rejected';
	SELECT @Count = COUNT(*), @CurrentStatus = MIN(S.[Name]) FROM [qan].[ProductLabelSetVersions] AS V WITH (NOLOCK) LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (V.[StatusId] = S.[Id]) WHERE V.[Id] = @Id;

	IF (@Count > 0 AND @NewStatusId IS NOT NULL AND ((@CurrentStatus IN ('Submitted', 'In Review') /* TODO: UserId validation, e.g.: AND @UserId IN (ValidReviewUserIds) */) OR @Override = 1))
	BEGIN
		UPDATE [qan].[ProductLabelSetVersions] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;
	END;

	EXEC [qan].[GetProductLabelSetVersions] @UserId, @Id;

END