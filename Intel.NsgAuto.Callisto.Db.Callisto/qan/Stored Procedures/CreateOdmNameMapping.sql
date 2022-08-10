-- =============================================
-- Author:		jakemurx
-- Create date: 2021-04-09 15:29:04.479
-- Description:	Create an Odm name mapping
-- =============================================
CREATE PROCEDURE [qan].[CreateOdmNameMapping] 
	-- Add the parameters for the stored procedure here
	@SubconName VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Count INT;

	SET @Count = (SELECT Count(*) FROM [qan].[OdmNameMappings] WHERE [OdmDescription] = @SubconName);

	-- The name is already mapped
	IF @Count > 0 RETURN;

	DECLARE @MappingNames TABLE
	(
		[Id] int,
		[OdmName] varchar(25),
		[SubconName] varchar(25)
	);

	INSERT INTO @MappingNames
	SELECT    o.[Id]
			, o.[Name] AS OdmName
			, @SubconName AS SubconName
	FROM [ref].[Odms] o WITH (NOLOCK)
	WHERE CHARINDEX(UPPER(o.[Name]), UPPER(@SubconName)) > 0

	-- Update the the table with a new subcon name
	MERGE [qan].[OdmNameMappings] AS onm
	USING( SELECT [Id], [SubconName] FROM @MappingNames) AS r
	ON (onm.[OdmDescription] = r.[SubconName])
	WHEN NOT MATCHED THEN INSERT ([OdmDescription], [MappedOdmId]) VALUES (r.[SubconName], r.[Id]);

END