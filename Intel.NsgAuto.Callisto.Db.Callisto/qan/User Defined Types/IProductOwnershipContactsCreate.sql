CREATE TYPE [qan].[IProductOwnershipContactsCreate] AS TABLE (
    [ContactName]        VARCHAR (255) NULL,
    [ContactId]          INT           NULL,
    [ContactRoleId]      INT           NULL,
    [ProductOwnershipId] INT           NULL,
    [Email]              VARCHAR (255) NULL,
    [AlternateEmail]     VARCHAR (255) NULL,
    [idSid]              VARCHAR (15)  NULL,
    [RoleName]           VARCHAR (255) NULL,
    [WWID]               VARCHAR (20)  NULL);



