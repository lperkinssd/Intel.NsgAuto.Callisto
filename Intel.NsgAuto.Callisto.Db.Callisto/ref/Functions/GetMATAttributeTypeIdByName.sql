
-- ============================================================================================
-- Author       : jakemurx
-- Create date  : 2020-09-28 15:50:15.696
-- Description  : Gets the id for the MAT attribute with the given name
-- Example      : SELECT [ref].[GetMATAttributeTypeIdByName]('CellRevision');
-- ============================================================================================
CREATE FUNCTION [ref].[GetMATAttributeTypeIdByName]
(
	  @Name VARCHAR(50)
)
RETURNS NVARCHAR(255)
AS
BEGIN
	DECLARE @Result INT;

	SELECT TOP 1 @Result = MAX([Id]) FROM [ref].[MATAttributeTypes] WITH (NOLOCK) WHERE [Name] = @Name;

	RETURN (@Result);
END