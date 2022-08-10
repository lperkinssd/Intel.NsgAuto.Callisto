-- ====================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-01 15:18:45.590
-- Description  : Creates a new osat build criteria set. After execution, if the output parameter @Id is null, then the build criteria set was not
--                created and @Message contains the reason. Do not alter and return result sets from this stored procedure. If you want result sets to
--                be returned, use composition (i.e. create a new stored procedure and call this).
-- Example      : DECLARE @Id BIGINT;
--                DECLARE @Message VARCHAR(500);
--                DECLARE @Conditions [qan].[IOsatBuildCriteriaConditionsCreate];
--                INSERT INTO @Conditions ([Index], [AttributeTypeName], [ComparisonOperationKey], [Value]) VALUES (1, 'app_restriction', '=', 'TEST');
--                --an invalid attribute name or comparison operation key will not create a build criteria and return a message (error)
--                --INSERT INTO @Conditions ([Index], [AttributeTypeName], [ComparisonOperationKey], [Value]) VALUES (2, 'does_not_exist', '%', 'NA');
--                EXEC [qan].[CreateOsatBuildCriteriaSet] @Id OUTPUT, @Message OUTPUT, 'bricschx', 1, @Conditions;
--                --DELETE FROM [qan].[OsatBuildCriteriaConditions] WHERE [BuildCriteriaId] = @Id;
--                --DELETE FROM [qan].[OsatBuildCriterias] WHERE [Id] = @Id;
--                PRINT @Id;
--                PRINT @Message;
-- ====================================================================================================================================================
CREATE PROCEDURE [qan].[CreateOsatBuildCriteriaSet]
(
	  @Id                  BIGINT       OUTPUT
	, @Message             VARCHAR(500) OUTPUT
	, @UserId              VARCHAR(25)
	, @BuildCombinationId  INT
	, @BuildCriterias      [qan].[IOsatBuildCriteriasCreate] READONLY
	, @Conditions          [qan].[IOsatBuildCriteriaConditionsCreate] READONLY
	, @Comment             VARCHAR(1000) = NULL
	, @StrictValidation    BIT           = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription                   VARCHAR (1000) = 'Create';
	DECLARE @AttributeTypeName                   VARCHAR (50);
	DECLARE @BuildCombinationIdValid             INT;
	DECLARE @BuildCombinationIsActive            BIT;
	DECLARE @CommentMaxCharacters                INT = 1000;
	DECLARE @Conditions2                         TABLE
	(
		  [Index]                                INT NOT NULL
		, [BuildCriteriaIndex]                   INT NOT NULL
		, [AttributeTypeName]                    VARCHAR (50)
		, [AttributeTypeId]                      INT
		, [AttributeDataTypeId]                  INT
		, [ComparisonOperationId]                INT
		, [ComparisonOperationOperandTypeId]     INT
		, [Value]                                VARCHAR (MAX)
	);
	DECLARE @Count                               INT;
	DECLARE @ErrorsExist                         BIT = 0;
	DECLARE @Index                               INT;
	DECLARE @InsertedBuildCriterias              TABLE
	(
		  [Id]                                   BIGINT NOT NULL
		, [Ordinal]                              INT NOT NULL
	);
	DECLARE @On                                  DATETIME2(7) = GETUTCDATE();
	DECLARE @Succeeded                           BIT = 0;
	DECLARE @Version                             INT;

	SET @Id = NULL;
	SET @Message = NULL;
	SET @ActionDescription = @ActionDescription + '; BuildCombinationId = ' + ISNULL(CAST(@BuildCombinationId AS VARCHAR(20)), 'null');

	-- standardization
	SET @Comment = NULLIF(RTRIM(LTRIM(@Comment)), '');
	IF (@StrictValidation IS NULL) SET @StrictValidation = 1;

	-- begin validation
	SELECT @BuildCombinationIdValid = MAX([Id]), @BuildCombinationIsActive = CAST(MAX(CAST([IsActive] AS INT)) AS BIT) FROM [qan].[OsatBuildCombinations] WITH (NOLOCK) WHERE [Id] = @BuildCombinationId;

	IF (@BuildCombinationIdValid IS NULL)
	BEGIN
		SET @Message = 'Build combination does not exist: ' + ISNULL(CAST(@BuildCombinationId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (@BuildCombinationIsActive = 0 OR @BuildCombinationIsActive IS NULL)
	BEGIN
		SET @Message = 'Build combination is not active: ' + ISNULL(CAST(@BuildCombinationId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (LEN(@Comment) > @CommentMaxCharacters)
	BEGIN
		SET @Message = 'Comments exceed maximum allowed characters: ' + CAST(@CommentMaxCharacters AS VARCHAR(20));
		SET @ErrorsExist = 1;
	END;

	IF (@ErrorsExist = 0)
	BEGIN
		INSERT INTO @Conditions2
		(
			  [Index]
			, [BuildCriteriaIndex]
			, [AttributeTypeName]
			, [AttributeTypeId]
			, [AttributeDataTypeId]
			, [ComparisonOperationId]
			, [ComparisonOperationOperandTypeId]
			, [Value]
		)
		SELECT
			  C.[Index]                                    -- [Index]
			, C.[BuildCriteriaIndex]                       -- [BuildCriteriaIndex]
			, C.[AttributeTypeName]                        -- [AttributeTypeName]
			, A.[Id]                                       -- [AttributeTypeId]
			, A.[DataTypeId]                               -- [AttributeDataTypeId]
			, O.[Id]                                       -- [ComparisonOperationId]
			, OT.[Id]                                      -- [ComparisonOperationOperandTypeId]
			, NULLIF(RTRIM(LTRIM(C.[Value])), '')          -- [Value]
		FROM @Conditions AS C
		LEFT OUTER JOIN [qan].[OsatAttributeTypes] AS A WITH (NOLOCK) ON (A.[Name] = C.[AttributeTypeName])
		LEFT OUTER JOIN [ref].[OsatComparisonOperations] AS O WITH (NOLOCK) ON (O.[Key] = C.[ComparisonOperationKey])
		LEFT OUTER JOIN [ref].[OsatOperandTypes] AS OT WITH (NOLOCK) ON (OT.[Id] = O.[OperandTypeId])
		LEFT OUTER JOIN [ref].[OsatAttributeDataTypeOperations] AS DTO WITH (NOLOCK) ON (DTO.[AttributeDataTypeId] = A.[DataTypeId] AND DTO.[ComparisonOperationId] = O.[Id]);

		SELECT @Count = COUNT(*), @Index = MIN([Index]) FROM @BuildCriterias WHERE NULLIF(LTRIM(RTRIM([Name])), '') IS NULL;
		IF (@Count > 0)
		BEGIN
			SET @Message = 'Name is required for build criteria: ' + ISNULL(CAST(@Index AS VARCHAR(20)), '');
			SET @ErrorsExist = 1;
		END
		ELSE
		BEGIN
			SELECT @Count = COUNT(*) FROM (SELECT [Name] FROM @BuildCriterias GROUP BY [Name] HAVING COUNT(*) > 1) AS T;
			IF (@Count > 0)
			BEGIN
				SET @Message = 'Build criteria names must be unique';
				SET @ErrorsExist = 1;
			END
			ELSE
			BEGIN
				SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @Conditions2 WHERE [AttributeTypeId] IS NULL;
				IF (@Count > 0)
				BEGIN
					SET @Message = 'The conditions contain an invalid attribute type name: ' + ISNULL(@AttributeTypeName, '');
					SET @ErrorsExist = 1;
				END
				ELSE
				BEGIN
					SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @Conditions2 WHERE [ComparisonOperationId] IS NULL;
					IF (@Count > 0)
					BEGIN
						SET @Message = 'The conditions contain an invalid comparison operation key for ' + ISNULL(@AttributeTypeName, '');
						SET @ErrorsExist = 1;
					END
					ELSE
					BEGIN
						SELECT @Count = COUNT(*), @Index = MIN([BuildCriteriaIndex]), @AttributeTypeName = MIN([AttributeTypeName]) FROM @Conditions2 GROUP BY [BuildCriteriaIndex], [AttributeTypeId], [AttributeTypeName] HAVING COUNT(*) > 1;
						IF (@Count > 0)
						BEGIN
							SET @Message = 'Multiple conditions exist for the same attribute type: Criteria ' + ISNULL(CAST(@Index AS VARCHAR(20)), '') + ' ' + ISNULL(@AttributeTypeName, '');
							SET @ErrorsExist = 1;
						END
						ELSE IF (@StrictValidation = 1)
						BEGIN
							SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @Conditions2 WHERE [ComparisonOperationOperandTypeId] <> 3 AND CHARINDEX(',', [Value]) > 0;
							IF (@Count > 0)
							BEGIN
								SET @Message = 'The condition value contains a comma with an incompatible operation for ' + ISNULL(@AttributeTypeName, '');
								SET @ErrorsExist = 1;
							END
							ELSE
							BEGIN
								SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @Conditions2 AS C WHERE C.[AttributeDataTypeId] = 2 AND EXISTS(SELECT 1 FROM STRING_SPLIT(C.[Value], ',') WHERE ISNUMERIC([value]) = 0);
								IF (@Count > 0)
								BEGIN
									SET @Message = 'The conditions contain a non-numeric value for numeric attribute type: ' + ISNULL(@AttributeTypeName, '');
									SET @ErrorsExist = 1;
								END;
							END;
						END;
					END;
				END;
			END;
		END;
	END;
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION

			SELECT @Version = (ISNULL(MAX([Version]), 0) + 1) FROM [qan].[OsatBuildCriteriaSets] WITH (NOLOCK) WHERE [BuildCombinationId] = @BuildCombinationId;

			INSERT INTO [qan].[OsatBuildCriteriaSets]
			(
				  [Version]
				, [IsPOR]
				, [IsActive]
				, [StatusId]
				, [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
				, [BuildCombinationId]
			)
			VALUES
			(
				  @Version                                 -- [Version]
				, 0                                        -- [IsPOR]    = false
				, 1                                        -- [IsActive] = true
				, 1                                        -- [StatusId] = Draft
				, @UserId                                  -- [CreatedBy]
				, @On                                      -- [CreatedOn]
				, @UserId                                  -- [UpdatedBy]
				, @On                                      -- [UpdatedOn]
				, @BuildCombinationId                      -- [BuildCombinationId]
			);

			SELECT @Id = SCOPE_IDENTITY();

			INSERT INTO [qan].[OsatBuildCriterias]
			(
				  [BuildCriteriaSetId]
				, [Ordinal]
				, [Name]
				, [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
			)
			OUTPUT inserted.[Id], inserted.[Ordinal] INTO @InsertedBuildCriterias
			SELECT
				  @Id                                      -- [BuildCriteriaSetId]
				, [Index]                                  -- [Ordinal]
				, [Name]                                   -- [Name]
				, @UserId                                  -- [CreatedBy]
				, @On                                      -- [CreatedOn]
				, @UserId                                  -- [UpdatedBy]
				, @On                                      -- [UpdatedOn]
			FROM @BuildCriterias ORDER BY [Index];

			INSERT INTO [qan].[OsatBuildCriteriaConditions]
			(
				  [BuildCriteriaId]
				, [AttributeTypeId]
				, [ComparisonOperationId]
				, [Value]
				, [CreatedBy]
				, [CreatedOn]
				, [UpdatedBy]
				, [UpdatedOn]
			)
			SELECT
				  I.[Id]                                   -- [BuildCriteriaId]
				, C.[AttributeTypeId]                      -- [AttributeTypeId]
				, C.[ComparisonOperationId]                -- [ComparisonOperationId]
				, C.[Value]                                -- [Value]
				, @UserId                                  -- [CreatedBy]
				, @On                                      -- [CreatedOn]
				, @UserId                                  -- [UpdatedBy]
				, @On                                      -- [UpdatedOn]
			FROM @Conditions2 AS C
			LEFT OUTER JOIN @InsertedBuildCriterias AS I ON (I.[Ordinal] = C.[BuildCriteriaIndex])
			ORDER BY [Index];

			SET @ActionDescription = @ActionDescription + '; Conditions: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

			IF (@Comment IS NOT NULL)
			BEGIN
				INSERT INTO [qan].[OsatBuildCriteriaSetComments]
				(
					  [BuildCriteriaSetId]
					, [Text]
					, [CreatedBy]
					, [CreatedOn]
					, [UpdatedBy]
					, [UpdatedOn]
				)
				VALUES
				(
					  @Id                                  -- [BuildCriteriaSetId]
					, @Comment                             -- [Text]
					, @UserId                              -- [CreatedBy]
					, @On                                  -- [CreatedOn]
					, @UserId                              -- [UpdatedBy]
					, @On                                  -- [UpdatedOn]
				);
				SET @ActionDescription = @ActionDescription + '; Comments: 1';
			END;

		COMMIT;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', 'Create', 'OsatBuildCriteriaSet', @Id, NULL, @Succeeded, @Message, 'OsatBuildCombination', @BuildCombinationId;

END
