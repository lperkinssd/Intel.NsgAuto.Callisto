CREATE TABLE [stage].[Jobs] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [Name]               VARCHAR (100) NOT NULL,
    [ThresholdTimeLimit] INT           NULL,
    CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Time limit for maximum time of execution; example - 30 seconds', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Jobs', @level2type = N'COLUMN', @level2name = N'ThresholdTimeLimit';

