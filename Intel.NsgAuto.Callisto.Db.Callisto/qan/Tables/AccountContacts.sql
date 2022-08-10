CREATE TABLE [qan].[AccountContacts] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (255) NOT NULL,
    [WWID]           VARCHAR (20)  NULL,
    [idSid]          VARCHAR (15)  NULL,
    [Email]          VARCHAR (255) NULL,
    [AlternateEmail] VARCHAR (255) NULL,
    [IsActive]       BIT           NOT NULL,
    [CreatedBy]      VARCHAR (25)  NOT NULL,
    [CreatedOn]      DATETIME2 (7) NOT NULL,
    [UpdatedBy]      VARCHAR (25)  NOT NULL,
    [UpdatedOn]      DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_AccountContacts] PRIMARY KEY CLUSTERED ([Id] ASC)
);



