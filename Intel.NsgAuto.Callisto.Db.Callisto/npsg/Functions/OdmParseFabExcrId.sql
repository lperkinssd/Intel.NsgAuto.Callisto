


-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseFabExcrId]('')
-- SELECT [npsg].[OdmParseFabExcrId](NULL)
-- SELECT [npsg].[OdmParseFabExcrId]('NULL')
-- SELECT [npsg].[OdmParseFabExcrId]('WAVE019')
-- SELECT [npsg].[OdmParseFabExcrId]('N38A00 N A')
-- SELECT [npsg].[OdmParseFabExcrId]('7.77/7.82/7.83')
-- SELECT [npsg].[OdmParseFabExcrId]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [npsg].[OdmParseFabExcrId]('>=121')
-- SELECT [npsg].[OdmParseFabExcrId]('>=2019004')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseFabExcrId]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Fab_Excr_Id ' + [npsg].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END