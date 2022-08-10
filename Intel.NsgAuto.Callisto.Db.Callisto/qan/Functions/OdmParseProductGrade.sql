

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[OdmParseProductGrade]('')
-- SELECT [qan].[OdmParseProductGrade](NULL)
-- SELECT [qan].[OdmParseProductGrade]('NULL')
-- SELECT [qan].[OdmParseProductGrade]('WAVE019')
-- SELECT [qan].[OdmParseProductGrade]('N38A00 N A')
-- SELECT [qan].[OdmParseProductGrade]('7.77/7.82/7.83')
-- SELECT [qan].[OdmParseProductGrade]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [qan].[OdmParseProductGrade]('>=121')
-- SELECT [qan].[OdmParseProductGrade]('>=2019004')
-- =============================================
CREATE FUNCTION [qan].[OdmParseProductGrade]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' product_grade ' + [qan].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END