

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('')
-- SELECT [npsg].[OdmParseMajorProbeProgRev](NULL)
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('NULL')
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('WAVE019')
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('N38A00 N A')
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('7.77/7.82/7.83')
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('>=121')
-- SELECT [npsg].[OdmParseMajorProbeProgRev]('>=2019004')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseMajorProbeProgRev]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Major_Probe_Program_Revision ' + [npsg].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END