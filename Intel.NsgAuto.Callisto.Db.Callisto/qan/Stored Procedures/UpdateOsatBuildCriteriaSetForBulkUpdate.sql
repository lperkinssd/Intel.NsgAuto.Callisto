CREATE PROCEDURE [qan].[UpdateOsatBuildCriteriaSetForBulkUpdate]
	
(
	  @BuildCriteriaSetId                  BIGINT
	, @Message             VARCHAR(500) OUTPUT
	, @UserId              VARCHAR(25)
	, @BuildCombinationId  INT
	, @UpdatedConditions   [qan].[IOsatBuildCriteriaConditionsUpdate] READONLY
	, @Comment             VARCHAR(1000) = NULL
	, @StrictValidation    BIT           = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ActionDescription                   VARCHAR (1000) = 'Bulk Update';
	DECLARE @AttributeTypeName                   VARCHAR (50);
	DECLARE @BuildCombinationIdValid             INT;
	DECLARE @BuildCombinationIsActive            BIT;
	DECLARE @CommentMaxCharacters                INT = 1000;
	DECLARE @UpdatedConditions2                         TABLE
	(
		  [Id]									 INT NOT NULL
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
	DECLARE @On                                  DATETIME2(7) = GETUTCDATE();
	DECLARE @Succeeded                           BIT = 0;

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
		INSERT INTO @UpdatedConditions2
		(
			  [Id]
			, [AttributeTypeName]
			, [AttributeTypeId]
			, [AttributeDataTypeId]
			, [ComparisonOperationId]
			, [ComparisonOperationOperandTypeId]
			, [Value]
		)
		SELECT
			  C.[Id]                                    -- [Id]
			, C.[AttributeTypeName]                        -- [AttributeTypeName]
			, A.[Id]                                       -- [AttributeTypeId]
			, A.[DataTypeId]                               -- [AttributeDataTypeId]
			, O.[Id]                                       -- [ComparisonOperationId]
			, OT.[Id]                                      -- [ComparisonOperationOperandTypeId]
			, NULLIF(RTRIM(LTRIM(C.[Value])), '')          -- [Value]
		FROM @UpdatedConditions AS C
		LEFT OUTER JOIN [qan].[OsatAttributeTypes] AS A WITH (NOLOCK) ON (A.[Name] = C.[AttributeTypeName])
		LEFT OUTER JOIN [ref].[OsatComparisonOperations] AS O WITH (NOLOCK) ON (O.[Key] = C.[ComparisonOperationKey])
		LEFT OUTER JOIN [ref].[OsatOperandTypes] AS OT WITH (NOLOCK) ON (OT.[Id] = O.[OperandTypeId])
		LEFT OUTER JOIN [ref].[OsatAttributeDataTypeOperations] AS DTO WITH (NOLOCK) ON (DTO.[AttributeDataTypeId] = A.[DataTypeId] AND DTO.[ComparisonOperationId] = O.[Id]);



		SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @UpdatedConditions2 WHERE [AttributeTypeId] IS NULL;
		IF (@Count > 0)
		BEGIN
			SET @Message = 'The conditions contain an invalid attribute type name: ' + ISNULL(@AttributeTypeName, '');
			SET @ErrorsExist = 1;
		END
		ELSE
		BEGIN
			SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @UpdatedConditions2 WHERE [ComparisonOperationId] IS NULL;
			IF (@Count > 0)
			BEGIN
				SET @Message = 'The conditions contain an invalid comparison operation key for ' + ISNULL(@AttributeTypeName, '');
				SET @ErrorsExist = 1;
			END
			ELSE
			BEGIN
				IF (@StrictValidation = 1)
				BEGIN
					SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @UpdatedConditions2 WHERE [ComparisonOperationOperandTypeId] <> 3 AND CHARINDEX(',', [Value]) > 0;
					IF (@Count > 0)
					BEGIN
						SET @Message = 'The condition value contains a comma with an incompatible operation for ' + ISNULL(@AttributeTypeName, '');
						SET @ErrorsExist = 1;
					END
					ELSE
					BEGIN
						SELECT @Count = COUNT(*), @AttributeTypeName = MIN([AttributeTypeName]) FROM @UpdatedConditions2 AS C WHERE C.[AttributeDataTypeId] = 2 AND EXISTS(SELECT 1 FROM STRING_SPLIT(C.[Value], ',') WHERE ISNUMERIC([value]) = 0);
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


			-- cancel any existing versions in Draft, Submitted, or In Review status matching the build combination id
			UPDATE [qan].[OsatBuildCriteriaSets] SET
				  [StatusId] = 2 -- Canceled
				, [UpdatedBy] = @UserId
				, [UpdatedOn] = @On
			WHERE [StatusId] IN (1, 3, 5) -- Draft, Submitted, or In Review
			  AND [BuildCombinationId] = @BuildCombinationId
			  AND [Id] <> @BuildCriteriaSetId;


			UPDATE [qan].[OsatBuildCriteriaSets]
				  SET [IsActive]=1                                     -- [IsActive] = true
				, [StatusId]=1                                         -- [StatusId] = Draft
				, [UpdatedBy]=@UserId                                  -- [UpdatedBy]
				, [UpdatedOn]=@On                                      -- [UpdatedOn]
			WHERE [Id]= @BuildCriteriaSetId;

			UPDATE [qan].[OsatBuildCriteriaConditions]
			SET [Value]= C.[Value]                                     -- [Value]
				, [UpdatedBy]=@UserId                                  -- [UpdatedBy]
				, [UpdatedOn]=@On                                      -- [UpdatedOn]
				, [BulkUpdated]=1									   -- [BulkUpdated] = true
			FROM @UpdatedConditions2 AS C
			WHERE [qan].[OsatBuildCriteriaConditions].[Id]=C.[Id]
					AND [qan].[OsatBuildCriteriaConditions].[Value]<>C.[Value] COLLATE DATABASE_DEFAULT;


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
					  @BuildCriteriaSetId                                  -- [BuildCriteriaSetId]
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

	EXEC [qan].[CreateUserAction] NULL, @UserId, @ActionDescription, 'OSAT', 'Bulk Update', 'OsatBuildCriteriaSet', @BuildCriteriaSetId, NULL, @Succeeded, @Message, 'OsatBuildCombination', @BuildCombinationId;

END