
-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get all Product Ownership Lookup Data
-- =============================================
CREATE PROCEDURE [qan].[GetProductOwnershipLookups] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(255),
	  @IsActive BIT = 1
)
AS
BEGIN
	 
	 SELECT * FROM  ref.ProductTypes WHERE IsActive = @IsActive and Process=@process

	 	
	 SELECT * FROM  ref.ProductPlatforms WHERE IsActive = @IsActive and Process=@process

	 	 
	 SELECT * FROM  qan.ProductCodeNames WHERE IsActive = @IsActive and Process=@process

	 	 
	 SELECT * FROM  qan.ProductBrandNames WHERE IsActive = @IsActive and Process=@process

	 	 
	 SELECT * FROM  ref.ProductLifeCycleStatuses WHERE IsActive = @IsActive and Process=@process

	 SELECT * FROM qan.ProductContacts WHERE IsActive = @IsActive

	 SELECT * FROM ref.ProductRoles WHERE IsActive = @IsActive  and Process=@process

	 

	 --SELECT PCR.ID as ContactId,PC.NAME as ContactName, PR.NAME as RoleName,PC.Email as Email, PC.WWID, PC.idSid FROM qan.ProductContactRoles PCR 
		--		 INNER JOIN ref.PRODUCTROLES PR ON PR.ID = PCR.RoleId
		--		 INNER JOIN QAN.PRODUCTCONTACTS PC ON PC.ID = PCR.ContactId
		--		 WHERE PCR.ISActive = @IsActive  and PR.IsActive =@IsActive and PC.IsActive = @IsActive


END