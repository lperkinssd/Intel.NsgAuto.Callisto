-- ===================================================================
-- Author       : bricschx
-- Create date  : 2021-02-22 17:31:08.657
-- Description  : Gets osat attribute types
-- Example      : EXEC [qan].[GetOsatAttributeTypes] 'bricschx';
-- ===================================================================
CREATE PROCEDURE [qan].[GetOsatAttributeTypes]
(
	  @UserId     VARCHAR(25)
	, @Id         INT         = NULL
	, @Name       VARCHAR(50) = NULL
	, @DataTypeId INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FOsatAttributeTypes](@Id, @Name, @DataTypeId) ORDER BY [Name];

END
