-- ==============================================================================
-- Author       : bricschx
-- Create date  : 2020-09-24 15:15:58.670
-- Description  : Cancels a product label version
-- Example      : EXEC [qan].[UpdateProductLabelSetVersionCanceled] 'bricschx', 1
-- ==============================================================================
CREATE PROCEDURE [qan].[UpdateProductLabelSetVersionCanceled]
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
	DECLARE @CreatedBy VARCHAR(25);
	DECLARE @NewStatusId INT;

	SELECT @NewStatusId = MIN([Id]) FROM [ref].[Statuses] WITH (NOLOCK) WHERE [Name] = 'Canceled';
	SELECT @Count = COUNT(*), @CurrentStatus = MIN(S.[Name]), @CreatedBy = MIN(V.[CreatedBy]) FROM [qan].[ProductLabelSetVersions] AS V WITH (NOLOCK) LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (V.[StatusId] = S.[Id]) WHERE V.[Id] = @Id;

	IF (@Count > 0 AND @NewStatusId IS NOT NULL AND ((@CurrentStatus = 'Draft' AND @UserId = @CreatedBy) OR @Override = 1))
	BEGIN
		UPDATE [qan].[ProductLabelSetVersions] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;
	END;

	EXEC [qan].[GetProductLabelSetVersions] @UserId, @Id;

END