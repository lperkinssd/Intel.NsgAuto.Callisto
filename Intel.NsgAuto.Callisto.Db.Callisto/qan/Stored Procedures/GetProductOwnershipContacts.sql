




-- ===============================================================================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get Product Ownership Lookups Data and Product Ownership data
-- ================================================================================================
CREATE PROCEDURE [qan].[GetProductOwnershipContacts] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(25),
	  @IsActive bit = 1
	  
	 
)
AS
BEGIN
      
	 --SELECT 
		--PO.ID as ContactId,
		--AC.Name as ContactName, 
		--AC.WWID, 
		--AC.idSid, 
		--AC.Email,
		--AR.Name as RoleName
	 --FROM qan.ProductOwnerships PO  (NOLOCK)		
		--LEFT OUTER JOIN QAN.productcontactroles (NOLOCK) ACR on ACR.Id In (PO.PDTId, PO.PQEId, PO.PMEId, PO.PMTId,PO.TMEId,PO.OTHERSId,PO.PMEManagerId,PO.PMEManagerBackupId,PO.PMTManagerId,PO.PMTManagerBackupId)
		--LEFT OUTER JOIN QAN.productcontacts (NOLOCK) AC on AC.ID = ACR.ContactId
		--LEFT OUTER JOIN ref.productroles (NOLOCK) AR on AR.Id = ACR.RoleId 
		--where AR.IsActive = @IsActive and ACR.IsActive = @IsActive and AC.IsActive = @IsActive AND PO.ProductClassification = @process


		 SELECT 
		ACC.Id  as ContactId,
		AO.ID as ProductOwnershipId,
		AC.Name as ContactName, 
		AC.WWID, 
		AC.idSid, 
		AC.Email,
		AC.AlternateEmail,
		AR.Name as RoleName
	 FROM qan.ProductOwnerships AO  (NOLOCK)
		LEFT OUTER JOIN QAN.ProductOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId
		LEFT OUTER JOIN QAN.ProductContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.ProductContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.ProductRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.ProductClassification = AR.Process 
	WHERE AO.ProductClassification = @process and ACC.Id IS NOT NULL and ac.Name IS NOT NULL AND ACC.IsActive = 1
	
	 
	 
	 


END