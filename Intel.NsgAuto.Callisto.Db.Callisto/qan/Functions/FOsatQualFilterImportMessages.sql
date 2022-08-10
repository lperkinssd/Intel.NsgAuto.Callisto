-- ==============================================================================================================================
-- Author       : bricschx
-- Create date  : 2021-06-28 18:38:04.953
-- Description  : Gets osat qual filter import messages
-- Example      : SELECT * FROM [qan].[FOsatQualFilterImportMessages](NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- ==============================================================================================================================
CREATE FUNCTION [qan].[FOsatQualFilterImportMessages]
(
	  @Id                    BIGINT       = NULL
	, @ImportId              INT          = NULL
	, @MessageType           VARCHAR(20)  = NULL
	, @GroupIndex            INT          = NULL
	, @GroupSourceIndex      INT          = NULL
	, @CriteriaIndex         INT          = NULL
	, @CriteriaSourceIndex   INT          = NULL
	, @GroupFieldIndex       INT          = NULL
	, @GroupFieldSourceIndex INT          = NULL
	, @GroupFieldName        VARCHAR(100) = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  M.[Id]
		, M.[ImportId]
		, M.[MessageType]
		, M.[Message]
		, M.[GroupIndex]
		, M.[GroupSourceIndex]
		, M.[CriteriaIndex]
		, M.[CriteriaSourceIndex]
		, M.[GroupFieldIndex]
		, M.[GroupFieldSourceIndex]
		, M.[GroupFieldName]
	FROM [qan].[OsatQualFilterImportMessages] AS M WITH (NOLOCK)
	WHERE (@Id                    IS NULL OR M.[Id] = @Id)
	  AND (@ImportId              IS NULL OR M.[ImportId] = @ImportId)
	  AND (@MessageType           IS NULL OR M.[MessageType] = @MessageType)
	  AND (@GroupIndex            IS NULL OR M.[GroupIndex] = @GroupIndex)
	  AND (@GroupSourceIndex      IS NULL OR M.[GroupSourceIndex] = @GroupSourceIndex)
	  AND (@CriteriaIndex         IS NULL OR M.[CriteriaIndex] = @CriteriaIndex)
	  AND (@CriteriaSourceIndex   IS NULL OR M.[CriteriaSourceIndex] = @CriteriaSourceIndex)
	  AND (@GroupFieldIndex       IS NULL OR M.[GroupFieldIndex] = @GroupFieldIndex)
	  AND (@GroupFieldSourceIndex IS NULL OR M.[GroupFieldSourceIndex] = @GroupFieldSourceIndex)
	  AND (@GroupFieldName        IS NULL OR M.[GroupFieldName] = @GroupFieldName)
)
