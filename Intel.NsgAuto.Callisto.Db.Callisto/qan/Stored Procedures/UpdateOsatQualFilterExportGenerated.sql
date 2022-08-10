-- ====================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-08 20:35:41.867
-- Description  : Updates an osat qual filter export setting the generated date
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatQualFilterExportGenerated] NULL, @Message OUTPUT, 'bricschx', 0, 'test.zip', 0;
--                PRINT @Message; -- should print: 'Invalid id: 0'
-- ====================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatQualFilterExportGenerated]
(
	  @Succeeded          BIT          OUTPUT
	, @Message            VARCHAR(500) OUTPUT
	, @UserId             VARCHAR(25)
	, @Id                 INT
	, @FileName           VARCHAR(250)
	, @FileLengthInBytes  INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionType         VARCHAR(100)  = 'Update Generated';
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

			UPDATE [qan].[OsatQualFilterExports] SET [GeneratedOn] = @On, [FileName] = @FileName, [FileLengthInBytes] = @FileLengthInBytes, [UpdatedBy] = @UserId, [UpdatedOn] = @On WHERE [Id] = @Id;

			UPDATE [qan].[OsatQualFilterExportFiles] SET [GeneratedOn] = @On, [UpdatedBy] = @UserId, [UpdatedOn] = @On WHERE [ExportId] = @Id;

		COMMIT;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', @ActionType, 'OsatQualFilterExport', @Id, NULL, @Succeeded, @Message;

END
