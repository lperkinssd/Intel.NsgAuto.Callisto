-- ==============================================================
-- Author       : bricschx
-- Create date  : 2020-10-13 16:18:02.723
-- Description  : Updates a MM Recipe
-- ==============================================================
CREATE PROCEDURE [qan].[UpdateMMRecipe]
(
	  @Succeeded BIT OUTPUT
	, @Message VARCHAR(500) OUTPUT
	, @UserId VARCHAR(25)
	, @Id BIGINT
	, @PRQDate DATETIME2(7) = NULL
	, @CustomerQualStatusId INT = NULL
	, @PLCStageId INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription VARCHAR (1000) = 'Update';
	DECLARE @Count INT;
	DECLARE @CurrentStatus VARCHAR(25);

	SET @Succeeded = 0;
	SET @Message = NULL;

	SET @ActionDescription = @ActionDescription + '; PRQDate = ' + ISNULL(CONVERT(VARCHAR(20), @PRQDate, 20), 'null')
												+ '; CustomerQualStatusId = ' + ISNULL(CONVERT(VARCHAR(20), @CustomerQualStatusId), 'null')
												+ '; PLCStageId = ' + ISNULL(CONVERT(VARCHAR(20), @PLCStageId), 'null');

	SELECT @Count = COUNT(*), @CurrentStatus = MIN(S.[Name])
	FROM [qan].[MMRecipes] AS M WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[Statuses] AS S WITH (NOLOCK) ON (M.[StatusId] = S.[Id])
	WHERE M.[Id] = @Id;

	IF (@PRQDate IS NULL)
	BEGIN
		SET @Message = 'PRQ Date is required';
	END
	ELSE IF (NOT @Count = 1)
	BEGIN
		SET @Message = 'MM recipe is invalid: ' + ISNULL(CONVERT(VARCHAR(20), @Id), 'null');
	END
	ELSE IF (@CurrentStatus = 'Draft' OR @CurrentStatus = 'Submitted')
	BEGIN
		UPDATE [qan].[MMRecipes] SET
			  [PRQDate] = @PRQDate
			, [CustomerQualStatusId] = @CustomerQualStatusId
			, [PLCStageId] = @PLCStageId
			, [UpdatedBy] = @UserId
			, [UpdatedOn] = GETUTCDATE()
		WHERE [Id] = @Id;
		IF (@@ROWCOUNT = 1)
		BEGIN
			SET @Succeeded = 1;
		END
		ELSE
		BEGIN
			SET @Message = 'Update did not succeed';
		END;
	END
	ELSE
	BEGIN
		SET @Message = 'Updates are not allowed for the current status';
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'MM Recipe', 'Update', 'MMRecipe', @Id, NULL, @Succeeded, @Message;

END
