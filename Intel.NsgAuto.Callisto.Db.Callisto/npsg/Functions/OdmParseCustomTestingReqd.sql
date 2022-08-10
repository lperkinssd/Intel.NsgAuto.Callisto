


-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseCustomTestingReqd]('')
-- SELECT [npsg].[OdmParseCustomTestingReqd](NULL)
-- SELECT [npsg].[OdmParseCustomTestingReqd]('NULL')
-- SELECT [npsg].[OdmParseCustomTestingReqd]('WAVE019')
-- SELECT [npsg].[OdmParseCustomTestingReqd]('N38A00 N A')
-- SELECT [npsg].[OdmParseCustomTestingReqd]('7.77/7.82/7.83')
-- SELECT [npsg].[OdmParseCustomTestingReqd]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [npsg].[OdmParseCustomTestingReqd]('>=121')
-- SELECT [npsg].[OdmParseCustomTestingReqd]('>=2019004')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseCustomTestingReqd]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Custom_Testing_Required ' + [npsg].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END