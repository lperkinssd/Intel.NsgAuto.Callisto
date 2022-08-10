-- ======================================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-04 14:24:07.550
-- Description  : Creates a new user action record
-- Example      : EXEC [qan].[CreateUserAction] NULL, 'bricschx', 'Submit for Stage1, Group1', 'Auto Checker', 'Submit', 'AcBuildCriteria', 1, NULL, 0, 'Unauthorized';
-- ======================================================================================================================================================================
CREATE PROCEDURE [qan].[CreateUserAction]
(
	  @Id                    BIGINT OUTPUT
	, @CreatedBy             VARCHAR (25)
	, @Description           VARCHAR (1000)   = NULL
	, @Category              VARCHAR (250)    = NULL
	, @ActionType            VARCHAR (100)    = NULL
	, @EntityType            VARCHAR (100)    = NULL
	, @EntityId              BIGINT           = NULL
	, @EntityGuid            UNIQUEIDENTIFIER = NULL
	, @Succeeded             BIT              = NULL
	, @Message               VARCHAR(500)     = NULL
	, @AssociatedEntityType  VARCHAR (100)    = NULL
	, @AssociatedEntityId    BIGINT           = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @Id = NULL;

	INSERT INTO [qan].[UserActions]
	(
		  [CreatedBy]
		, [Category]
		, [ActionType]
		, [Description]
		, [EntityType]
		, [EntityId]
		, [EntityGuid]
		, [Succeeded]
		, [Message]
		, [AssociatedEntityType]
		, [AssociatedEntityId]
	)
	VALUES
	(
		  @CreatedBy
		, @Category
		, @ActionType
		, @Description
		, @EntityType
		, @EntityId
		, @EntityGuid
		, @Succeeded
		, @Message
		, @AssociatedEntityType
		, @AssociatedEntityId
	);

	SELECT @Id = SCOPE_IDENTITY();

END
