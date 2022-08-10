-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2020-10-15 16:14:31.513
-- Description  : Type used for comparing MM Recipes' product label attribute records together.
--                The comparison is based on PCode and AttributeTypeId so they are the primary key.
-- ================================================================================================
CREATE TYPE [qan].[IMMRecipeProductLabelAttributesCompare] AS TABLE
(
	  [PCode]            VARCHAR(10) NOT NULL
	, [AttributeTypeId]  INT NOT NULL
	, [Id]               BIGINT
	, [Value]            VARCHAR(500)
	, PRIMARY KEY ([PCode], [AttributeTypeId])
);
