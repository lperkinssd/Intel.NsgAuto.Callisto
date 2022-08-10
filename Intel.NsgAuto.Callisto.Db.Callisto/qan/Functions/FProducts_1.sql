
-- ======================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-13 11:45:55.080
-- Description  : Gets products (also referred to as designs)
-- Example      : SELECT * FROM [qan].[FProducts](NULL, NULL, NULL, NULL, NULL, NULL);
-- ======================================================================================
CREATE FUNCTION [qan].[FProducts]
(
	  @Id                BIGINT      = NULL
	, @UserId            VARCHAR(25) = NULL -- if not null will restrict results to user's allowed design families
	, @Name              VARCHAR(10) = NULL
	, @DesignFamilyId    INT         = NULL
	, @DesignFamilyName  VARCHAR(10) = NULL
	, @IsActive          BIT         = NULL
)
RETURNS @Products TABLE 
(
	 [Id]						BIGINT
	, [Name]					VARCHAR(10)
	, [DesignFamilyId]			INT	
	, [DesignFamilyName]		VARCHAR(10)
	, [IsActive]				BIT
	, [MixTypeId]				INT
	, [MixTypeName]				VARCHAR(50)		
	, [MixTypeAbbreviation]		VARCHAR(5)
	, [CreatedBy] [varchar](25) NOT NULL
	, [CreatedOn] [datetime2](7) NOT NULL
	, [UpdatedBy] [varchar](25) NOT NULL
	, [UpdatedOn] [datetime2](7) NOT NULL
)
AS
BEGIN

	-- Get the process for the user based on the preferred role
	DECLARE @Process VARCHAR(50) = (
		SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK)
		INNER JOIN [qan].[ProcessRoles] pr  WITH (NOLOCK)
		ON pfr.ActiveRole = pr.RoleName
		WHERE pfr.UserId = @UserId);

	  INSERT INTO @Products
		SELECT
			  P.[Id]
			, P.[Name]
			, P.[DesignFamilyId]
			, DF.[Name] AS [DesignFamilyName]
			, P.[IsActive]
			, P.[MixTypeId]
			, MT.[Name] AS [MixTypeName]
			, MT.[Abbreviation] AS [MixTypeAbbreviation]
			, P.[CreatedBy]
			, P.[CreatedOn]
			, P.[UpdatedBy]
			, P.[UpdatedOn]
		FROM [qan].[Products]                  AS P  WITH (NOLOCK)
		LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id] = P.[DesignFamilyId])
		LEFT OUTER JOIN [ref].[MixTypes]       AS MT WITH (NOLOCK) ON (MT.[Id] = P.[MixTypeId])
		WHERE (@Id               IS NULL OR P.[Id] = @Id)
		  AND (@Name             IS NULL OR P.[Name] = @Name)
		  AND (@DesignFamilyId   IS NULL OR P.[DesignFamilyId] = @DesignFamilyId)
		  AND (@DesignFamilyName IS NULL OR DF.[Name] = @DesignFamilyName)
		  AND (@IsActive         IS NULL OR P.[IsActive] = @IsActive)
		  AND (@UserId           IS NULL OR DF.[Name] = @Process);

	  RETURN;
END;