


-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[OdmParseFabConvId]('')
-- SELECT [qan].[OdmParseFabConvId](NULL)
-- SELECT [qan].[OdmParseFabConvId]('NULL')
-- SELECT [qan].[OdmParseFabConvId]('WAVE019')
-- SELECT [qan].[OdmParseFabConvId]('N38A00 N A')
-- SELECT [qan].[OdmParseFabConvId]('7.77/7.82/7.83')
-- SELECT [qan].[OdmParseFabConvId]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [qan].[OdmParseFabConvId]('>=121')
-- SELECT [qan].[OdmParseFabConvId]('>=2019004')
-- =============================================
CREATE FUNCTION [qan].[OdmParseFabConvId]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' fab_conv_id ' + [qan].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END