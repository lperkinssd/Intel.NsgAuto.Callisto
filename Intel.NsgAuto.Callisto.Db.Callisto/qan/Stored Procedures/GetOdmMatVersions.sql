


-- ==================================================================================
-- Author		: jakemurx
-- Create date	: 2021-02-11 16:03:23.837
-- Description	: Gets MAT versions 
--				EXEC [qan].[GetOdmMatVersions] 'jakemurx'
-- ==================================================================================
CREATE PROCEDURE [qan].[GetOdmMatVersions]
(
	    @UserId VARCHAR(25)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Table TABLE
	(
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[VersionNumber] [int] NOT NULL,
		[WW] [varchar](25) NOT NULL,
		[IsActive] [bit] NOT NULL,
		[CreatedBy] [varchar](25) NOT NULL,
		[CreatedOn] [datetime2](7) NOT NULL
	);

	INSERT INTO @Table
	SELECT DISTINCT [MatVersion], [WW], [Latest], [CreatedBy], [CreatedOn]
	FROM [qan].[MAT]
	ORDER BY [MatVersion]


	SELECT [Id],
		[VersionNumber],
		[WW] ,
		[IsActive],
		[CreatedBy],
		[CreatedOn]
	FROM @Table
	ORDER BY [Id] DESC

END