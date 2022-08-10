

-- =============================================
-- Author:		jakemurx
-- Create date: now
-- Description:	Create MAT Attribute value entries
--              EXEC [npsg].[CreateMATAttributeValues] 1, 2, '7.77/7.82/7.83', 'jakemurx', '2020-09-28 23:42:18.5866667'
--SET @Value = '7.77/7.82/7.83' -- Cell_Revision, Custom_Testing_Reqd, Product_Grade, Prb_Conv_Id, Fab_Excr_Id, Fab_Conv_Id, Reticle_Wave_Id, Fab_Facility
--SET @Value = 'EXCR000/EXCR125/EXCR127/EXCR134/EXCR136/EXCR137/EXCR140'
--SET @Value = '>=9.4' -- Cell_Revision, Major_Probe_Program_Revision, Probe_Revision, Burn_Tape_Revision
--SET @Value = '>9.4'
--SET @Value = '<=9.4'
--SET @Value = '<9.4'
--SET @Value = 'PREMIUM' --Custom_Testing_Reqd, Product_Grade, Fab_Conv_Id, Reticle_Wave_Id, Fab_Facility
-- =============================================
CREATE PROCEDURE [npsg].[CreateMATAttributeValues] 
	-- Add the parameters for the stored procedure here
	@MATId int,
	@AttributeTypeId int,
	@Value varchar(max),
	@UserId varchar(25),
	@On datetime2(7)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @Gt varchar(2);
	SET @Gt = '>'

	DECLARE @GtEq varchar(2);
	SET @GtEq = '>='

	DECLARE @Lt varchar(2);
	SET @Lt = '<'

	DECLARE @LtEq varchar(2);
	SET @LtEq = '<='

	DECLARE @Eq varchar(1);
	SET @Eq = '='

	DECLARE @Slash varchar(1);
	SET @Slash = '/';

	DECLARE @Operator varchar(255)

	DECLARE @Attributes TABLE
	(
		[Value] varchar(max),
		[Operator] varchar(255) null,
		[DataType] varchar(255)
	)

	DECLARE @AttributeValue varchar(max)
	DECLARE @DataType varchar(255)

	IF (SELECT CHARINDEX(@Slash, @Value)) > 0
	BEGIN
		SET @Operator = 'OR'
		INSERT INTO @Attributes([Value])
		SELECT value FROM STRING_SPLIT(@Value, @Slash)
		
		SELECT @AttributeValue = (SELECT TOP 1 [Value] FROM @Attributes)
		SET @DataType = [npsg].[GetMATDataTypeFromValue](@AttributeValue)

		UPDATE @Attributes 
		SET [Operator] = @Operator,
			[DataType] = @DataType
	END
	ELSE IF (SELECT CHARINDEX(@GtEq, @Value)) > 0
	BEGIN
		SET @Operator = @GtEq
		INSERT INTO @Attributes([Value])
		SELECT SUBSTRING(@Value, 3, LEN(@Value) - 2)
		--SELECT value FROM STRING_SPLIT(@Value, @GtEq)

		SELECT @AttributeValue = (SELECT TOP 1 [Value] FROM @Attributes)
		SET @DataType = [npsg].[GetMATDataTypeFromValue](@AttributeValue)

		UPDATE @Attributes 
		SET [Operator] = @Operator,
			[DataType] = @DataType
	END
	ELSE IF (SELECT CHARINDEX(@Gt, @Value)) > 0
	BEGIN
		SET @Operator = @Gt
		INSERT INTO @Attributes([Value])
		SELECT value FROM STRING_SPLIT(@Value, @Gt)

		SELECT @AttributeValue = (SELECT TOP 1 [Value] FROM @Attributes)
		SET @DataType = [npsg].[GetMATDataTypeFromValue](@AttributeValue)

		UPDATE @Attributes 
		SET [Operator] = @Operator,
			[DataType] = @DataType
	END
	ELSE IF (SELECT CHARINDEX(@LtEq, @Value)) > 0
	BEGIN
		SET @Operator = @LtEq
		INSERT INTO @Attributes([Value])
		SELECT SUBSTRING(@Value, 3, LEN(@Value) - 2)
		--SELECT value FROM STRING_SPLIT(@Value, @LtEq)

		SELECT @AttributeValue = (SELECT TOP 1 [Value] FROM @Attributes)
		SET @DataType = [npsg].[GetMATDataTypeFromValue](@AttributeValue)

		UPDATE @Attributes 
		SET [Operator] = @Operator,
			[DataType] = @DataType
	END
	ELSE IF (SELECT CHARINDEX(@Lt, @Value)) > 0
	BEGIN
		SET @Operator = @Lt
		INSERT INTO @Attributes([Value])
		SELECT value FROM STRING_SPLIT(@Value, @Lt)

		SELECT @AttributeValue = (SELECT TOP 1 [Value] FROM @Attributes)
		SET @DataType = [npsg].[GetMATDataTypeFromValue](@AttributeValue)

		UPDATE @Attributes 
		SET [Operator] = @Operator,
			[DataType] = @DataType
	END
	ELSE
	BEGIN
		SET @Operator = @Eq
		INSERT INTO @Attributes([Value])
		SELECT @Value

		SELECT @AttributeValue = (SELECT TOP 1 [Value] FROM @Attributes)
		SET @DataType = [npsg].[GetMATDataTypeFromValue](@AttributeValue)

		UPDATE @Attributes 
		SET [Operator] = @Operator,
			[DataType] = @DataType
	END
	
	INSERT INTO [npsg].[MATAttributeValues]
	(
		 [MATId]
		,[AttributeTypeId]
		,[Value]
		,[Operator]
		,[DataType]
		,[CreatedBy]
		,[CreatedOn]
		,[UpdatedBy]
		,[UpdatedOn]
	)	
	SELECT 
		 @MATId
		,@AttributeTypeId
		,LTRIM(RTRIM([Value]))
		,LTRIM(RTRIM([Operator]))
		,LTRIM(RTRIM([DataType]))
		,@UserId
		,@On
		,@UserId
		,@On
	FROM @Attributes
END