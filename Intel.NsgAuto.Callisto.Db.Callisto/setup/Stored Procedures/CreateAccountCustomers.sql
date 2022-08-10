

-- =================================================================================
-- Author       : jayapa1x
-- Create date  : 2021-11-23 16:38:31.110
-- Description  : Creates the initial Account Customers
-- Example      : EXEC [setup].[CreateAccountCustomers] 'jayapa1x';
--                SELECT * FROM [qan].[AccountCustomers];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAccountCustomers]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	TRUNCATE TABLE [ref].[AccountCustomers];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[AccountCustomers] ON 
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (23, N'Amazon', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (24, N'Apple', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (25, N'Cisco DC', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (26, N'Dell', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (27, N'Dell/EMC', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (28, N'Facebook', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (29, N'Fujitsu', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (30, N'Generic', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (31, N'Google', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (32, N'HGST', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (33, N'Hitachi', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (34, N'HPE', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (35, N'HPI', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (36, N'HuaWei', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (37, N'IBM', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (38, N'Lenovo', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (39, N'Microsoft', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (40, N'Oracle', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (41, N'Panasonic', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (42, N'Regional Accts', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (43, N'Retail', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (44, N'Retional Accts', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (45, N'Shunwang', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
	INSERT [ref].[AccountCustomers] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (46, N'Supermicro', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:43:39.0933333' AS DateTime2))
		SET IDENTITY_INSERT [ref].[AccountCustomers] OFF
		PRINT 'Table removed successfully';
END