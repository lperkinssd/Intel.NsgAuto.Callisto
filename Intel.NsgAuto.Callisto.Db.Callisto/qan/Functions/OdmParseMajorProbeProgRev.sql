﻿

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [qan].[OdmParseMajorProbeProgRev]('')
-- SELECT [qan].[OdmParseMajorProbeProgRev](NULL)
-- SELECT [qan].[OdmParseMajorProbeProgRev]('NULL')
-- SELECT [qan].[OdmParseMajorProbeProgRev]('WAVE019')
-- SELECT [qan].[OdmParseMajorProbeProgRev]('N38A00 N A')
-- SELECT [qan].[OdmParseMajorProbeProgRev]('7.77/7.82/7.83')
-- SELECT [qan].[OdmParseMajorProbeProgRev]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [qan].[OdmParseMajorProbeProgRev]('>=121')
-- SELECT [qan].[OdmParseMajorProbeProgRev]('>=2019004')
-- =============================================
CREATE FUNCTION [qan].[OdmParseMajorProbeProgRev]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Major_Probe_Program_Revision ' + [qan].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END