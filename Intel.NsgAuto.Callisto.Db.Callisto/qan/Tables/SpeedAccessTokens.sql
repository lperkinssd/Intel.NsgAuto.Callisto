CREATE TABLE [qan].[SpeedAccessTokens] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [AccessToken] VARCHAR (2000) NOT NULL,
    [TokenType]   VARCHAR (25)   NULL,
    [ExpiresOn]   DATETIME2 (7)  NOT NULL,
    [CreatedBy]   VARCHAR (25)   NULL,
    [CreatedOn]   DATETIME2 (7)  DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]   VARCHAR (25)   NULL,
    [UpdatedOn]   DATETIME2 (7)  DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

