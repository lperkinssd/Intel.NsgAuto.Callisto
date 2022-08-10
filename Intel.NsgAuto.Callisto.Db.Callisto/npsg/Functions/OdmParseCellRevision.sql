﻿

-- =============================================
-- Author:      jkurian
-- Create date: 2021-04-07 13:23:26.957
-- Description: return modified MAT attribute
-- SELECT [npsg].[OdmParseCellRevision]('')
-- SELECT [npsg].[OdmParseCellRevision](NULL)
-- SELECT [npsg].[OdmParseCellRevision]('NULL')
-- SELECT [npsg].[OdmParseCellRevision]('WAVE019')
-- SELECT [npsg].[OdmParseCellRevision]('N38A00 N A')
-- SELECT [npsg].[OdmParseCellRevision]('7.77/7.82/7.83')
-- SELECT [npsg].[OdmParseCellRevision]('PRB_06/PRB 06/PRB_08/PRB 08/PRB_10/PRB 10/PRB_14/PRB 14/PRB_15/PRB 15')
-- SELECT [npsg].[OdmParseCellRevision]('>=121')
-- SELECT [npsg].[OdmParseCellRevision]('>=2019004')
-- SELECT [npsg].[OdmParseCellRevision]('=2019004')
-- =============================================
CREATE FUNCTION [npsg].[OdmParseCellRevision]
(
		@AttributeValue VARCHAR(MAX) = NULL
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @SqlClause VARCHAR(MAX) = ' Cell_Revision ' + [npsg].[FParseMATAttributes](@AttributeValue);
	RETURN @SqlClause;

END