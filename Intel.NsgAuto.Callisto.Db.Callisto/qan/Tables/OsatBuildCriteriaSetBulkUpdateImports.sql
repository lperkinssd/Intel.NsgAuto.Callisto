CREATE TABLE [qan].[OsatBuildCriteriaSetBulkUpdateImports](
	[Id] [INT] IDENTITY(1,1) NOT NULL,
	[OriginalFileName] [VARCHAR](250) NULL,
	[CurrentFile] [VARCHAR](250) NULL,
	[FileLengthInBytes] [INT] NULL,
	[DesignId] [INT] NOT NULL,
	[CreatedBy] [VARCHAR](25) NOT NULL,
	[CreatedOn] [DATETIME2](7) NOT NULL CONSTRAINT [DF_OsatBuildCriteriaSetBulkUpdateImports_CreatedOn]  DEFAULT (GETUTCDATE()),
	[UpdatedBy] [VARCHAR](25) NOT NULL,
	[UpdatedOn] [DATETIME2](7) CONSTRAINT [DF_OsatBuildCriteriaSetBulkUpdateImports_UpdatedOn]  DEFAULT (GETUTCDATE())NOT NULL,
 CONSTRAINT [PK_OsatBuildCriteriaSetBulkUpdateImports] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO	