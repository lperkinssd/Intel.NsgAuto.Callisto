



-- =============================================================
-- Author		: jakemurx
-- Create date	: 2020-08-28 09:48:54.320
-- Description	: Gets MAT attributes filtering on Id
--					EXEC [qan].[GetMATAttributes] 'jakemurx', null, null, null
-- =============================================================
CREATE PROCEDURE [qan].[GetMATAttributes]
(
	    @UserId varchar(25)
	  , @Id int
	  , @MATId int
	  , @MATVersionId int
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT v.[Id]
		  ,v.[MATId]
		  ,LTRIM(RTRIM(t.[Name])) AS [Name]
		  ,LTRIM(RTRIM(t.[NameDisplay])) AS [NameDisplay]
		  ,v.[AttributeTypeId]
		  ,LTRIM(RTRIM(v.[Value])) AS [Value]
		  ,LTRIM(RTRIM(v.[Operator])) AS [Operator]
		  ,LTRIM(RTRIM(v.[DataType])) AS [DataType]
		  ,LTRIM(RTRIM(v.[CreatedBy])) AS [CreatedBy]
		  ,v.[CreatedOn]
		  ,LTRIM(RTRIM(v.[UpdatedBy])) AS [UpdatedBy]
		  ,v.[UpdatedOn]
	  FROM [qan].[MATAttributeValues] v WITH (NOLOCK)
	  INNER JOIN [ref].[MATAttributeTypes] t WITH (NOLOCK)
	  ON t.[Id] = v.[AttributeTypeId]
	WHERE (@Id IS NULL OR t.[Id] = @Id)
	  AND (@MATId IS NULL OR [MATId] = @MATId)
	  AND (@MATVersionId IS NULL OR [MATId] IN (SELECT [Id] FROM [MATs] WITH (NOLOCK) WHERE [MATVersionId] = @MATVersionId))

END