


-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-02 16:38:31.110
-- Description  : Creates the initial osats
-- Example      : EXEC [setup].[CreateInitialOsats] 'bricschx';
--                SELECT * FROM [qan].[Osats];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateProductLifeCycleStatuses]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	TRUNCATE TABLE [ref].[ProductLifeCycleStatuses];
		PRINT 'Table removed successfully';
		SET IDENTITY_INSERT [ref].[ProductLifeCycleStatuses] ON 

		INSERT [ref].[ProductLifeCycleStatuses] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'EOL', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-07T00:28:17.4400000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-07T00:28:17.4400000' AS DateTime2))

		INSERT [ref].[ProductLifeCycleStatuses] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'Production', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-07T00:28:17.4400000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-07T00:28:17.4400000' AS DateTime2))

		INSERT [ref].[ProductLifeCycleStatuses] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (7, N'In Planning', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-07T00:28:33.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-07T00:28:33.8633333' AS DateTime2))

		INSERT [ref].[ProductLifeCycleStatuses] ([Id], [Name], [Process], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (8, N'NPI', N'NAND', 1, N'SYSTEM', CAST(N'2021-12-07T00:28:33.8633333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-07T00:28:33.8633333' AS DateTime2))


		SET IDENTITY_INSERT [ref].[ProductLifeCycleStatuses] OFF
		PRINT 'Table removed successfully';
END