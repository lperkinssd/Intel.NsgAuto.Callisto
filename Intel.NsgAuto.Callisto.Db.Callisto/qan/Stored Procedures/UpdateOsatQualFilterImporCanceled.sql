-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 18:07:23.010
-- Description  : Cancels all osat build criterias associated with a qual filter import
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatQualFilterImportCanceled] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid id: 0'
-- =====================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatQualFilterImportCanceled]
(
	  @Succeeded    BIT          OUTPUT
	, @Message      VARCHAR(500) OUTPUT
	, @UserId       VARCHAR(25)
	, @Id           INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType                VARCHAR(100)  = 'Cancel';
	DECLARE @ActionDescription         VARCHAR(1000) = @ActionType;
	DECLARE @AllowBuildCriteriaActions BIT;
	DECLARE @BuildCriteriaSetIds       TABLE
	(
		  [Id]                         BIGINT NOT NULL PRIMARY KEY
	);
	DECLARE @Count                     INT;
	DECLARE @ErrorsExist               BIT           = 0;
	DECLARE @On                        DATETIME2(7)  = GETUTCDATE();

	SET @Succeeded = 0;
	SET @Message = NULL;

	SELECT
		  @Count                     = COUNT(*)
		, @AllowBuildCriteriaActions = CAST(MIN(CAST([AllowBuildCriteriaActions] AS INT)) AS BIT)
	FROM [qan].[OsatQualFilterImports] WITH (NOLOCK) WHERE [Id] = @Id;

	INSERT INTO @BuildCriteriaSetIds SELECT [Id] FROM [qan].[OsatBuildCriteriaSets] WITH (NOLOCK)
		WHERE [StatusId] = 1 -- Draft
		  AND [Id] IN (SELECT [BuildCriteriaSetId] FROM [qan].[OsatQualFilterImportBuildCriterias] WITH (NOLOCK) WHERE [ImportId] = @Id);

	-- begin validation
	IF (@Count = 0)
	BEGIN
		SET @Message = 'Invalid id: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END;
	ELSE
	BEGIN
		IF (@AllowBuildCriteriaActions = 0)
		BEGIN
			SET @Message = 'Build criteria actions are not allowed';
			SET @ErrorsExist = 1;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION

			UPDATE [qan].[OsatBuildCriteriaSets] SET [StatusId] = 2, [EffectiveOn] = @On, [UpdatedBy] = @UserId, [UpdatedOn] = @On
				WHERE [Id] IN (SELECT [Id] FROM @BuildCriteriaSetIds); -- StatusId 2 = Canceled
			SET @ActionDescription = @ActionDescription + '; Canceled Count: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

			UPDATE [qan].[OsatQualFilterImports] SET [AllowBuildCriteriaActions] = 0, [UpdatedBy] = @UserId, [UpdatedOn] = @On WHERE [Id] = @Id;

		COMMIT;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatQualFilterImport', @Id, NULL, @Succeeded, @Message;

END
