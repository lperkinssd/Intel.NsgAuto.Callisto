CREATE TABLE [stage].[SpeedIcFlashItems] (
    [ItemId]                  NVARCHAR (21)  NOT NULL,
    [BacksideMarkCode]        NVARCHAR (255) NULL,
    [DensityUnitOfMeasure]    NVARCHAR (255) NULL,
    [EccIndicator]            NVARCHAR (255) NULL,
    [IcPackageType]           NVARCHAR (255) NULL,
    [ICPinCount]              NVARCHAR (255) NULL,
    [IntelFlash]              NVARCHAR (255) NULL,
    [MemoryDensity]           NVARCHAR (255) NULL,
    [MemoryAdditionalInfo]    NVARCHAR (255) NULL,
    [MemoryAssyType]          NVARCHAR (255) NULL,
    [MemoryBlankProg]         NVARCHAR (255) NULL,
    [MemoryDeviceName]        NVARCHAR (255) NULL,
    [MemoryChannelWidthCount] NVARCHAR (255) NULL,
    [MemoryType]              NVARCHAR (255) NULL,
    [MemoryPlatform]          NVARCHAR (255) NULL,
    [MemorySize]              NVARCHAR (255) NULL,
    [MemorySpeed]             NVARCHAR (255) NULL,
    [MemorySpeedUom]          NVARCHAR (255) NULL,
    [MemoryVoltage]           NVARCHAR (255) NULL,
    [ManufPackageDesignator]  NVARCHAR (255) NULL,
    [RevisionCode]            NVARCHAR (255) NULL,
    [SpecCode]                NVARCHAR (255) NULL,
    [SpecType]                NVARCHAR (255) NULL,
    [SteppingCode]            NVARCHAR (255) NULL,
    [TemperatureGrade]        NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ItemId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_SpecCode]
    ON [stage].[SpeedIcFlashItems]([SpecCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MemoryType]
    ON [stage].[SpeedIcFlashItems]([MemoryType] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MemoryDeviceName]
    ON [stage].[SpeedIcFlashItems]([MemoryDeviceName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MemoryAssyType]
    ON [stage].[SpeedIcFlashItems]([MemoryAssyType] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_IntelFlash]
    ON [stage].[SpeedIcFlashItems]([IntelFlash] ASC);

