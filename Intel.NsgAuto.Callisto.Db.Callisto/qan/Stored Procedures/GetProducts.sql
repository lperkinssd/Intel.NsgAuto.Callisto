
-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-08-12 11:35:08.103
-- Description  : Gets products
-- Examples     : EXEC [qan].[GetProducts] 'bricschx', 1
--                EXEC [qan].[GetProducts] 'jkurian'
-- =============================================================
CREATE PROCEDURE [qan].[GetProducts]
(
	  @UserId  VARCHAR(25)
	, @Id      INT         = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Return design ids for the user for the process that he has access to
	SELECT * FROM [qan].[FProducts](@Id, @UserId, NULL, NULL, NULL, NULL)
	ORDER BY [Name];

END