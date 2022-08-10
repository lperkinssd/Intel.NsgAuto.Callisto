CREATE TABLE [npsg].[PRFDCR] (
    [PrfVersion]      INT           NOT NULL,
    [Odm_Desc]        VARCHAR (255) NULL,
    [SSD_Family_Name] VARCHAR (255) NULL,
    [MM_Number]       VARCHAR (50)  NULL,
    [Product_Code]    VARCHAR (50)  NULL,
    [SSD_Name]        VARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME2 (7) CONSTRAINT [DF_NPSG_PRFDCR_CreatedOn] DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  NULL,
    [UpdatedOn]       DATETIME2 (7) CONSTRAINT [DF_NPSG_PRFDCR_UpdatedOn] DEFAULT (getutcdate()) NOT NULL,
    [UpdatedBy]       VARCHAR (50)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_NPSG_PRFDCR]
    ON [npsg].[PRFDCR]([PrfVersion] DESC);

