-- ===============================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-30 13:50:11.377
-- Description  : Determines the design name from the osat qual filter design_id attribute value and group name
-- Examples     : SELECT [qan].[FOsatQfDesignIdAvAndGroupNameToDesignName]('S26A', 'S26A PG1ES');
--                SELECT [qan].[FOsatQfDesignIdAvAndGroupNameToDesignName](NULL, 'S26A PG1ES');
-- ===============================================================================================================
CREATE FUNCTION [qan].[FOsatQfDesignIdAvAndGroupNameToDesignName]
(
	  @DesignIdAttributeValue  VARCHAR(4000)
	, @GroupName               VARCHAR(4000)
)
RETURNS VARCHAR(10)
AS
BEGIN
	SET @DesignIdAttributeValue = NULLIF(LTRIM(RTRIM(@DesignIdAttributeValue)), '');
	SET @GroupName              = NULLIF(LTRIM(RTRIM(@GroupName)), '');
	DECLARE @Result VARCHAR(10) =
		CASE WHEN @DesignIdAttributeValue IS NOT NULL THEN @DesignIdAttributeValue
		ELSE
			CASE WHEN LEN(@GroupName) >= 4 THEN LEFT(@GroupName, 4)
			ELSE NULL
			END
		END;
	RETURN (@Result);
END