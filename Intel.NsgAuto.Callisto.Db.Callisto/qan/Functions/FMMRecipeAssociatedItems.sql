-- =============================================================================
-- Author       : bricschx
-- Create date  : 2020-10-12 17:40:13.793
-- Description  : Gets a MM Recipe's associated items
-- Example      : SELECT * FROM [qan].[FMMRecipeAssociatedItems](NULL, 1, NULL);
-- =============================================================================
CREATE FUNCTION [qan].[FMMRecipeAssociatedItems]
(
	  @Id BIGINT = NULL
	, @MMRecipeId BIGINT = NULL
	, @MATId INT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  I.[Id]
		, I.[MMRecipeId]
		, I.[MATId]
		, I.[SpeedItemCategoryId]
		, C.[Name] AS [SpeedItemCategoryName]
		, C.[Code] AS [SpeedItemCategoryCode]
		, I.[ItemId]
		, I.[Revision]
		, I.[SpeedBomAssociationTypeId]
		, A.[Name] AS [SpeedBomAssociationTypeName]
		, A.[NameSpeed] AS [SpeedBomAssociationTypeNameSpeed]
		, A.[CodeSpeed] AS [SpeedBomAssociationTypeCodeSpeed]
	FROM [qan].[MMRecipeAssociatedItems] AS I WITH (NOLOCK)
	LEFT OUTER JOIN [ref].[SpeedItemCategories] AS C WITH (NOLOCK) ON (C.[Id] = I.[SpeedItemCategoryId])
	LEFT OUTER JOIN [qan].[SpeedBomAssociationTypes] AS A WITH (NOLOCK) ON (A.[Id] = I.[SpeedBomAssociationTypeId])
	WHERE (@Id IS NULL OR I.[Id] = @Id)
	  AND (@MMRecipeId IS NULL OR I.[MMRecipeId] = @MMRecipeId)
	  AND (@MATId IS NULL OR I.[MATId] = @MATId)
)
