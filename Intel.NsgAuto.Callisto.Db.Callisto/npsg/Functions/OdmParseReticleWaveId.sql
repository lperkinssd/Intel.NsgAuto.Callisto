

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseReticleWaveId]('')
-- SELECT [npsg].[OdmParseReticleWaveId](NULL)
-- SELECT [npsg].[OdmParseReticleWaveId]('NULL')
-- SELECT [npsg].[OdmParseReticleWaveId]('WAVE019')
-- SELECT [npsg].[OdmParseReticleWaveId]('N38A00 N A')
-- SELECT [npsg].[OdmParseReticleWaveId]('7.77/7.82/7.83')
-- SELECT [npsg].[OdmParseReticleWaveId]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [npsg].[OdmParseReticleWaveId]('>=121')
-- SELECT [npsg].[OdmParseReticleWaveId]('>=2019004')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseReticleWaveId]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Reticle_Wave_Id ' + [npsg].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END