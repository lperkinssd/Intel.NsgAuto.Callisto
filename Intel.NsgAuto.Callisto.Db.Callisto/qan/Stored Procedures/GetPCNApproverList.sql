


-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get all Product Ownership Lookup Data
-- =============================================
CREATE PROCEDURE [qan].[GetPCNApproverList] 
(
	  @UserId VARCHAR(25),
	  @ProductCodeNameId INT,
	  @AccountCustomerId INT,
	  --@ProductCodeName VARCHAR(255),
	  --@AccountCustomerName VARCHAR(255),
	  @IsActive bit =1
	  
)
AS
BEGIN

	 DECLARE @Process Varchar(MAX);
	 SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                  INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
	
 SELECT 
	 distinct  PC.Name as RoleName, PR.Name as ContactName, LTRIM(RTRIM(PC.Email)) as Email
	 FROM qan.ProductOwnerships PO  (NOLOCK)
		INNER JOIN QAN.ProductOwnershipsContacts (NOLOCK) PCC on PO.ID = PCC.OwnershipId
		INNER JOIN QAN.ProductContactRoles (NOLOCK) PCR on PCR.Id = PCC.ContactRoleId
		INNER JOIN QAN.ProductContacts (NOLOCK) PC on PC.ID = PCR.ContactId
		INNER JOIN ref.ProductRoles (NOLOCK) PR on PR.Id = PCR.RoleId  and PR.PCN = 1 and PR.Name Not Like '%Manager%' and Process=@Process
	WHERE  PR.IsActive = @IsActive and PCR.IsActive = @IsActive and PC.IsActive = @IsActive and PO.CodeNameId = @ProductCodeNameId and PCC.Id is not null and PCC.IsActive = 1
	
	UNION

	SELECT 		
		AC.Name as ContactName, 	
		AR.Name as RoleName, LTRIM(RTRIM(AC.Email)) as Email
	 FROM qan.AccountOwnerships AO  (NOLOCK)
		INNER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId
		INNER JOIN QAN.AccountContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		INNER JOIN QAN.AccountContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		INNER JOIN ref.AccountRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AR.PCN = 1  and AR.Name Not Like '%Manager%' and Process=@Process
	WHERE ACC.Id IS NOT NULL and ac.Name IS NOT NULL and AR.IsActive = @IsActive and ACR.IsActive = @IsActive and AC.IsActive = @IsActive and AO.AccountCustomerId =@AccountCustomerId and ACC.IsActive = 1
	 
END