-- =====================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-08 20:44:27.607
-- Description  : Updates an osat qual filter export setting the delivered date
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatQualFilterExportDelivered] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print: 'Invalid id: 0'
-- =====================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatQualFilterExportDelivered]
(
	  @Succeeded    BIT          OUTPUT
	, @Message      VARCHAR(500) OUTPUT
	, @UserId       VARCHAR(25)
	, @Id           INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType         VARCHAR(100)  = 'Update Delivered';
	DECLARE @ActionDescription  VARCHAR(1000) = @ActionType;
	DECLARE @Count              INT;
	DECLARE @ErrorsExist        BIT           = 0;
	DECLARE @On                 DATETIME2(7)  = GETUTCDATE();

	SET @Succeeded = 0;
	SET @Message = NULL;

	SELECT
		  @Count = COUNT(*)
	FROM [qan].[OsatQualFilterExports] WITH (NOLOCK) WHERE [Id] = @Id;

	-- begin validation
	IF (@Count = 0)
	BEGIN
		SET @Message = 'Invalid id: ' + ISNULL(CAST(@Id AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION

			UPDATE [qan].[OsatQualFilterExports] SET [DeliveredOn] = @On, [UpdatedBy] = @UserId, [UpdatedOn] = @On WHERE [Id] = @Id;

			UPDATE [qan].[OsatQualFilterExportFiles] SET [DeliveredOn] = @On, [UpdatedBy] = @UserId, [UpdatedOn] = @On WHERE [ExportId] = @Id;

		COMMIT;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatQualFilterExport', @Id, NULL, @Succeeded, @Message;

END
