-- ===================================================================
-- Author       : bricschx
-- Create date  : 2020-09-25 17:45:03.403
-- Description  : Gets MM recipes
-- Example      : EXEC [qan].[GetMMRecipes] 'bricschx', NULL, '99A2ML'
-- ===================================================================
CREATE PROCEDURE [qan].[GetMMRecipes]
(
	  @UserId VARCHAR(25)
	, @Id BIGINT = NULL
	, @PCode VARCHAR(10) = NULL
	, @Version INT = NULL
	, @IsActive BIT = NULL
	, @IsPOR BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FMMRecipes](@Id, @PCode, @Version, @IsActive, @IsPOR) ORDER BY [Version] DESC, [Id] DESC;

END
