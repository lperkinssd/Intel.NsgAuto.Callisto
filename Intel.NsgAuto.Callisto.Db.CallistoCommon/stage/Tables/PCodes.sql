CREATE TABLE [stage].[PCodes] (
    [PCode]              NVARCHAR (21) NOT NULL,
    [IncludeSpeedPull]   BIT           NOT NULL,
    [IncludeMMRecipes]   BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([PCode] ASC)
);
