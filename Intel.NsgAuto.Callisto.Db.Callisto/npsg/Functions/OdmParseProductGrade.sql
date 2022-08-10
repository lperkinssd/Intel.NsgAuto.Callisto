

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseProductGrade]('')
-- SELECT [npsg].[OdmParseProductGrade](NULL)
-- SELECT [npsg].[OdmParseProductGrade]('NULL')
-- SELECT [npsg].[OdmParseProductGrade]('WAVE019')
-- SELECT [npsg].[OdmParseProductGrade]('N38A00 N A')
-- SELECT [npsg].[OdmParseProductGrade]('7.77/7.82/7.83')
-- SELECT [npsg].[OdmParseProductGrade]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [npsg].[OdmParseProductGrade]('>=121')
-- SELECT [npsg].[OdmParseProductGrade]('>=2019004')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseProductGrade]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Product_Grade ' + [npsg].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END