-- ===================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 13:07:19.547
-- Description  : Gets auto checker attribute types
-- Example      : EXEC [qan].[GetAcAttributeTypes] 'bricschx';
-- ===================================================================
CREATE PROCEDURE [qan].[GetAcAttributeTypes]
(
	  @UserId     VARCHAR(25)
	, @Id         INT         = NULL
	, @Name       VARCHAR(50) = NULL
	, @DataTypeId INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FAcAttributeTypes](@Id, @Name, @DataTypeId) ORDER BY [Name];

END
