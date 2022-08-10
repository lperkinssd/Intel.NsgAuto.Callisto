-- =======================================================================
-- Author		: bricschx
-- Create date	: 2020-09-02 11:51:19.920
-- Description	: Deletes expired speed access tokens
--                  EXEC [qan].[DeleteExpiredSpeedAccessTokens] 'bricschx'
-- =======================================================================
CREATE PROCEDURE [qan].[DeleteExpiredSpeedAccessTokens]
(
	  @UserId varchar(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	-- hour delay built in
	DELETE FROM [qan].[SpeedAccessTokens] WHERE [ExpiresOn] < DATEADD(hour, -1, GETUTCDATE());

END