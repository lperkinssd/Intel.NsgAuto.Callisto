

-- =================================================================================
-- Author       : jayapa1x
-- Create date  : 2021-11-23 16:38:31.110
-- Description  : Creates the initial Account AccountSubsidiaries
-- Example      : EXEC [setup].[CreateAccountSubsidiaries] 'jayapa1x';
--                SELECT * FROM [ref].[AccountSubsidiaries];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAccountSubsidiaries]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	TRUNCATE TABLE [ref].[AccountSubsidiaries];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[AccountSubsidiaries] ON 
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (7, N'3Par (Storage, Dual Port)', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (8, N'AMR', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (9, N'Dell DSS/ESI', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (10, N'Dell PE', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (11, N'EMEA', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (12, N'HPI', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (13, N'Legacy EMC', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		INSERT [ref].[AccountSubsidiaries] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (14, N'Servers (Single Port)', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:48:38.8633333' AS DateTime2))
		
		SET IDENTITY_INSERT [ref].[AccountSubsidiaries] OFF
		PRINT 'Table removed successfully';
END