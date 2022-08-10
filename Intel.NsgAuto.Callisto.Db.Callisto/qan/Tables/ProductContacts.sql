CREATE TABLE [qan].[ProductContacts] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (255) NOT NULL,
    [WWID]           VARCHAR (20)  NULL,
    [idSid]          VARCHAR (15)  NULL,
    [Email]          NCHAR (255)   NULL,
    [AlternateEmail] NCHAR (255)   NULL,
    [IsActive]       BIT           CONSTRAINT [DF_QANProductContacts_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy]      VARCHAR (25)  NOT NULL,
    [CreatedOn]      DATETIME2 (7) CONSTRAINT [DF_QANProductContacts_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]      VARCHAR (25)  NOT NULL,
    [UpdatedOn]      DATETIME2 (7) CONSTRAINT [DF_QANProductContacts_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_QANProductContacts] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_QANProductContacts_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);





