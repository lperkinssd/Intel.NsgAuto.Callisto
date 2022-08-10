

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[OdmParseCellRevision]('')
-- SELECT [qan].[OdmParseCellRevision](NULL)
-- SELECT [qan].[OdmParseCellRevision]('NULL')
-- SELECT [qan].[OdmParseCellRevision]('WAVE019')
-- SELECT [qan].[OdmParseCellRevision]('N38A00 N A')
-- SELECT [qan].[OdmParseCellRevision]('7.77/7.82/7.83')
-- SELECT [qan].[OdmParseCellRevision]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [qan].[OdmParseCellRevision]('>=121')
-- SELECT [qan].[OdmParseCellRevision]('>=2019004')
-- SELECT [qan].[OdmParseCellRevision]('=2019004')
-- =============================================
CREATE FUNCTION [qan].[OdmParseCellRevision]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Cell_Revision ' + [qan].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END