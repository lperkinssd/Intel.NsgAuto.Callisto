


-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-07 14:44:29.901
-- Description:	Create MATReviewers table
-- =============================================
CREATE PROCEDURE [setup].[CreateMATReviewersTable] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) WHERE TABLE_SCHEMA = 'qan' AND TABLE_NAME = 'MATReviewers')
	BEGIN
		EXEC('DROP TABLE [qan].[MATReviewers]');
	END

	CREATE TABLE [qan].[MATReviewers](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[VersionId] [int] NOT NULL,
		[ReviewStageId] [int] NOT NULL,
		[ReviewGroupId] [int] NOT NULL,
		[Name] [varchar](255) NOT NULL,
		[Idsid] [varchar](50) NOT NULL,
		[WWID] [varchar](10) NOT NULL,
		[Email] [varchar](255) NOT NULL,
	 CONSTRAINT [PK_MATReviewers_1] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END