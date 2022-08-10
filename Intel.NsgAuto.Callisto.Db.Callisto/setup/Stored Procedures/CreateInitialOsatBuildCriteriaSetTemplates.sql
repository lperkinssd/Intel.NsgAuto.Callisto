-- ===========================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-30 13:45:02.330
-- Description  : Creates the initial build criteria set templates, templates and conditions
-- Example      : EXEC [setup].[CreateInitialOsatBuildCriteriaSetTemplates] 'bricschx';
--                SELECT * FROM [qan].[OsatBuildCriteriaSetTemplates];
--                SELECT * FROM [qan].[OsatBuildCriteriaTemplates];
--                SELECT * FROM [qan].[OsatBuildCriteriaTemplateConditions];
-- ===========================================================================================
CREATE PROCEDURE [setup].[CreateInitialOsatBuildCriteriaSetTemplates]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Conditions                TABLE
	(
		[TemplateId]                   INT            NOT NULL,
		[AttributeTypeId]              INT            NOT NULL,
		[AttributeTypeName]            VARCHAR (50)   NOT NULL,
		[ComparisonOperationId]        INT            NOT NULL,
		[ComparisonOperationKey]       VARCHAR (25)   NOT NULL,
		[Value]                        VARCHAR (4000) NULL
	);
	DECLARE @CountSetTemplates         INT = 0;
	DECLARE @CountTemplates            INT = 0;
	DECLARE @CountConditions           INT = 0;
	DECLARE @InitialRecords            TABLE
	(
		  [DesignFamilyName]           VARCHAR(10) NOT NULL
		, [TemplateOrdinal]            INT         NOT NULL
		, [TemplateName]               VARCHAR(50) NOT NULL
		, [AttributeTypeName]          VARCHAR(50) NOT NULL
		, [ComparisonOperationKey]     VARCHAR(50) NOT NULL
		, [Value]                      VARCHAR(4000)
	);
	DECLARE @InsertedTemplates         TABLE
	(
		  [Id]                         INT NOT NULL
		, [Ordinal]                    INT NOT NULL
		PRIMARY KEY CLUSTERED ([Id] ASC)
	);
	DECLARE @Message                   VARCHAR(MAX);
	DECLARE @SetTemplates              TABLE
	(
		  [Id]                         INT IDENTITY(1, 1) NOT NULL PRIMARY KEY
		, [DesignFamilyId]             INT
		, [DesignFamilyName]           VARCHAR(10)
	);

	IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	INSERT INTO @InitialRecords ([DesignFamilyName], [TemplateOrdinal], [TemplateName], [AttributeTypeName], [ComparisonOperationKey], [Value])
	VALUES
		  ( 'NAND'  , 1, 'Criteria 1', 'burn_tape_revision'  , '>='              , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'cell_revision'       , '>='              , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'country_of_assembly' , '='               , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'fab_excr_id'         , '='               , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'fabrication_facility', '='               , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'major_probe_prog_rev', '>='              , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'non_shippable'       , '='               , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'product_grade'       , '='               , NULL )
		, ( 'NAND'  , 1, 'Criteria 1', 'reticle_wave_id'     , 'in'              , NULL )

	INSERT INTO @SetTemplates ([DesignFamilyId], [DesignFamilyName])
	SELECT DF.[Id], C.[DesignFamilyName] FROM
		(SELECT DISTINCT [DesignFamilyName] FROM @InitialRecords) AS C
		LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Name] = C.[DesignFamilyName]);

	DECLARE @Count            INT;
	DECLARE @DesignFamilyId   INT;
	DECLARE @DesignFamilyName VARCHAR(10);
	DECLARE @SetTemplateId    INT;
	DECLARE @TemplateId       INT;
	DECLARE @TempId           INT;
	WHILE (EXISTS (SELECT * FROM @SetTemplates))
	BEGIN
		SELECT TOP 1
			  @TempId = [Id]
			, @DesignFamilyId = [DesignFamilyId]
			, @DesignFamilyName = [DesignFamilyName]
		FROM @SetTemplates;

		SELECT @Count = COUNT(*) FROM [qan].[OsatBuildCriteriaSetTemplates] WITH (NOLOCK) WHERE [DesignFamilyId] = @DesignFamilyId;

		-- only create if a set template with the given design family id does not exist
		IF (@Count = 0)
		BEGIN
			DELETE FROM @InsertedTemplates;
			DELETE FROM @Conditions;

			INSERT INTO [qan].[OsatBuildCriteriaSetTemplates] ([Name], [DesignFamilyId]) VALUES (@DesignFamilyName, @DesignFamilyId);
			SELECT @SetTemplateId = SCOPE_IDENTITY();
			SET @CountSetTemplates = @CountSetTemplates + 1;

			INSERT INTO [qan].[OsatBuildCriteriaTemplates] ([SetTemplateId], [Ordinal], [Name])
			OUTPUT inserted.[Id], inserted.[Ordinal] INTO @InsertedTemplates
			SELECT DISTINCT @SetTemplateId, [TemplateOrdinal], [TemplateName] FROM @InitialRecords WHERE [DesignFamilyName] = @DesignFamilyName ORDER BY [TemplateOrdinal];
			SET @CountTemplates = @CountTemplates + @@ROWCOUNT;

			INSERT INTO @Conditions ([TemplateId], [AttributeTypeId], [AttributeTypeName], [ComparisonOperationId], [ComparisonOperationKey], [Value])
			SELECT
				  IT.[Id]
				, AC.[Id]
				, C.[AttributeTypeName]
				, CO.[Id]
				, C.[ComparisonOperationKey]
				, C.[Value]
			FROM @InitialRecords AS C
			INNER JOIN @InsertedTemplates AS IT ON (IT.[Ordinal] = C.[TemplateOrdinal])
			LEFT OUTER JOIN [qan].[OsatAttributeTypes] AS AC WITH (NOLOCK) ON (AC.[Name] = C.[AttributeTypeName])
			LEFT OUTER JOIN [ref].[OsatComparisonOperations] AS CO WITH (NOLOCK) ON (CO.[Key] = C.[ComparisonOperationKey])
			WHERE C.[DesignFamilyName] = @DesignFamilyName;

			INSERT INTO [qan].[OsatBuildCriteriaTemplateConditions] ([TemplateId], [AttributeTypeId], [ComparisonOperationId], [Value])
			SELECT @SetTemplateId, [AttributeTypeId], [ComparisonOperationId], [Value] FROM @Conditions ORDER BY [TemplateId], [AttributeTypeName], [ComparisonOperationId];
			SET @CountConditions = @CountConditions + @@ROWCOUNT;
		END;

		DELETE FROM @SetTemplates WHERE [Id] = @TempId;
	END;

	SET @Message = '[qan].[OsatBuildCriteriaSetTemplates] records created: ' + CAST(@CountSetTemplates AS VARCHAR(20));
	PRINT @Message;
	SET @Message = '[qan].[OsatBuildCriteriaTemplates] records created: ' + CAST(@CountTemplates AS VARCHAR(20));
	PRINT @Message;
	SET @Message = '[qan].[OsatBuildCriteriaTemplateConditions] records created: ' + CAST(@CountConditions AS VARCHAR(20));
	PRINT @Message;

END
