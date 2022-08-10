


-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseFabConvId]('')
-- SELECT [npsg].[OdmParseFabConvId](NULL)
-- SELECT [npsg].[OdmParseFabConvId]('NULL')
-- SELECT [npsg].[OdmParseFabConvId]('WAVE019')
-- SELECT [npsg].[OdmParseFabConvId]('N38A00 N A')
-- SELECT [npsg].[OdmParseFabConvId]('7.77/7.82/7.83')
-- SELECT [npsg].[OdmParseFabConvId]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [npsg].[OdmParseFabConvId]('>=121')
-- SELECT [npsg].[OdmParseFabConvId]('>=2019004')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseFabConvId]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Fab_Conv_Id ' + [npsg].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END