-- ====================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-07-19 15:35:57.910
-- Description  : Updates an osat build combination disabling publish functionality and returns all build combinations
-- Example      : DECLARE @Message VARCHAR(500);
--                EXEC [qan].[UpdateOsatBuildCombinationPublishDisabledReturnAll] NULL, @Message OUTPUT, 'bricschx', 0;
--                PRINT @Message; -- should print 'Invalid build combination: 0'
-- ====================================================================================================================
CREATE PROCEDURE [qan].[UpdateOsatBuildCombinationPublishDisabledReturnAll]
(
	  @Succeeded                  BIT                   OUTPUT
	, @Message                    VARCHAR(500)          OUTPUT
	, @UserId                     VARCHAR(25)
	, @Id                         INT
	, @DesignId                   INT           = NULL
	, @PorBuildCriteriaSetExists  BIT           = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @Succeeded = 0;
	SET @Message = NULL;

	EXEC [qan].[UpdateOsatBuildCombinationPublishDisabled] @Succeeded OUTPUT, @Message OUTPUT, @UserId, @Id;

	SELECT * FROM [qan].[FOsatBuildCombinations](NULL, @UserId, 1, @DesignId, NULL, NULL, NULL, NULL, NULL, NULL)
		WHERE (@PorBuildCriteriaSetExists IS NULL OR (@PorBuildCriteriaSetExists = 0 AND [PorBuildCriteriaSetId] IS NULL) OR (@PorBuildCriteriaSetExists = 1 AND [PorBuildCriteriaSetId] IS NOT NULL))
		ORDER BY [IntelLevel1PartNumber], [IntelProdName], [MaterialMasterField], [IntelMaterialPn], [AssyUpi], [Id];

END
