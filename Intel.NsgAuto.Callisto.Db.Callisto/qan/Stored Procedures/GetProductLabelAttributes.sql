-- ===================================================================
-- Author       : bricschx
-- Create date  : 2020-08-28 09:48:54.320
-- Description  : Gets products label attributes
-- Example      : EXEC [qan].[GetProductLabelAttributes] 'bricschx', 1
-- ===================================================================
CREATE PROCEDURE [qan].[GetProductLabelAttributes]
(
	  @UserId VARCHAR(25)
	, @Id BIGINT = NULL
	, @ProductLabelId BIGINT = NULL
	, @ProductLabelSetVersionId INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM [qan].[FProductLabelAttributes](@Id, @ProductLabelId, @ProductLabelSetVersionId) ORDER BY [Id];

END
