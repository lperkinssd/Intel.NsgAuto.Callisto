CREATE TABLE [stage].[PRFDCR] (
    [Prf_Id]          INT             NULL,
    [WW]              NVARCHAR (50)   NULL,
    [Odm_desc]        NVARCHAR (50)   NULL,
    [SSD_family_name] NVARCHAR (50)   NULL,
    [MM_number]       NVARCHAR (50)   NULL,
    [Product_Code]    NVARCHAR (50)   NULL,
    [SSD_name]        NVARCHAR (3000) NULL,
    [CreateDate]      DATETIME        NULL,
    [User]            NVARCHAR (50)   NULL,
    [Latest]          NVARCHAR (50)   NULL,
    [FileType]        NVARCHAR (50)   NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_SSD_family_name]
    ON [stage].[PRFDCR]([SSD_family_name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Product_Code]
    ON [stage].[PRFDCR]([Product_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Prf_Id]
    ON [stage].[PRFDCR]([Prf_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Odm_desc]
    ON [stage].[PRFDCR]([Odm_desc] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MM_number]
    ON [stage].[PRFDCR]([MM_number] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Latest]
    ON [stage].[PRFDCR]([Latest] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FileType]
    ON [stage].[PRFDCR]([FileType] ASC);

