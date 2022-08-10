-- ============================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 13:56:03.763
-- Description  : Gets the id for the product label attribute with the given name
-- Example      : SELECT [ref].[GetProductLabelAttributeTypeIdByName]('DellPN');
-- ============================================================================================
CREATE FUNCTION [ref].[GetProductLabelAttributeTypeIdByName]
(
	  @Name VARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT;

	SELECT TOP 1 @Result = MAX([Id]) FROM [ref].[ProductLabelAttributeTypes] WITH (NOLOCK) WHERE [Name] = @Name;

	RETURN (@Result);
END