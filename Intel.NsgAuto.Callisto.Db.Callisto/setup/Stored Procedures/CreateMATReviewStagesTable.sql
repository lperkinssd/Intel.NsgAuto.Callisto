-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-07 09:35:29.286
-- Description:	Create MATReviewStages table
-- =============================================
CREATE PROCEDURE [setup].[CreateMATReviewStagesTable] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) WHERE TABLE_SCHEMA = 'qan' AND TABLE_NAME = 'MATReviewStages')
	BEGIN
		EXEC('DROP TABLE [qan].[MATReviewStages]');
	END

	CREATE TABLE [qan].[MATReviewStages](
		[Id] [int] NOT NULL,
		[VersionId] [int] NOT NULL,
		[StageName] [varchar](50) NOT NULL,
		[DisplayName] [varchar](100) NOT NULL,
	 CONSTRAINT [PK_MATReviewStages] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC,
		[VersionId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END