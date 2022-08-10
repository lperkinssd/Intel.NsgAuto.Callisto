CREATE TABLE [qan].[AccountOwnerships] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [AccountClientId]     INT            NULL,
    [AccountCustomerId]   INT            NULL,
    [AccountSubsidiaryId] INT            NULL,
    [AccountProductid]    INT            NULL,
    [AccountProcess]      VARCHAR (25)   NULL,
    [IsActive]            BIT            NULL,
    [Notes]               VARCHAR (4000) NULL,
    [CreatedBy]           VARCHAR (25)   NOT NULL,
    [CreatedOn]           DATETIME2 (7)  NOT NULL,
    [UpdatedBy]           VARCHAR (25)   NOT NULL,
    [UpdatedOn]           DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_AccountOwnerships] PRIMARY KEY CLUSTERED ([Id] ASC)
);

