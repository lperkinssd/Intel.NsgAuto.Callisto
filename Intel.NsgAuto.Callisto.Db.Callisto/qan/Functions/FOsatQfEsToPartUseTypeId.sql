-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 14:16:15.610
-- Description  : Returns the part use type id from an osat qual filter es value
-- Example      : SELECT [qan].[FOsatQfEsToPartUseTypeId]('N'); -- 1
--                SELECT [qan].[FOsatQfEsToPartUseTypeId]('Y'); -- 2
-- =================================================================================
CREATE FUNCTION [qan].[FOsatQfEsToPartUseTypeId]
(
	  @Es VARCHAR(4000)
)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT =
		CASE UPPER(LTRIM(RTRIM(@Es)))
			WHEN 'N' THEN 1
			WHEN 'Y' THEN 2
			ELSE NULL
		END;
	RETURN (@Result);
END