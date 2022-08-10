



-- =============================================================
-- Author		: bricschx
-- Create date	: 2020-08-31 15:31:42.073
-- Description	: Creates a new speed access token
--                  EXEC [qan].[CreateSpeedAccessToken] 'xxxx', 'Bearer', 3599, 'bricschx'
-- =============================================================
CREATE PROCEDURE [qan].[CreateSpeedAccessToken]
(
	    @AccessToken varchar(2000)
	  , @TokenType varchar(25)
	  , @SecondsToExpiration int
	  , @UserId varchar(25)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id int;

	INSERT INTO [qan].[SpeedAccessTokens]
	(
		  [AccessToken]
		, [TokenType]
		, [ExpiresOn]
		, [CreatedBy]
		, [UpdatedBy]
	)
	VALUES
	(
		  @AccessToken
		, @TokenType
		, DATEADD(second, @SecondsToExpiration, GETUTCDATE())
		, @UserId
		, @UserId
	);

	SET @Id = SCOPE_IDENTITY();

	SELECT * FROM [qan].[SpeedAccessTokens] WITH (NOLOCK) WHERE [Id] = @Id;

END