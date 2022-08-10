CREATE TABLE [qan].[OsatPackageDieTypes] (
    [Id]                   INT           IDENTITY (1, 1) NOT NULL,
    [Name]                 VARCHAR (10)  NOT NULL,
    [DeviceNameCharacter]  VARCHAR (1)   NOT NULL,
    [PackageDieCount]      INT           NOT NULL,
    CONSTRAINT [PK_OsatPackageDieTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [U_OsatPackageDieTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC),
);

GO

CREATE INDEX [IX_OsatPackageDieTypes_DeviceNameCharacter] ON [qan].[OsatPackageDieTypes] ([DeviceNameCharacter])
