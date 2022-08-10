
-- ===============================================================================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get Product Ownership Data
-- ===============================================================================================
CREATE PROCEDURE [qan].[GetAccountOwnerships] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(25)
)
AS
BEGIN

	SELECT  AO.ID as Id,
	ACL.ID AccountClientId,
	ACL.Name AccountClientName,
	AC.ID as AccountCustomerId,
	AC.NAME as AccountCustomerName,
	ASY.ID as AccountSubsidiaryId,
	ASY.Name as AccountSubsidiaryName,
	AP.ID as AccountProductId,
	AP.Name as AccountProductName,
	AO.AccountProcess,
	NAMES.PCN as PCNName,	
	NAMES.AE as AEName,
	NAMES.AEManager as AEManagerName,	
	NAMES.AEManagerBackup as AEManagerBackupName,
	NAMES.CME as CMEName,	
	NAMES.CQE as CQEName,	
	NAMES.CQEManager as CQEManagerName,	
	NAMES.CQEManagerBackup as CQEManagerBackupName,
	NAMES.Others as OthersName,	
	NAMES.FAE as FAEName,	
	NAMES.FSE as FSEName,	
	 CASE WHEN ISNULL(Emails.Email,'') != '' AND ISNULL(AlternateEmail.Email,'') != '' THEN Emails.Email + ';' + AlternateEmail.Email
	         WHEN ISNULL(Emails.Email,'') != '' AND ISNULL(AlternateEmail.Email,'') = '' THEN Emails.Email 
			 WHEN ISNULL(Emails.Email,'') = '' AND ISNULL(AlternateEmail.Email,'') != '' THEN AlternateEmail.Email 
			 Else Null END AS Email,
	AO.IsActive,	
	AO.Notes as Notes,
	AO.CreatedBy,
	AO.CreatedOn,
	AO.UpdatedBy,
	AO.UpdatedOn
  FROM [Callisto].[qan].[AccountOwnerships] AO (NOLOCK)
  LEFT OUTER JOIN [ref].[AccountClients] (NOLOCK) ACL ON AO.AccountClientId =ACL.ID    

  LEFT OUTER JOIN  ref.AccountCustomers (NOLOCK) AC ON AC.Id = AO.AccountCustomerId
  LEFT OUTER JOIN  ref.AccountSubsidiaries (NOLOCK) ASY on AO.AccountSubsidiaryId = ASY.ID
  LEFT OUTER JOIN  ref.AccountProducts (NOLOCK) AP on AO.AccountProductid = AP.ID
  LEFT OUTER JOIN ( SELECT AO.Id, Email =	 stuff( (select distinct  ';' + AC1.Email as [text()]
               FROM qan.AccountOwnerships (NOLOCK) A1 
						    LEFT OUTER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC1 on A1.ID = ACC1.OwnershipId and ACC1.IsActive = 1
						    LEFT OUTER JOIN QAN.AccountContactRoles (NOLOCK) ACR1 on ACR1.Id = ACC1.ContactRoleId
						    LEFT OUTER JOIN QAN.AccountContacts (NOLOCK) AC1 on AC1.ID = ACR1.ContactId
							LEFT OUTER JOIN ref.AccountRoles (NOLOCK) AR1 on AR1.Id = ACR1.RoleId
							Where A1.ID = AO.ID 
			   
               for xml path ('')),  1, 1, '')
		FROM qan.AccountOwnerships (NOLOCK) AO
		LEFT OUTER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId and ACC.IsActive = 1
		LEFT OUTER JOIN QAN.AccountContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.AccountContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.AccountRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.AccountProcess = AR.Process 
		GROUP BY AO.Id ) EMAILS ON EMAILS.Id = AO.ID
    LEFT OUTER JOIN ( SELECT AO.Id, Email =	 stuff( (select distinct  ';' + AC1.AlternateEmail as [text()]
               FROM qan.AccountOwnerships (NOLOCK) A1 
						    LEFT OUTER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC1 on A1.ID = ACC1.OwnershipId and ACC1.IsActive = 1
						    LEFT OUTER JOIN QAN.AccountContactRoles (NOLOCK) ACR1 on ACR1.Id = ACC1.ContactRoleId
						    LEFT OUTER JOIN QAN.AccountContacts (NOLOCK) AC1 on AC1.ID = ACR1.ContactId
							LEFT OUTER JOIN ref.AccountRoles (NOLOCK) AR1 on AR1.Id = ACR1.RoleId
							Where A1.ID = AO.ID 
			   
               for xml path ('')),  1, 1, '')
		FROM qan.AccountOwnerships (NOLOCK) AO
		LEFT OUTER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId and ACC.IsActive = 1
		LEFT OUTER JOIN QAN.AccountContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.AccountContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.AccountRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.AccountProcess = AR.Process 
		GROUP BY AO.Id ) AlternateEmail ON AlternateEmail.Id = AO.ID
  LEFT OUTER JOIN ( 
SELECT ID,AE,AEManager,AEManagerBackup,Approver,CME,CQE,CQEManager,CQEManagerBackup,FAE,FSE,Others,PCN FROM 
					(

SELECT AO.Id,REPLACE(AR.Name,' ','') as Value, Name =	 stuff( (select ' ' + AC1.Name as [text()]
               FROM qan.AccountOwnerships (NOLOCK) A1 
						    LEFT OUTER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC1 on A1.ID = ACC1.OwnershipId and ACC1.IsActive = 1
						    LEFT OUTER JOIN QAN.AccountContactRoles (NOLOCK) ACR1 on ACR1.Id = ACC1.ContactRoleId
						    LEFT OUTER JOIN QAN.AccountContacts (NOLOCK) AC1 on AC1.ID = ACR1.ContactId
							LEFT OUTER JOIN ref.AccountRoles (NOLOCK) AR1 on AR1.Id = ACR1.RoleId
							Where A1.ID = AO.ID and AR.Name = AR1.Name
			   
               for xml path ('')),  1, 1, '')
		FROM qan.AccountOwnerships (NOLOCK) AO
		LEFT OUTER JOIN QAN.AccountOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId and ACC.IsActive = 1
		LEFT OUTER JOIN QAN.AccountContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.AccountContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.AccountRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.AccountProcess = AR.Process 
		GROUP BY AO.Id,AR.NAME) d 
						    PIVOT (Max(Name) for Value in (AE,AEManager,AEManagerBackup,Approver,CME,CQE,CQEManager,CQEManagerBackup,FAE,FSE,Others,PCN)) piv ) NAMES ON NAMES.Id = AO.ID              
   where AO.AccountProcess = @process 


END