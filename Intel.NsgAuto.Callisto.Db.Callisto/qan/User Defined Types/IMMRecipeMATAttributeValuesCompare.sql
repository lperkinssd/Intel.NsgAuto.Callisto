-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-16 11:00:37.093
-- Description  : Type used for comparing MM Recipes' MAT attribute value records together.
-- ================================================================================================
CREATE TYPE [qan].[IMMRecipeMATAttributeValuesCompare] AS TABLE
(
	  [Id]                INT
	, [PCode]             VARCHAR(10) NOT NULL
	, [AssociatedItemId]  VARCHAR(21) NOT NULL
	, [AttributeTypeId]   INT NOT NULL
	, [Value]             VARCHAR(MAX)
	, [Operator]          VARCHAR(255)
	, [DataType]          VARCHAR(255)
	, INDEX [IX_PCode_AttributeTypeId] ([PCode], [AttributeTypeId])
);
