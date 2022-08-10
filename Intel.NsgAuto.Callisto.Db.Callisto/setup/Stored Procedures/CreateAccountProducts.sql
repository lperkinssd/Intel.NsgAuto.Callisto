

-- =================================================================================
-- Author       : jayapa1x
-- Create date  : 2021-11-23 16:38:31.110
-- Description  : Creates the  Intial Account Products
-- Example      : EXEC [setup].[CreateAccountProducts] 'jayapa1x';
--                SELECT * FROM [ref].[AccountProducts];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAccountProducts]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	TRUNCATE TABLE [ref].[AccountProducts];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[AccountProducts] ON 
		INSERT [ref].[AccountProducts] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'All', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2))
		INSERT [ref].[AccountProducts] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (4, N'PCIe', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2))
		INSERT [ref].[AccountProducts] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (5, N'SATA', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2))
		INSERT [ref].[AccountProducts] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (6, N'SATA/PCIe', N'NAND', 1, N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2), N'SYSTEM', CAST(N'2021-11-15T18:49:06.2833333' AS DateTime2))
		
		SET IDENTITY_INSERT [ref].[AccountProducts] OFF
		PRINT 'Table removed successfully';
END