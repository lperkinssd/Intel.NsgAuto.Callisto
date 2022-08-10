-- ==============================================================================
-- Author       : bricschx
-- Create date  : 2020-10-12 13:58:33.270
-- Description  : Gets MAT attribute values
-- Example      : DECLARE @MATIds [qan].[IInts];
--                INSERT INTO @MATIds VALUES (1);
--                INSERT INTO @MATIds VALUES (2);
--                SELECT * FROM [qan].[FMATAttributeValues2](@MATIds);
-- ==============================================================================
CREATE FUNCTION [qan].[FMATAttributeValues2]
(
	@MATIds [qan].[IInts] READONLY
)
RETURNS TABLE AS RETURN
(
	SELECT * FROM [qan].[FMATAttributeValues](NULL, NULL, NULL) WHERE [MATId] IN (SELECT [Value] FROM @MATIds)
)
