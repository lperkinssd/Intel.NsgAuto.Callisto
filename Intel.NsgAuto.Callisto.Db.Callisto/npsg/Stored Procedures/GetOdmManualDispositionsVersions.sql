

-- =============================================================
-- Author		:	jkurian
-- Create date	:	2021-07-29 13:45:25.217
-- Description	:	Gets all existing version of manual lot disposition imports
-- =============================================================
CREATE PROCEDURE [npsg].[GetOdmManualDispositionsVersions]
(
	  @UserId varchar(255)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @UserIdSid varchar(255) = @UserId;

	-- Return all versions to the UI, sorterd descending so that the latest appears first
	SELECT DISTINCT
		  omd.[Version]
        , omd.[CreatedOn]
        , omd.[CreatedBy]
        , omd.[UpdatedOn]
        , omd.[UpdatedBy]
	FROM [npsg].[OdmManualDispositions] omd WITH (NOLOCK)
	ORDER BY omd.[Version] DESC;

END