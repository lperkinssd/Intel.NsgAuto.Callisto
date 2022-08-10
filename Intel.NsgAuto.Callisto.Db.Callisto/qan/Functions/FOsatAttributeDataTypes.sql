-- ============================================================================
-- Author       : bricschx
-- Create date  : 2021-02-16
-- Description  : Gets osat attribute data types
-- Example      : SELECT * FROM [qan].[FOsatAttributeDataTypes](NULL, NULL);
-- ============================================================================
CREATE FUNCTION [qan].[FOsatAttributeDataTypes]
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
	FROM [ref].[OsatAttributeDataTypes] AS D WITH (NOLOCK)
	WHERE (@Id IS NULL OR D.[Id] = @Id)
	  AND (@Name IS NULL OR D.[Name] = @Name)
)
