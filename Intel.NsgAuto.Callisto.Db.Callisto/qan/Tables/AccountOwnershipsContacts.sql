CREATE TABLE [qan].[AccountOwnershipsContacts] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [OwnershipId]   INT           NOT NULL,
    [ContactRoleId] INT           NOT NULL,
    [IsActive]      BIT           CONSTRAINT [DF_AccountOwnershipsContacts_IsActive] DEFAULT ((1)) NULL,
    [CreatedBy]     VARCHAR (25)  NOT NULL,
    [CreatedOn]     DATETIME2 (7) NOT NULL,
    [UpdatedBy]     VARCHAR (25)  NOT NULL,
    [UpdatedOn]     DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_AccountOwnershipsContacts] PRIMARY KEY CLUSTERED ([ID] ASC)
);





