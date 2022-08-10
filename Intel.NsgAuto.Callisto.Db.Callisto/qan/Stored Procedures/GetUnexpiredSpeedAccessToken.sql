

-- =============================================================
-- Author		: bricschx
-- Create date	: 2020-08-31 15:24:17.753
-- Description	: Gets the most recent unexpired speed access token
--					EXEC [qan].[GetUnexpiredSpeedAccessToken] 'bricschx'
-- =============================================================
CREATE PROCEDURE [qan].[GetUnexpiredSpeedAccessToken]
(
	    @UserId varchar(25)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT [Id]
		  ,[AccessToken]
		  ,[TokenType]
		  ,[ExpiresOn]
		  ,[CreatedBy]
		  ,[CreatedOn]
		  ,[UpdatedBy]
		  ,[UpdatedOn]
	  FROM [qan].[SpeedAccessTokens] WITH (NOLOCK)
	  WHERE getutcdate() <= [ExpiresOn]
	  ORDER BY [Id] DESC;

END