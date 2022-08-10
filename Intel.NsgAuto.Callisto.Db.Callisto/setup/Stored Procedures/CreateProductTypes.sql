

-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-02 16:38:31.110
-- Description  : Creates the initial osats
-- Example      : EXEC [setup].[CreateInitialOsats] 'bricschx';
--                SELECT * FROM [qan].[Osats];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateProductTypes]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	TRUNCATE TABLE [ref].[ProductTypes];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[ProductTypes] ON 
		INSERT [ref].[ProductTypes] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'Client', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-06T23:57:46.2500000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:57:46.2500000' AS DateTime2))
		INSERT [ref].[ProductTypes] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'Data Center', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-06T23:57:46.2500000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:57:46.2500000' AS DateTime2))
		INSERT [ref].[ProductTypes] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'Embedded', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-06T23:57:46.2500000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-06T23:57:46.2500000' AS DateTime2))
		SET IDENTITY_INSERT [ref].[ProductTypes] OFF
		PRINT 'Table removed successfully';
END