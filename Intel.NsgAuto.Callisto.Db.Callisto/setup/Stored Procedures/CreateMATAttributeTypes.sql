-- =================================================================================
-- Author       : jakemurx
-- Create date  : 2020-09-28 15:45:38.446
-- Description  : Creates the MAT attribute types
-- Example      : EXEC [setup].[CreateMATAttributeTypes];
--                SELECT * FROM [ref].[MATAttributeTypes];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateMATAttributeTypes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[MATAttributeTypes]';
	BEGIN
		TRUNCATE TABLE [ref].[MATAttributeTypes];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[MATAttributeTypes] ON;

		INSERT [ref].[MATAttributeTypes] ([Id], [Name], [NameDisplay])
		VALUES
			  (1, 'CellRevision', 'Cell Revision')
			, (2, 'MajorProbeProgramRevision', 'Major Probe Program Revision')
			, (3, 'ProbeRevision', 'Probe Revision')
			, (4, 'BurnTapeRevision', 'Burn Tape Revision')
			, (5, 'CustomTestingReqd', 'Custom Testing Required')
			, (6, 'CustomTestingReqd2', 'Custom Testing Required 2')
			, (7, 'ProductGrade', 'Product Grade')
			, (8, 'PrbConvId', 'Prb Conv Id')
			, (9, 'FabExcrId', 'Fab Excr Id')
			, (10, 'FabConvId', 'Fab Conv Id')
			, (11, 'ReticleWaveId', 'Reticle Wave Id')
			, (12, 'FabFacility', 'Fab Facility');

		SET IDENTITY_INSERT [ref].[MATAttributeTypes] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[MATAttributeTypes] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
