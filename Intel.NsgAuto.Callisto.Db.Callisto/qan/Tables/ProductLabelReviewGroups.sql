CREATE TABLE [qan].[ProductLabelReviewGroups] (
    [Id]            INT           NOT NULL,
    [VersionId]     INT           NOT NULL,
    [ReviewStageId] INT           NOT NULL,
    [GroupName]     VARCHAR (50)  NOT NULL,
    [DisplayName]   VARCHAR (100) NULL,
    CONSTRAINT [PK_ProductLabelReviewGroups] PRIMARY KEY CLUSTERED ([Id] ASC, [VersionId] ASC)
);

