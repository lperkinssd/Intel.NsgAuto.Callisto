


-- =============================================================
-- Author		: jakemurx
-- Create date	: 2020-09-09 13:39:05.807
-- Description	: Creates a new MAT Attribute
-- =============================================================
CREATE PROCEDURE [npsg].[CreateMATAttribute]
(
	    @MATId int
	  , @Name varchar(255)
	  , @Value varchar(max)
	  , @UserId varchar(25)
	  , @On datetime2(7)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @On IS NULL SET @On = getutcdate();

	DECLARE @MATAttributeId int
	SELECT @MATAttributeId = (SELECT [Id] FROM [ref].[MATAttributeTypes] WHERE LTRIM(RTRIM([Name])) = @Name)
	EXEC [npsg].[CreateMATAttributeValues] @MATId, @MATAttributeId, @Value, @UserId, @On

END