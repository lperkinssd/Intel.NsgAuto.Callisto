-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-01 17:32:36.743
-- Description  : Creates the initial review stages
-- Example      : EXEC [setup].[CreateInitialReviewStages] 'bricschx';
--                SELECT * FROM [qan].[ReviewStages];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateInitialReviewStages]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Ids TABLE ([Id] INT NOT NULL);
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[qan].[ReviewStages]';
	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	MERGE [qan].[ReviewStages] AS M
	USING
	(VALUES
		  ('Stage1', 'Stage 1', 10)
		, ('Stage2', 'Stage 2', 20)
		, ('HVM', 'HVM Reviews', 30)
	) AS N ([StageName], [DisplayName], [Sequence])
	ON (M.[StageName] = N.[StageName])
	WHEN NOT MATCHED THEN INSERT ([StageName], [DisplayName], [Sequence], [CreatedBy], [UpdatedBy]) VALUES (N.[StageName], N.[DisplayName], N.[Sequence], @By, @By)
	OUTPUT inserted.[Id] INTO @Ids;

	SELECT @Count = COUNT(*) FROM @Ids;
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
