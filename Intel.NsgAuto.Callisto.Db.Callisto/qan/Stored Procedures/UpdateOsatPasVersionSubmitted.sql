-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-29 18:15:02.910
-- Description  : Submits an OSAT PAS version.
-- Note:        : This procedure contains the core logic, but is designed not to return any result sets
--                for maximum flexibility. If you want certain result sets, create a new procedure and
--                use composition. For example see [qan].[UpdateOsatPasVersionSubmittedReturnDetails].
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatPasVersionSubmitted] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid version: 0'
-- =====================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatPasVersionSubmitted]
(
	  @Succeeded    BIT          OUTPUT
	, @Message      VARCHAR(500) OUTPUT
	, @UserId       VARCHAR(25)
	, @Id           BIGINT
	, @Override     BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType                 VARCHAR(100) = 'Review Submit';
	DECLARE @ActionDescription          VARCHAR (1000) = @ActionType;
	DECLARE @CombinationId              INT;
	DECLARE @CountCombinationsInserted  INT;
	DECLARE @CountCombinationsUpdated   INT;
	DECLARE @CountDesignsUpdated        INT;
	DECLARE @Count                      INT;
	DECLARE @CreatedBy                  VARCHAR(25);
	DECLARE @CurrentStatusId            INT;
	DECLARE @ErrorsExist                BIT = 0;
	DECLARE @NewStatusId                INT = 6; -- Complete
	DECLARE @On                         DATETIME2(7) = GETUTCDATE();

	SET @Succeeded = 0;
	SET @Message = NULL;

	SELECT
		  @Count              = COUNT(*)
		, @CurrentStatusId    = MAX([StatusId])
		, @CombinationId      = MAX([CombinationId])
		, @CreatedBy          = MAX([CreatedBy])
	FROM [qan].[FOsatPasVersions](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	-- standardization
	IF (@Override IS NULL) SET @Override = 0;

	-- begin validation
	IF (NOT @Count = 1)
	BEGIN
		SET @Message = 'Invalid version: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	-- if @Override = 1 skip the validation inside the BEGIN/END block
	ELSE IF (@Override = 0)
	BEGIN
		IF (@CurrentStatusId IS NULL OR @CurrentStatusId <> 1) -- 1 = Draft
		BEGIN
			SET @Message = 'Submit is not allowed for the current status';
			SET @ErrorsExist = 1;
		END;
		-- for now, only the user who created it may submit it
		ELSE IF (@UserId IS NULL OR @UserId <> @CreatedBy)
		BEGIN
			SET @Message = 'Unauthorized';
			SET @ErrorsExist = 1;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION
			/* currently unnecessary
			-- cancel any existing versions in Submitted, or In Review status
			UPDATE [qan].[OsatPasVersions] SET
				  [StatusId] = 2 -- Canceled
				, [UpdatedBy] = @UserId
				, [UpdatedOn] = @On
			WHERE [StatusId] IN (3, 5) -- Submitted, or In Review
			  AND [Id] <> @Id
			  AND [CombinationId] = @CombinationId;
			*/

			-- for now there is no further review process after submit, so do same things that would happen upon final approval
			-- unset IsPor for any that match the combination
			UPDATE [qan].[OsatPasVersions] SET
				  [IsPOR] = 0
				, [UpdatedBy] = @UserId
				, [UpdatedOn] = @On
			WHERE [IsPOR] = 1
			 AND [CombinationId] = @CombinationId;

			UPDATE [qan].[OsatPasVersions] SET [StatusId] = @NewStatusId, [IsPOR] = 1, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;

			EXEC [qan].[UpdateFromPorOsatPasVersions] @CountCombinationsInserted OUTPUT, @CountCombinationsUpdated OUTPUT, NULL, @CountDesignsUpdated OUTPUT, @UserId;
			IF (@CountCombinationsInserted > 0)
			BEGIN
				SET @ActionDescription = @ActionDescription + '; Combinations Inserted = ' + ISNULL(CAST(@CountCombinationsInserted AS VARCHAR(20)), '');
			END;

			IF (@CountCombinationsUpdated > 0)
			BEGIN
				SET @ActionDescription = @ActionDescription + '; Combinations Updated = ' + ISNULL(CAST(@CountCombinationsUpdated AS VARCHAR(20)), '');
			END;

			IF (@CountDesignsUpdated > 0)
			BEGIN
				SET @ActionDescription = @ActionDescription + '; Designs Updated = ' + ISNULL(CAST(@CountDesignsUpdated AS VARCHAR(20)), '');
			END;

		COMMIT;
		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatPasVersion', @Id, NULL, @Succeeded, @Message;

END
