-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-09-15 13:39:19.597
-- Description  : Creates a task
-- Example      : DECLARE @TaskId INT;
--                EXEC [stage].[CreateTask] @TaskId OUTPUT, 1;
-- =============================================================
CREATE PROCEDURE [stage].[CreateTask]
(
	  @Id              BIGINT OUTPUT
	, @TaskTypeId      INT
	, @Status          VARCHAR(50) = 'Started'
	, @JobExecutionId  INT         = NULL
	, @JobStepId       INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [stage].[Tasks]
	(
		  [TaskTypeId]
		, [Status]
		, [JobExecutionId]
		, [JobStepId]
	)
	VALUES
	(
		  @TaskTypeId
		, @Status
		, @JobExecutionId
		, @JobStepId
	);

	SET @Id = SCOPE_IDENTITY();

END
