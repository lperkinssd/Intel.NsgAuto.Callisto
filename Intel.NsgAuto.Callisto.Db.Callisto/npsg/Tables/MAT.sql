CREATE TABLE [npsg].[MAT] (
    [MatVersion]                   INT           NOT NULL,
    [WW]                           VARCHAR (10)  NOT NULL,
    [SSD_Id]                       VARCHAR (100) NULL,
    [Design_Id]                    VARCHAR (50)  NULL,
    [Scode]                        VARCHAR (50)  NULL,
    [Cell_Revision]                VARCHAR (50)  NULL,
    [Major_Probe_Program_Revision] VARCHAR (50)  NULL,
    [Probe_Revision]               VARCHAR (50)  NULL,
    [Burn_Tape_Revision]           VARCHAR (50)  NULL,
    [Custom_Testing_Required]      VARCHAR (50)  NULL,
    [Custom_Testing_Required2]     VARCHAR (50)  NULL,
    [Product_Grade]                VARCHAR (100) NULL,
    [Prb_Conv_Id]                  VARCHAR (100) NULL,
    [Fab_Conv_Id]                  VARCHAR (100) NULL,
    [Fab_Excr_Id]                  VARCHAR (100) NULL,
    [Media_Type]                   VARCHAR (100) NULL,
    [Media_IPN]                    VARCHAR (50)  NULL,
    [Device_Name]                  VARCHAR (100) NULL,
    [Reticle_Wave_Id]              VARCHAR (100) NULL,
    [Fab_Facility]                 VARCHAR (100) NOT NULL,
    [Latest]                       BIT           NOT NULL,
    [FileType]                     VARCHAR (10)  NULL,
    [CreatedOn]                    DATETIME2 (7) CONSTRAINT [DF_NPSG_MAT_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy]                    VARCHAR (50)  NULL,
    [UpdatedOn]                    DATETIME2 (7) CONSTRAINT [DF_NPSG_MAT_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]                    VARCHAR (50)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_NPSG_MAT_Latest]
    ON [npsg].[MAT]([Latest] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_NPSG_MAT]
    ON [npsg].[MAT]([MatVersion] DESC);

