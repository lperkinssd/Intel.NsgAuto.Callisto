

-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-02 16:38:31.110
-- Description  : Creates the initial osats
-- Example      : EXEC [setup].[CreateInitialOsats] 'bricschx';
--                SELECT * FROM [qan].[Osats];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateProductPlatforms]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
		TRUNCATE TABLE [ref].[ProductPlatforms];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[ProductPlatforms] ON 
		INSERT [ref].[ProductPlatforms] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'DP PCIe', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-07T00:04:31.6200000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-07T00:04:31.6200000' AS DateTime2))
		INSERT [ref].[ProductPlatforms] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'PCIe', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-07T00:04:31.6200000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-07T00:04:31.6200000' AS DateTime2))
		INSERT [ref].[ProductPlatforms] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'SATA', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-07T00:04:31.6200000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-07T00:04:31.6200000' AS DateTime2))
		SET IDENTITY_INSERT [ref].[ProductPlatforms] OFF
		PRINT 'Table removed successfully';
END