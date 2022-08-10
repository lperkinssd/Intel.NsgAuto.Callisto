-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-07 18:09:45.900
-- Description  : Gets email templates
-- Example      : SELECT * FROM [ref].[FEmailTemplates](NULL, NULL, NULL, NULL, NULL);
-- ======================================================================================
CREATE FUNCTION [ref].[FEmailTemplates]
(
	  @Id           BIGINT      = NULL
	, @Name         VARCHAR(50) = NULL
	, @IsHtml       BIT         = NULL
	, @BodyXslId    INT         = NULL
	, @BodyXslName  VARCHAR(50) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  E.[Id]
		, E.[Name]
		, E.[IsHtml]
		, E.[Subject]
		, E.[Body]
		, E.[BodyXslId]
		, X.[Name] AS [BodyXslName]
		, X.[Value] AS [BodyXslValue]
		, E.[BodyXml]
	FROM [ref].[EmailTemplates] AS E WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[EmailTemplateBodyXsls] AS X WITH (NOLOCK) ON (X.[Id] = E.[BodyXslId])
	WHERE (@Id IS NULL OR E.[Id] = @Id)
	  AND (@Name IS NULL OR E.[Name] = @Name)
	  AND (@IsHtml IS NULL OR E.[IsHtml] = @IsHtml)
	  AND (@BodyXslId IS NULL OR E.[BodyXslId] = @BodyXslId)
	  AND (@BodyXslName IS NULL OR X.[Name] = @BodyXslName)
)
