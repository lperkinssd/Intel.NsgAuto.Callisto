-- ========================================================================
-- Author       : bricschx
-- Create date  : 2020-11-12 10:04:58.213
-- Description  : Gets auto checker attribute data types
-- Example      : SELECT * FROM [qan].[FAcAttributeDataTypes](NULL, NULL);
-- ========================================================================
CREATE FUNCTION [qan].[FAcAttributeDataTypes]
(
	  @Id BIGINT = NULL
	, @Name VARCHAR(50) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  D.[Id]
		, D.[Name]
		, D.[NameDisplay]
	FROM [ref].[AcAttributeDataTypes] AS D WITH (NOLOCK)
	WHERE (@Id IS NULL OR D.[Id] = @Id)
	  AND (@Name IS NULL OR D.[Name] = @Name)
)
