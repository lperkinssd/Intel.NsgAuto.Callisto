-- =============================================================
-- Author		: bricschx
-- Create date	: 2020-08-28 09:27:38.347
-- Description	: Creates a new product label attribute
-- =============================================================
CREATE PROCEDURE [qan].[CreateProductLabelAttribute]
(
	  @Id BIGINT OUTPUT
	, @ProductLabelId BIGINT
	, @Name VARCHAR(50)
	, @Value VARCHAR(128)
	, @UserId VARCHAR(25)
	, @On DATETIME2(7)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @On IS NULL SET @On = getutcdate();

	INSERT INTO [qan].[ProductLabelAttributes]
	(
		  [ProductLabelId]
		, [AttributeTypeId]
		, [Value]
		, [CreatedBy]
		, [CreatedOn]
		, [UpdatedBy]
		, [UpdatedOn]
	)
	VALUES
	(
		  @ProductLabelId
		, [ref].[GetProductLabelAttributeTypeIdByName](@Name)
		, @Value
		, @UserId
		, @On
		, @UserId
		, @On
	);

	SELECT @Id = SCOPE_IDENTITY();

END
