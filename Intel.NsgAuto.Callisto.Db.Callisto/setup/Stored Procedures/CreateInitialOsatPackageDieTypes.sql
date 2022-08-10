-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-05-26 13:08:56.120
-- Description  : Creates the initial osat package die types
-- Example      : EXEC [setup].[CreateInitialOsatPackageDieTypes] 'bricschx';
--                SELECT * FROM [qan].[OsatPackageDieTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateInitialOsatPackageDieTypes]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[qan].[OsatPackageDieTypes]';
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	MERGE [qan].[OsatPackageDieTypes] AS M
	USING
	(VALUES
		  ('SDP',  '1', 1)
		, ('DDP',  '2', 2)
		, ('QDP',  '4', 4)
		, ('5DP',  'P', 5)
		, ('PDP',  'P', 5)
		, ('7DP',  '7', 8)
		, ('8DP',  '8', 8)
		, ('ODP',  '8', 8)
		, ('10DP', 'X', 10)
		, ('15DP', 'F', 16)
		, ('HDP',  'H', 16)
	) AS N ([Name], [DeviceNameCharacter], [PackageDieCount])
	ON (M.[Name] = N.[Name])
	WHEN NOT MATCHED THEN INSERT ([Name], [DeviceNameCharacter], [PackageDieCount]) VALUES (N.[Name], N.[DeviceNameCharacter], N.[PackageDieCount])
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @Count = COUNT(*) FROM @Ids;
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
