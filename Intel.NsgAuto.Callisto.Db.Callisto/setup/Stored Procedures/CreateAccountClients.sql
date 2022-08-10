

-- =================================================================================
-- Author       : jayapa1x
-- Create date  : 2021-11-23 16:38:31.110
-- Description  : Creates the initial Account Clients
-- Example      : EXEC [setup].[CreateAccountClients] 'jayapa1x';
--                SELECT * FROM [qan].[AccountClients];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAccountClients]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	TRUNCATE TABLE [ref].[AccountClients];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[AccountClients] ON 
			INSERT [ref].[AccountClients] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'Client', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2))
			INSERT [ref].[AccountClients] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (4, N'Cloud Service Providers', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2))
			INSERT [ref].[AccountClients] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (5, N'CSP', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2))
			INSERT [ref].[AccountClients] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (6, N'DC', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2))
			INSERT [ref].[AccountClients] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (7, N'Embedded', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:40:22.4800000' AS DateTime2))
			SET IDENTITY_INSERT [ref].[AccountClients] OFF
		PRINT 'Table removed successfully';
END