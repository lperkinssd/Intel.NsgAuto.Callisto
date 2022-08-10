-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Create new Product Brand Name if the record does not exists, if exists return the ID
-- =============================================
CREATE PROCEDURE [qan].[CreateProductBrandName] 
	-- Add the parameters for the stored procedure here
	  @Id INT OUT
	, @Message VARCHAR(500) OUTPUT	
	, @Name VARCHAR(255)
	, @By VARCHAR(25)
	, @process VARCHAR(255)
	
AS
BEGIN
	
	SET NOCOUNT ON;

	WITH DATA as (SELECT @Name as Name, @process as Process,@By as data)
	   MERGE QAN.ProductBrandNames Target
	   USING data Source
		  on Source.Name =Target.Name and Source.Process = Target.Process		 
		WHEN not matched by target then 
			INSERT (Name,Process,IsActive,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn) values (@Name,@process,1,@By,GetUTCDATE(),@By,GetUTCDATE())
		WHEN MATCHED THEN
			UPDATE SET @Id = [TARGET].Id;
	
	IF @Id IS NULL
		BEGIN
			SET @Id = CAST(SCOPE_IDENTITY() as [int]);
			--IF (@Id =0) 
			--	BEGIN
			--		SET @Id=null;
			--	END
		END

--	Select @Id
    
END