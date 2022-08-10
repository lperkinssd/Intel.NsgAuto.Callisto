

-- =================================================================================
-- Author       : jayapa1x
-- Create date  : 2021-11-23 16:38:31.110
-- Description  : Creates the initial Account Roles
-- Example      : EXEC [setup].[CreateAccountRoles] 'jayapa1x';
--                SELECT * FROM [ref].[AccountRoles];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAccountRoles]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	TRUNCATE TABLE [ref].[AccountRoles];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[AccountRoles] ON 
		
	INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (6, N'FAE', 1, NULL, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (7, N'FSE', 1, NULL, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (9, N'AE', 1, 1, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (10, N'CQE', 1, NULL, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (11, N'AE Manager', 1, 1, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (12, N'CQE Manager Backup', 1, NULL, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (14, N'PCN', 1, NULL, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (15, N'AE Manager Backup', 1, NULL, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		INSERT [ref].[AccountRoles] ([Id], [Name], [IsActive], [PCN], [Process], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (16, N'CQE Manager', 1, 1, N'NAND', N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-10T22:21:43.5933333' AS DateTime2))
		SET IDENTITY_INSERT [ref].[AccountRoles] OFF
		PRINT 'Table removed successfully';
END