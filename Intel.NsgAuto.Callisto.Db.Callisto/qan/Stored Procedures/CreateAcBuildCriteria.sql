-- ====================================================================================================================================================
-- Author       : bricschx
-- Create date  : 2020-11-12 15:19:10.767
-- Description  : Creates a new auto checker build criteria. After execution, if the output parameter @Id is null, then the build criteria was not
--                created and @Message contains the reason. Do not alter and return result sets from this stored procedure. If you want result sets
--                to be returned, create a new stored procedure and call this.
-- Example      : DECLARE @Id BIGINT;
--                DECLARE @Message VARCHAR(500);
--                DECLARE @Conditions [qan].[IAcBuildCriteriaConditionsCreate];
--                INSERT INTO @Conditions ([Index], [AttributeTypeName], [ComparisonOperationKey], [Value]) VALUES (1, 'app_restriction', '=', 'TEST');
--                --an invalid attribute name or comparison operation key will not create a build criteria and return a message (error)
--                --INSERT INTO @Conditions ([Index], [AttributeTypeName], [ComparisonOperationKey], [Value]) VALUES (2, 'does_not_exist', '%', 'NA');
--                EXEC [qan].[CreateAcBuildCriteria] @Id OUTPUT, @Message OUTPUT, 'bricschx', 1, 2, 1, NULL, @Conditions;
--                --DELETE FROM [qan].[AcBuildCriteriaConditions] WHERE [BuildCriteriaId] = @Id;
--                --DELETE FROM [qan].[AcBuildCriterias] WHERE [Id] = @Id;
--                PRINT @Id;
--                PRINT @Message;
-- ====================================================================================================================================================
CREATE PROCEDURE [qan].[CreateAcBuildCriteria]
(
	  @Id                             BIGINT       OUTPUT
	, @Message                        VARCHAR(500) OUTPUT
	, @UserId                         VARCHAR(25)
	, @DesignId                       INT
	, @FabricationFacilityId          INT
	, @TestFlowId                     INT
	, @ProbeConversionId              INT
	, @Conditions                     [qan].[IAcBuildCriteriaConditionsCreate] READONLY
	, @Comment                        VARCHAR(1000) = NULL
	, @RestrictToExistingCombinations BIT = NULL
	, @StrictValidation               BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription          VARCHAR (1000) = 'Create';
	DECLARE @AttributeTypeName          VARCHAR (50);
	DECLARE @BuildCombinationId         INT = [qan].[AcBuildCombinationId](@DesignId, @FabricationFacilityId, @TestFlowId, @ProbeConversionId);
	DECLARE @CommentMaxCharacters       INT = 1000;
	DECLARE @Conditions2                TABLE
	(
		  [Index]                            INT NOT NULL
		, [AttributeTypeName]                VARCHAR (50)
		, [AttributeTypeId]                  INT
		, [AttributeDataTypeId]              INT
		, [ComparisonOperationId]            INT
		, [ComparisonOperationOperandTypeId] INT
		, [Value]                            VARCHAR (MAX)
	);
	DECLARE @Count                      INT;
	DECLARE @DesignFamilyId             INT;
	DECLARE @DesignIdValid              INT;
	DECLARE @DesignName                 VARCHAR(10);
	DECLARE @ErrorsExist                BIT = 0;
	DECLARE @FabricationFacilityIdValid INT;
	DECLARE @FabricationFacilityName    VARCHAR(50);
	DECLARE @On                         DATETIME2(7) = GETUTCDATE();
	DECLARE @ProbeConversionIdValid     INT;
	DECLARE @ProbeConversionName        VARCHAR(50);
	DECLARE @Succeeded                  BIT = 0;
	DECLARE @TestFlowIdValid            INT;
	DECLARE @TestFlowName               VARCHAR(50);
	DECLARE @Version                    INT;

	SET @Id = NULL;
	SET @Message = NULL;
	SET @ActionDescription = @ActionDescription + '; DesignId = ' + ISNULL(CAST(@DesignId AS VARCHAR(20)), 'null')
												+ '; FabricationFacilityId = ' + ISNULL(CAST(@FabricationFacilityId AS VARCHAR(20)), 'null')
												+ '; TestFlowId = ' + ISNULL(CAST(@TestFlowId AS VARCHAR(20)), 'null')
												+ '; ProbeConversionId = ' + ISNULL(CAST(@ProbeConversionId AS VARCHAR(20)), 'null');

	-- standardization
	SET @Comment = NULLIF(RTRIM(LTRIM(@Comment)), '');
	IF (@RestrictToExistingCombinations IS NULL) SET @RestrictToExistingCombinations = 1;
	IF (@StrictValidation IS NULL) SET @StrictValidation = 1;

	-- begin validation
	SELECT @DesignIdValid = MAX([Id]), @DesignFamilyId = MAX([DesignFamilyId]), @DesignName = MAX([Name]) FROM [qan].[Products] WITH (NOLOCK) WHERE [Id] = @DesignId;
	SELECT @FabricationFacilityIdValid = MAX([Id]), @FabricationFacilityName = MAX([Name]) FROM [qan].[FabricationFacilities] WITH (NOLOCK) WHERE [Id] = @FabricationFacilityId;
	SELECT @ProbeConversionIdValid = MAX([Id]), @ProbeConversionName = MAX([Name]) FROM [qan].[ProbeConversions] WITH (NOLOCK) WHERE [Id] = @ProbeConversionId;
	SELECT @TestFlowIdValid = MAX([Id]), @TestFlowName = MAX([Name]) FROM [qan].[TestFlows] WITH (NOLOCK) WHERE [Id] = @TestFlowId;

	IF (@DesignIdValid IS NULL)
	BEGIN
		SET @Message = 'Design does not exist: ' + ISNULL(CAST(@DesignId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (@DesignFamilyId IS NULL)
	BEGIN
		SET @Message = 'Design family could not be determined';
		SET @ErrorsExist = 1;
	END
	ELSE IF (@FabricationFacilityIdValid IS NULL)
	BEGIN
		SET @Message = 'Fabrication facility does not exist: ' + ISNULL(CAST(@FabricationFacilityId AS VARCHAR(20)), '');
		SET @ErrorsExist = 1;
	END
	ELSE IF (@DesignFamilyId = 1) -- NAND
	BEGIN
		SET @ProbeConversionId = NULL; -- unused for NAND
		IF (@TestFlowId IS NULL)
		BEGIN
			SET @Message = 'Test flow is required';
			SET @ErrorsExist = 1;
		END;
		ELSE
		BEGIN
			IF (@TestFlowIdValid IS NULL)
			BEGIN
				SET @Message = 'Test flow does not exist: ' + ISNULL(CAST(@TestFlowId AS VARCHAR(20)), '');
				SET @ErrorsExist = 1;
			END;
		END;
	END
	ELSE IF (@DesignFamilyId = 2) -- Optane
	BEGIN
		SET @TestFlowId = NULL; -- unused for Optane
		IF (@ProbeConversionId IS NULL)
		BEGIN
			SET @Message = 'Probe conversion is required';
			SET @ErrorsExist = 1;
		END;
		ELSE
		BEGIN
			IF (@ProbeConversionIdValid IS NULL)
			BEGIN
				SET @Message = 'Probe conversion does not exist: ' + ISNULL(CAST(@ProbeConversionId AS VARCHAR(20)), '');
				SET @ErrorsExist = 1;
			END;
		END;
	END
	ELSE IF (LEN(@Comment) > @CommentMaxCharacters)
	BEGIN
		SET @Message = 'Comments exceed maximum allowed characters: ' + CAST(@CommentMaxCharacters AS VARCHAR(20));
		SET @ErrorsExist = 1;
	END
	ELSE IF (@RestrictToExistingCombinations = 1 AND @BuildCombinationId IS NULL)
	BEGIN
		SET @Message = 'Invalid build combination';
		SET @ErrorsExist = 1;
	END;

	IF (@ErrorsExist = 0)
	BEGIN
		INSERT INTO @Conditions2
		(
			  [Index]
			, [AttributeTypeName]
			, [AttributeTypeId]
			, [AttributeDataTypeId]
			, [ComparisonOperationId]
			, [ComparisonOperationOperandTypeId]
			, [Value]
		)
		SELECT
			  C.[Index]                                   --[Index]
			, C.[AttributeTypeName]                       --[AttributeTypeName]
			, A.[Id]                                      --[AttributeTypeId]
			, A.[DataTypeId]                              --[AttributeDataTypeId]
			, O.[Id]                                      --[ComparisonOperationId]
			, OT.[Id]                                     --[ComparisonOperationOperandTypeId]
			, NULLIF(RTRIM(LTRIM(C.[Value])), '')         --[Value]
		FROM @Conditions AS C
		LEFT OUTER JOIN [qan].[AcAttributeTypes] AS A WITH (NOLOCK) ON (A.[Name] = C.[AttributeTypeName])
		LEFT OUTER JOIN [ref].[AcComparisonOperations] AS O WITH (NOLOCK) ON (O.[Key] = C.[ComparisonOperationKey])
		LEFT OUTER JOIN [ref].[AcOperandTypes] AS OT WITH (NOLOCK) ON (OT.[Id] = O.[OperandTypeId])
		LEFT OUTER JOIN [ref].[AcAttributeDataTypeOperations] AS DTO WITH (NOLOCK) ON (DTO.[AttributeDataTypeId] = A.[DataTypeId] AND DTO.[ComparisonOperationId] = O.[Id]);

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
			ELSE IF (@StrictValidation = 1) -- only perform the enclosed validation during strict validation (e.g. do it during user creation via web; skip when loading data from treadstone)
			BEGIN
				SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @Conditions2 GROUP BY [AttributeTypeId], [AttributeTypeName] HAVING COUNT(*) > 1;
				IF (@Count > 0)
				BEGIN
					SET @Message = 'Multiple conditions exist for the same attribute type: ' + ISNULL(@AttributeTypeName, '');
					SET @ErrorsExist = 1;
				END
				ELSE
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
	-- end validation

	IF (@ErrorsExist = 0)
	BEGIN
		BEGIN TRANSACTION

			IF (@BuildCombinationId IS NULL)
			BEGIN
				INSERT INTO [qan].[AcBuildCombinations]
				(
					  [Name]
					, [DesignId]
					, [FabricationFacilityId]
					, [TestFlowId]
					, [ProbeConversionId]
					, [CreatedBy]
					, [CreatedOn]
					, [UpdatedBy]
					, [UpdatedOn]
				)
				VALUES
				(
					  [qan].[FCreateAcBuildCombinationName](@DesignName, @FabricationFacilityName, @TestFlowName, @ProbeConversionName)
					, @DesignId
					, @FabricationFacilityId
					, @TestFlowId
					, @ProbeConversionId
					, @UserId
					, @On
					, @UserId
					, @On
				);

				SELECT @BuildCombinationId = SCOPE_IDENTITY();
			END;

			SET @ActionDescription = @ActionDescription + '; BuildCombinationId = ' + ISNULL(CAST(@BuildCombinationId AS VARCHAR(20)), 'null');

			SELECT @Version = (ISNULL(MAX([Version]), 0) + 1) FROM [qan].[AcBuildCriterias] WITH (NOLOCK) WHERE [BuildCombinationId] = @BuildCombinationId;

			INSERT INTO [qan].[AcBuildCriterias]
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
				, [DesignId]
				, [FabricationFacilityId]
				, [TestFlowId]
				, [ProbeConversionId]
			)
			VALUES
			(
				  @Version
				, 0 -- IsPOR = false
				, 1 -- IsActive = true
				, 1 -- Draft
				, @UserId
				, @On
				, @UserId
				, @On
				, @BuildCombinationId
				, @DesignId
				, @FabricationFacilityId
				, @TestFlowId
				, @ProbeConversionId
			);

			SELECT @Id = SCOPE_IDENTITY();

			INSERT INTO [qan].[AcBuildCriteriaConditions]
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
				  @Id
				, [AttributeTypeId]
				, [ComparisonOperationId]
				, [Value]
				, @UserId
				, @On
				, @UserId
				, @On
			FROM @Conditions2 ORDER BY [Index];

			SET @ActionDescription = @ActionDescription + '; Conditions: ' + CAST(@@ROWCOUNT AS VARCHAR(20));

			IF (@Comment IS NOT NULL)
			BEGIN
				INSERT INTO [qan].[AcBuildCriteriaComments]
				(
					  [BuildCriteriaId]
					, [Text]
					, [CreatedBy]
					, [CreatedOn]
					, [UpdatedBy]
					, [UpdatedOn]
				)
				VALUES
				(
					  @Id
					, @Comment
					, @UserId
					, @On
					, @UserId
					, @On
				);
				SET @ActionDescription = @ActionDescription + '; Comments: 1';
			END;

		COMMIT;

		SET @Succeeded = 1;
	END;

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'Auto Checker', 'Create', 'AcBuildCriteria', @Id, NULL, @Succeeded, @Message, 'AcBuildCombination', @BuildCombinationId;

END
