



-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-02 16:38:31.110
-- Description  : Creates the initial osats
-- Example      : EXEC [setup].[CreateInitialOsats] 'bricschx';
--                SELECT * FROM [qan].[Osats];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateProductRoles]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
		TRUNCATE TABLE [ref].[ProductRoles];
		PRINT 'Table removed successfully';	
		SET IDENTITY_INSERT [ref].[ProductRoles] ON 
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'Others', N'NAND', 1, NULL, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'PDT', N'NAND', 1, NULL, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'PME', N'NAND', 1, 1, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (4, N'PME Manager Back Up', N'NAND', 1, 1, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (5, N'PME Manager', N'NAND', 1, 1, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (6, N'PMT', N'NAND', 1, 1, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (7, N'PMT Manager Back Up', N'NAND', 1, 1, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (8, N'PMT Manager', N'NAND', 1, 1, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (9, N'PQE', N'NAND', 1, NULL, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		INSERT [ref].[ProductRoles] ([Id], [Name], [Process], [IsActive], [PCN], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (10, N'TME', N'NAND', 1, NULL, N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:46:41.7900000' AS DateTime2))
		
		SET IDENTITY_INSERT [ref].[ProductRoles] OFF
		PRINT 'Table removed successfully';
END