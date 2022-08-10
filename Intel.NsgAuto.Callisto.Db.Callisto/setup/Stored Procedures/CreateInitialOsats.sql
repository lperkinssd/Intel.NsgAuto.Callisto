-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-02 16:38:31.110
-- Description  : Creates the initial osats
-- Example      : EXEC [setup].[CreateInitialOsats] 'bricschx';
--                SELECT * FROM [qan].[Osats];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateInitialOsats]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[qan].[Osats]';
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	MERGE [qan].[Osats] AS M
	USING
	(VALUES
		  ('Amkor')
		, ('PTI')
	) AS N ([Name])
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @Count = COUNT(*) FROM @Ids;
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
