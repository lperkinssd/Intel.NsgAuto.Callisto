-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-15 13:49:02.980
-- Description  : Creates a task message
-- Example      : EXEC [stage].[CreateTaskMessage] 1, 'Information', 'Test Message';
-- =================================================================================
CREATE PROCEDURE [stage].[CreateTaskMessage]
(
	  @TaskId  BIGINT
	, @Type    VARCHAR(20)
	, @Text    NVARCHAR(4000)
	, @Print   BIT            = 1
)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [stage].[TaskMessages]
	(
		  [TaskId]
		, [Type]
		, [Text]
	)
	VALUES
	(
		  @TaskId
		, @Type
		, @Text
	);

	IF (@Print = 1)
	BEGIN
		PRINT FORMAT(GETUTCDATE(), 'yyyy-MM-dd HH:mm:ss') + ': ' + @Text;
	END;

END
