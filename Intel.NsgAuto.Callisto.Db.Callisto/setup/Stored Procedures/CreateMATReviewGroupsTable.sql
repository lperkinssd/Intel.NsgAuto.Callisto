-- =============================================
-- Author:		jakemurx
-- Create date: 2020-10-07 14:40:15.389
-- Description:	Create MATReviewGroups table
-- =============================================
CREATE PROCEDURE [setup].[CreateMATReviewGroupsTable] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) WHERE TABLE_SCHEMA = 'qan' AND TABLE_NAME = 'MATReviewGroups')
	BEGIN
		EXEC('DROP TABLE [qan].[MATReviewGroups]');
	END

	CREATE TABLE [qan].[MATReviewGroups](
		[Id] [int] NOT NULL,
		[VersionId] [int] NOT NULL,
		[ReviewStageId] [int] NOT NULL,
		[GroupName] [varchar](50) NOT NULL,
		[DisplayName] [varchar](100) NULL,
	 CONSTRAINT [PK_MATReviewGroups] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC,
		[VersionId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END