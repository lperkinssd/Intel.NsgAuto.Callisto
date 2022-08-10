


-- =============================================================
-- Author		:	jkurian
-- Create date	:	2021-07-29 13:45:25.217
-- Description	:	Gets details of an existing version of 
--					manual lot disposition imports by its version
-- =============================================================
CREATE PROCEDURE [qan].[GetOdmManualDispositionsByVersion]
(
	 @Version	INT,
	 @UserId varchar(255)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @UserIdSid varchar(255) = @UserId;

	-- Return the details of one version to the UI, to display to the user
	SELECT 
		  omd.[Id]
		, omd.[Version]
        , omd.[SLot]
		, omd.[IntelPartNumber]
        , omd.[LotDispositionReasonId]
		, oldr.[Description]				AS LotDispositionReason
        , omd.[Notes]
        , omd.[LotDispositionActionId]
		, olda.[DisplayText]				AS LotDispositionActionDisplayText
		, olda.[ActionName]					AS LotDispositionActionName
        , omd.[CreatedOn]
        , omd.[CreatedBy]
        , omd.[UpdatedOn]
        , omd.[UpdatedBy]
	FROM [qan].[OdmManualDispositions] omd WITH (NOLOCK)
		INNER JOIN [ref].[OdmLotDispositionReasons] oldr  WITH (NOLOCK)
			ON omd.LotDispositionReasonId = oldr.Id
		INNER JOIN [ref].[OdmLotDispositionActions] olda  WITH (NOLOCK)
			ON omd.LotDispositionActionId = olda.Id
	WHERE omd.[Version] = @Version;

END