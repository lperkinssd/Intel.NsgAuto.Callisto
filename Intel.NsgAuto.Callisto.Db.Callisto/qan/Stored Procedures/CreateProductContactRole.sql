
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [qan].[CreateProductContactRole] 
	-- Add the parameters for the stored procedure here	    
		@ContactId INT OUTPUT,
		@ContactName VARCHAR(255),
		@RoleName VARCHAR(255),
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


	--select @Id = ID from ref.ProductContacts where Name=@ContactName
	EXECUTE [qan].[CreateProductContact] @Id OUTPUT ,@ContactName,@WWID,@idSid,@Email, @By

	SELECT @RoleId = Id FROM  ref.ProductRoles (NOLOCK) WHERE Name=@RoleName

	;WITH DATA as (Select @RoleId as RoleId, @Id as Id)
	   MERGE qan.ProductContactRoles Target
	   USING data Source
		  on Source.RoleId =Target.RoleId and Source.Id = Target.ContactId		 
		WHEN not matched by target THEN 
			INSERT (RoleId,ContactId,IsActive,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn) values (@RoleId,@Id,1,@By,GetUTCDATE(),@By,GetUTCDATE())
		WHEN MATCHED THEN
			UPDATE SET @ContactId = [TARGET].Id;
	
	IF @ContactId IS NULL
		BEGIN
			SET @ContactId = CAST(SCOPE_IDENTITY() as [int]);
	    END

    
END