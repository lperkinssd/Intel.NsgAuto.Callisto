CREATE TABLE [qan].[SpeedBomAssociationTypes]
(
      [Id]        INT           IDENTITY (1, 1) NOT NULL
    , [Name]      VARCHAR (20)  NOT NULL
    , [CodeSpeed] VARCHAR (1)   NOT NULL
    , [NameSpeed] VARCHAR (20)  NOT NULL
    , [CreatedBy] VARCHAR (25)  NOT NULL
    , [CreatedOn] DATETIME2 (7) DEFAULT (GETUTCDATE()) NOT NULL
    , [UpdatedBy] VARCHAR (25)  NOT NULL
    , [UpdatedOn] DATETIME2 (7) DEFAULT (GETUTCDATE()) NOT NULL
    , CONSTRAINT [PK_SpeedBomAssociationTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_SpeedBomAssociationTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
    , CONSTRAINT [U_SpeedBomAssociationTypes_CodeSpeed] UNIQUE NONCLUSTERED ([CodeSpeed] ASC)
    , CONSTRAINT [U_SpeedBomAssociationTypes_NameSpeed] UNIQUE NONCLUSTERED ([NameSpeed] ASC)
);
