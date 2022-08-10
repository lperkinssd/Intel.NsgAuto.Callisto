-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-07-16 15:59:09.483
-- Description  : Updates an osat build combination enabling publish functionality
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatBuildCombinationPublishEnabled] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid build combination: 0'
-- ===============================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatBuildCombinationPublishEnabled]
(
	  @Succeeded    BIT          OUTPUT
	, @Message      VARCHAR(500) OUTPUT
	, @UserId       VARCHAR(25)
	, @Id           INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType         VARCHAR (100) = 'Update Publish Enabled';
	DECLARE @ActionDescription  VARCHAR (1000) = @ActionType;
	DECLARE @Count              INT;
	DECLARE @ErrorsExist        BIT = 0;
	DECLARE @PublishDisabledOn  DATETIME2 (7);
	DECLARE @On                 DATETIME2 (7) = GETUTCDATE();

	SET @Succeeded = 0;
	SET @Message = NULL;

	SELECT
		  @Count              = COUNT(*)
		, @PublishDisabledOn  = MAX([PublishDisabledOn])
	FROM [qan].[OsatBuildCombinations] WITH (NOLOCK) WHERE [Id] = @Id;

	-- begin validation
	IF (@Count = 0)
	BEGIN
		SET @Message = 'Invalid build combination: ' + ISNULL(CAST(@Id AS VARCHAR(20)), 'null');
		SET @ErrorsExist = 1;
	END;
	ELSE IF (@PublishDisabledOn IS NULL)
	BEGIN
		SET @Message = 'Publish already enabled';
		SET @ErrorsExist = 1;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		UPDATE [qan].[OsatBuildCombinations] SET [PublishDisabledBy] = NULL, [PublishDisabledOn] = NULL, [UpdatedBy] = @UserId, [UpdatedOn] = @On WHERE [Id] = @Id;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatBuildCombination', @Id, NULL, @Succeeded, @Message;

END
