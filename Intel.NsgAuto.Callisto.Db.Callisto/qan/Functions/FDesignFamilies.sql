-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2021-05-18 12:13:28.977
-- Description  : Gets design families
-- Example      : SELECT * FROM [qan].[FDesignFamilies](NULL, NULL, NULL);
-- ======================================================================================
CREATE FUNCTION [qan].[FDesignFamilies]
(
	  @Id                BIGINT      = NULL
	, @Name              VARCHAR(10) = NULL
	, @UserId            VARCHAR(25) = NULL -- if not null will restrict results to user's allowed design families
)
RETURNS TABLE AS RETURN
(

	SELECT
		  DF.[Id]
		, DF.[Name]
	FROM [ref].[DesignFamilies] AS DF WITH (NOLOCK)
	WHERE (@Id     IS NULL OR DF.[Id]   = @Id)
	  AND (@Name   IS NULL OR DF.[Name] = @Name)
	  AND (@UserId IS NULL OR DF.[Name] IN (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                  INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId))
)
