



-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[OdmParseCustomTestingReqd]('')
-- SELECT [qan].[OdmParseCustomTestingReqd](NULL)
-- SELECT [qan].[OdmParseCustomTestingReqd]('NULL')
-- SELECT [qan].[OdmParseCustomTestingReqd]('WAVE019')
-- SELECT [qan].[OdmParseCustomTestingReqd]('N38A00 N A')
-- SELECT [qan].[OdmParseCustomTestingReqd]('7.77/7.82/7.83')
-- SELECT [qan].[OdmParseCustomTestingReqd]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [qan].[OdmParseCustomTestingReqd]('>=121')
-- SELECT [qan].[OdmParseCustomTestingReqd]('>=2019004')
-- =============================================
CREATE FUNCTION [qan].[OdmParseCustomTestingReqd]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' ISNULL(Custom_Testing_Required, ''NULL'') ' + [qan].[FParseMATCTRAttributes](@AttributeValue);
	RETURN @SqlClause;

END