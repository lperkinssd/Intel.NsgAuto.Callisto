-- ==================================================================
-- Author       : bricschx
-- Create date  : 2021-01-28 16:52:35.430
-- Description  : Gets OSAT PAS versions
-- Example      : EXEC [qan].[GetOsatPasVersions] 'bricschx', 1;
-- ==================================================================
CREATE PROCEDURE [qan].[GetOsatPasVersions]
(
	  @UserId          VARCHAR(25)
	, @Id              INT         = NULL
	, @Version         INT         = NULL
	, @IsActive        BIT         = NULL
	, @IsPOR           BIT         = NULL
	, @StatusId        INT         = NULL
	, @CombinationId   INT         = NULL
	, @OsatId          INT         = NULL
	, @DesignFamilyId  INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [qan].[FOsatPasVersions](@Id, @UserId, @Version, @IsActive, @IsPOR, @StatusId, @CombinationId, @OsatId, @DesignFamilyId) ORDER BY [Id] DESC;

END
