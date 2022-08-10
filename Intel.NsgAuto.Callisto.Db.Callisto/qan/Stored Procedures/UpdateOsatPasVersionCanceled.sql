-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-29 17:46:14.410
-- Description  : Cancels an osat pas version
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatPasVersionCanceled] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid version: 0'
-- ================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatPasVersionCanceled]
(
	  @Succeeded    BIT          OUTPUT
	, @Message      VARCHAR(500) OUTPUT
	, @UserId       VARCHAR(25)
	, @Id           INT
	, @Override     BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType         VARCHAR(100) = 'Review Cancel';
	DECLARE @ActionDescription  VARCHAR (1000) = @ActionType;
	DECLARE @Count              INT;
	DECLARE @CreatedBy          VARCHAR(25);
	DECLARE @CurrentStatusId    INT;
	DECLARE @ErrorsExist        BIT = 0;
	DECLARE @NewStatusId        INT = 2; -- Canceled

	SET @Succeeded = 0;
	SET @Message = NULL;

	SELECT
		  @Count              = COUNT(*)
		, @CurrentStatusId    = MAX([StatusId])
		, @CreatedBy          = MAX([CreatedBy])
	FROM [qan].[FOsatPasVersions](@Id, @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	-- standardization
	IF (@Override IS NULL) SET @Override = 0;

	-- begin validation
	IF (@Count = 0)
	BEGIN
		SET @Message = 'Invalid version: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END;
	-- if @Override = 1 skip the validation inside the BEGIN/END block
	ELSE IF (@Override = 0)
	BEGIN
		IF (@CurrentStatusId IS NULL OR @CurrentStatusId <> 1) -- 1 = Draft
		BEGIN
			SET @Message = 'Cancel is not allowed for the current status';
			SET @ErrorsExist = 1;
		END;
		-- for now, only the user who created the version may cancel it
		ELSE IF (@UserId IS NULL OR @UserId <> @CreatedBy)
		BEGIN
			SET @Message = 'Unauthorized';
			SET @ErrorsExist = 1;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		UPDATE [qan].[OsatPasVersions] SET [StatusId] = @NewStatusId, [UpdatedBy] = @UserId, [UpdatedOn] = GETUTCDATE() WHERE [Id] = @Id;

		SET @Succeeded = 1;
	END;

	IF (@Override = 1) SET @ActionDescription = @ActionDescription + '; Override = 1';
	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatPasVersion', @Id, NULL, @Succeeded, @Message;

END
