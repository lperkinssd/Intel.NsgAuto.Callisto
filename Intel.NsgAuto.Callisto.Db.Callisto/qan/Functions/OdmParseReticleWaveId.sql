

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[OdmParseReticleWaveId]('')
-- SELECT [qan].[OdmParseReticleWaveId](NULL)
-- SELECT [qan].[OdmParseReticleWaveId]('NULL')
-- SELECT [qan].[OdmParseReticleWaveId]('WAVE019')
-- SELECT [qan].[OdmParseReticleWaveId]('N38A00 N A')
-- SELECT [qan].[OdmParseReticleWaveId]('7.77/7.82/7.83')
-- SELECT [qan].[OdmParseReticleWaveId]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [qan].[OdmParseReticleWaveId]('>=121')
-- SELECT [qan].[OdmParseReticleWaveId]('>=2019004')
-- =============================================
CREATE FUNCTION [qan].[OdmParseReticleWaveId]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' reticle_wave_id ' + [qan].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END