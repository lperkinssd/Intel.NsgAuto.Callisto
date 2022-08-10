-- ================================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-29 19:24:42.520
-- Description  : Gets OSAT PAS version import messages
-- Example      : SELECT * FROM [qan].[FOsatPasVersionImportMessages](NULL, 1, NULL, NULL, NULL);
-- ================================================================================================
CREATE FUNCTION [qan].[FOsatPasVersionImportMessages]
(
	  @Id            BIGINT       = NULL
	, @VersionId     INT          = NULL
	, @RecordId      BIGINT       = NULL
	, @RecordNumber  INT          = NULL
	, @MessageType   VARCHAR(20)  = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT
		  M.[Id]
		, M.[VersionId]
		, M.[RecordId]
		, M.[RecordNumber]
		, M.[MessageType]
		, M.[FieldName]
		, M.[Message]
	FROM [qan].[OsatPasVersionImportMessages] AS M WITH (NOLOCK)
	WHERE (@Id IS NULL OR M.[Id] = @Id)
	  AND (@VersionId IS NULL OR M.[VersionId] = @VersionId)
	  AND (@RecordId IS NULL OR M.[RecordId] = @RecordId)
	  AND (@RecordNumber IS NULL OR M.[RecordNumber] = @RecordNumber)
	  AND (@MessageType IS NULL OR M.[MessageType] = @MessageType)
)
