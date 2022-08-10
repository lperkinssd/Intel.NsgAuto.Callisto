CREATE TABLE [npsg].[OdmManualDispositions] (
    [Id]                     INT           IDENTITY (1, 1) NOT NULL,
    [Version]                INT           NOT NULL,
    [SLot]                   VARCHAR (25)  NOT NULL,
    [IntelPartNumber]        VARCHAR (25)  NOT NULL,
    [LotDispositionReasonId] INT           NOT NULL,
    [Notes]                  VARCHAR (MAX) NULL,
    [LotDispositionActionId] INT           NOT NULL,
    [CreatedOn]              DATETIME2 (7) CONSTRAINT [DF_NPSG_OdmManualDispositions_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy]              VARCHAR (255) NOT NULL,
    [UpdatedOn]              DATETIME2 (7) CONSTRAINT [DF_NPSG_OdmManualDispositions_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]              VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_NPSG_OdmManualDispositions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

