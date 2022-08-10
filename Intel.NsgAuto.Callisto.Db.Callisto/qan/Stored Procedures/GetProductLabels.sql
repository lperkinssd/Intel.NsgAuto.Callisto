-- =========================================================================
-- Author       : bricschx
-- Create date  : 2020-08-21 16:13:41.390
-- Description  : Gets product labels
-- Example      : EXEC [qan].[GetProductLabels] 'bricschx', NULL, 1, 1
-- =========================================================================
CREATE PROCEDURE [qan].[GetProductLabels]
(
	  @UserId VARCHAR(25)
	, @Id BIGINT = NULL
	, @SetVersionId INT = NULL
	, @IncludeAttributes BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM [qan].[FProductLabels](@Id, @SetVersionId) ORDER BY [Id];

	IF @IncludeAttributes = 1
	BEGIN
		EXEC [qan].[GetProductLabelAttributes] null, null, @Id, @SetVersionId
	END

END
