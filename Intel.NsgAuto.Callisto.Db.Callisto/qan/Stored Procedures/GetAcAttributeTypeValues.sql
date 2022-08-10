-- ===================================================================
-- Author       : bricschx
-- Create date  : 2021-01-26 14:08:27.290
-- Description  : Gets auto checker attribute type values
-- Example      : EXEC [qan].[GetAcAttributeTypeValues] 'bricschx';
-- ===================================================================
CREATE PROCEDURE [qan].[GetAcAttributeTypeValues]
(
	  @UserId            VARCHAR(25)
	, @Id                INT         = NULL
	, @AttributeTypeId   INT         = NULL
	, @AttributeTypeName VARCHAR(50) = NULL
	, @Value             VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FAcAttributeTypeValues](@Id, @AttributeTypeId, @AttributeTypeName, @Value) ORDER BY [AttributeTypeName], [Value], [Id];

END
