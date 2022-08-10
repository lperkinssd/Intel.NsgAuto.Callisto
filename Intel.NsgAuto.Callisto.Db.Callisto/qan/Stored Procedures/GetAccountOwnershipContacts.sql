



-- ===============================================================================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get Product Ownership Lookups Data and Product Ownership data
-- ================================================================================================
CREATE PROCEDURE [qan].[GetAccountOwnershipContacts] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(25)
	 
)
AS
BEGIN
     
	 SELECT 
		ACC.Id  as AccountOwnershipsContactId,
		AO.ID as AccountOwnershipId,
		AC.Name as AccountName, 
		AC.WWID, 
		AC.idSid, 
		AC.Email,
		AC.AlternateEmail,
		AR.Name as RoleName
	 FROM qan.AccountOwnerships AO  (NOLOCK)
		LEFT OUTER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId
		LEFT OUTER JOIN QAN.AccountContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.AccountContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.AccountRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.AccountProcess = AR.Process 
	WHERE AO.AccountProcess = @process and ACC.Id IS NOT NULL and ac.Name IS NOT NULL AND ACC.IsActive = 1
	 
	 
	 


END