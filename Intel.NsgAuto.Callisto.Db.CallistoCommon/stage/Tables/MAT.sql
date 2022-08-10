CREATE TABLE [stage].[MAT] (
    [MAT_Id]                       INT            NULL,
    [WW]                           NVARCHAR (10)  NULL,
    [SSD_Id]                       NVARCHAR (100) NULL,
    [Design_Id]                    NVARCHAR (50)  NULL,
    [Scode]                        NVARCHAR (50)  NULL,
    [Cell_Revision]                NVARCHAR (50)  NULL,
    [Major_Probe_Program_Revision] NVARCHAR (50)  NULL,
    [Probe_Revision]               NVARCHAR (50)  NULL,
    [Burn_Tape_Revision]           NVARCHAR (50)  NULL,
    [Custom_Testing_Required]      NVARCHAR (50)  NULL,
    [Custom_Testing_Required2]     NVARCHAR (50)  NULL,
    [Product_Grade]                NVARCHAR (100) NULL,
    [Prb_Conv_Id]                  NVARCHAR (100) NULL,
    [Fab_Conv_Id]                  NVARCHAR (100) NULL,
    [Fab_Excr_Id]                  NVARCHAR (100) NULL,
    [Media_Type]                   NVARCHAR (100) NULL,
    [Media_IPN]                    NVARCHAR (50)  NULL,
    [Device_Name]                  NVARCHAR (100) NULL,
    [Reticle_Wave_Id]              NVARCHAR (100) NULL,
    [Fab_Facility]                 NVARCHAR (100) NULL,
    [Create_Date]                  DATETIME       NULL,
    [User]                         NVARCHAR (50)  NULL,
    [Latest]                       NVARCHAR (10)  NULL,
    [File_Type]                    NVARCHAR (10)  NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_Scode]
    ON [stage].[MAT]([Scode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Media_Type]
    ON [stage].[MAT]([Media_Type] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Media_IPN]
    ON [stage].[MAT]([Media_IPN] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MAT_Id]
    ON [stage].[MAT]([MAT_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Latest]
    ON [stage].[MAT]([Latest] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_File_Type]
    ON [stage].[MAT]([File_Type] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Fab_Facility]
    ON [stage].[MAT]([Fab_Facility] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Device_Name]
    ON [stage].[MAT]([Device_Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Design_Id]
    ON [stage].[MAT]([Design_Id] ASC);

