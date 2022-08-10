

-- ====================================================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Create new Product Contact when user does not exists
-- =====================================================================

CREATE PROCEDURE [qan].[CreateProductContact] 
	-- Add the parameters for the stored procedure here	    
		@ContactId int OUTPUT,
		@ContactName VARCHAR(255),	
		@WWID VARCHAR(20),
		@idSid VARCHAR(15),
		@Email VARCHAR(255),
		@By VARCHAR(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @RoleId int
	DECLARE @Id int

	SELECT @Id = Id FROM QAN.ProductContacts WHERE Name=@ContactName
	

	;WITH DATA as (Select @WWID as WWID)
	   MERGE QAN.ProductContacts Target
	   USING data Source
		  on Source.WWID = Target.WWID		 
		WHEN NOT MATCHED by target THEN 
			INSERT (Name,WWID, idSid, Email,IsActive,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn) values (@ContactName,@WWID, @idSid, @Email,1,@By,GetUTCDATE(),@By,GetUTCDATE())
		WHEN MATCHED THEN
			UPDATE SET @ContactId = [TARGET].Id;
	
	IF @ContactId IS NULL
		BEGIN
			SET @ContactId = CAST(SCOPE_IDENTITY() as [int]);
	    END

    
END