-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-02 09:35:25.100
-- Description  : Creates the initial review groups
-- Example      : EXEC [setup].[CreateInitialReviewGroups] 'bricschx';
--                SELECT * FROM [qan].[ReviewGroups];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateInitialReviewGroups]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[qan].[ReviewGroups]';
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	MERGE [qan].[ReviewGroups] AS M
	USING
	(VALUES
		  ('Group1', 'Group 1')
		, ('Group2', 'Group 2')
		, ('Group3', 'Group 3')
		, ('Media PE', 'Media PE Reviews')
		, ('Q & R', 'Q & R Reviews')
		, ('Supply Chain Planner', 'Supply Chain Planner Reviews')
	) AS N ([GroupName], [DisplayName])
	ON (M.[GroupName] = N.[GroupName])
	WHEN NOT MATCHED THEN INSERT ([GroupName], [DisplayName], [CreatedBy], [UpdatedBy]) VALUES (N.[GroupName], N.[DisplayName], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @Count = COUNT(*) FROM @Ids;
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
