-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-17 12:13:55.110
-- Description  : Creates the initial build criteria templates and conditions
-- Example      : EXEC [setup].[CreateInitialAcBuildCriteriaTemplates] 'bricschx';
--                SELECT * FROM [qan].[AcBuildCriteriaTemplates];
--                SELECT * FROM [qan].[AcBuildCriteriaTemplateConditions];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateInitialAcBuildCriteriaTemplates]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Conditions TABLE
	(
		[Index]                             INT           NOT NULL,
		[AttributeTypeId]                   INT           NOT NULL,
		[AttributeTypeName]                 VARCHAR (50)  NOT NULL,
		[ComparisonOperationId]             INT           NOT NULL,
		[ComparisonOperationKeyTreadstone]  VARCHAR (25)  NOT NULL,
		[Value]                             VARCHAR (MAX) NULL,
		PRIMARY KEY CLUSTERED ([Index] ASC)
	);
	DECLARE @CountTemplates INT = 0;
	DECLARE @CountConditions INT = 0;
	DECLARE @InitialRecords TABLE
	(
		  [DesignFamilyName]                  VARCHAR(10) NOT NULL
		, [AttributeName]                     VARCHAR(50) NOT NULL
		, [ComparisonOperationKeyTreadstone]  VARCHAR(50) NOT NULL
		, [Value]                             VARCHAR(MAX)
	);
	DECLARE @Message VARCHAR(MAX);
	DECLARE @Templates TABLE
	(
		  [Id]                       INT IDENTITY(1, 1) NOT NULL PRIMARY KEY
		, [Name]                     VARCHAR(50)
		, [DesignFamilyId]           INT
		, [DesignFamilyName]         VARCHAR(10)
	);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	INSERT INTO @InitialRecords ([DesignFamilyName], [AttributeName], [ComparisonOperationKeyTreadstone], [Value])
	VALUES
		  ( 'NAND'  , 'cell_revision'       , '='               , NULL )
		, ( 'NAND'  , 'cmos_revision'       , '>='              , NULL )
		, ( 'NAND'  , 'country_of_assembly' , 'in'              , NULL )
		, ( 'NAND'  , 'fab_conv_id'         , '>='              , NULL )
		, ( 'NAND'  , 'fab_excr_id'         , 'in'              , NULL )
		, ( 'NAND'  , 'major_probe_prog_rev', '>='              , NULL )
		, ( 'NAND'  , 'offshore_asm_company', 'in'              , NULL )
		, ( 'NAND'  , 'probe_ship_part_type', 'does not contain', NULL )
		, ( 'NAND'  , 'product_grade'       , 'in'              , NULL )
		, ( 'NAND'  , 'reticle_wave_id'     , '>='              , NULL );

	INSERT INTO @Templates ([DesignFamilyId], [DesignFamilyName])
	SELECT DF.[Id], C.[DesignFamilyName] FROM
		(SELECT DISTINCT [DesignFamilyName] FROM @InitialRecords) AS C
		LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Name] = C.[DesignFamilyName]);

	DECLARE @Count INT;
	DECLARE @DesignFamilyId INT;
	DECLARE @DesignFamilyName VARCHAR(10);
	DECLARE @Id INT;
	DECLARE @TempId INT;
	WHILE (EXISTS (SELECT * FROM @Templates))
	BEGIN
		SELECT TOP 1
			  @TempId = [Id]
			, @DesignFamilyId = [DesignFamilyId]
			, @DesignFamilyName = [DesignFamilyName]
		FROM @Templates;

		SELECT @Count = COUNT(*) FROM [qan].[AcBuildCriteriaTemplates] WITH (NOLOCK) WHERE [DesignFamilyId] = @DesignFamilyId;

		-- only create if a template with the given design family id does not exist
		IF (@Count = 0)
		BEGIN
			DELETE FROM @Conditions;
			INSERT INTO @Conditions ([Index], [AttributeTypeId], [AttributeTypeName], [ComparisonOperationId], [ComparisonOperationKeyTreadstone], [Value])
			SELECT
				  ROW_NUMBER() OVER(ORDER BY C.[AttributeName], C.[ComparisonOperationKeyTreadstone], C.[Value]) AS [Index]
				, AC.[Id]
				, C.[AttributeName]
				, CO.[Id]
				, C.[ComparisonOperationKeyTreadstone]
				, C.[Value]
			FROM @InitialRecords AS C
			LEFT OUTER JOIN [qan].[AcAttributeTypes] AS AC WITH (NOLOCK) ON (AC.[Name] = C.[AttributeName])
			LEFT OUTER JOIN [ref].[AcComparisonOperations] AS CO WITH (NOLOCK) ON (CO.[KeyTreadstone] = C.[ComparisonOperationKeyTreadstone])
			WHERE [DesignFamilyName] = @DesignFamilyName;

			INSERT INTO [qan].[AcBuildCriteriaTemplates] ([Name], [DesignFamilyId]) VALUES (@DesignFamilyName, @DesignFamilyId);
			SELECT @Id = SCOPE_IDENTITY();
			SET @CountTemplates = @CountTemplates + 1;

			INSERT INTO [qan].[AcBuildCriteriaTemplateConditions] ([TemplateId], [AttributeTypeId], [ComparisonOperationId], [Value])
				SELECT @Id, [AttributeTypeId], [ComparisonOperationId], [Value] FROM @Conditions;
			SET @CountConditions = @CountConditions + @@ROWCOUNT;
		END;

		DELETE FROM @Templates WHERE [Id] = @TempId;
	END;

	SET @Message = '[qan].[AcBuildCriteriaTemplates] records created: ' + CAST(@CountTemplates AS VARCHAR(20));
	PRINT @Message;
	SET @Message = '[qan].[AcBuildCriteriaTemplateConditions] records created: ' + CAST(@CountConditions AS VARCHAR(20));
	PRINT @Message;

END
