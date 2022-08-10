

-- ============================================================================    
-- Author       : bricschx    
-- Create date  : 2020-11-12 09:31:45.810    
-- Description  : Gets auto checker attribute types    
-- Example      : SELECT * FROM [qan].[FAcAttributeTypes](NULL, NULL, NULL,'aayyasax');    
-- ============================================================================    
CREATE FUNCTION [qan].[FGetOwnershipAccounts]    
(  
)    
RETURNS @OwnershipContactRole TABLE
(
	 [Id] INT
	 ,[RoleName] VARCHAR(4000)
	 ,[ContactId] VARCHAR(4000)
	 ,[ContactName] VARCHAR(4000)
	 ,[Email] VARCHAR(4000)   
	 ,[WWID]  VARCHAR(4000)  
	,[idSid] VARCHAR(4000)   
    
)
AS
BEGIN
	    

	 INSERT INTO @OwnershipContactRole
		select AO.Id as Id,
			   AR.NAME as RoleName, 
			   STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(ACR.ContactId,null)), ';') as  ContactId, 
               STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(AC.Name ,null)), ' ') as ContactName, 	  
	           STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(AC.Email ,null)), ';') as Email , 
	           STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(AC.WWID ,null)), ';') as WWID ,
	           STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(AC.idSid ,null)), ';') as  idSid 
	    from qan.AccountOwnerships AO 
		  left outer JOIN QAN.AccountOwnershipsContacts ACC on AO.ID = ACC.OwnershipId
		  left outer JOIN QAN.AccountContactRoles ACR on ACR.Id = ACC.ContactRoleId
		  left outer JOIN QAN.AccountContacts AC on AC.ID = ACR.ContactId
		  left outer JOIN ref.AccountRoles AR on AR.Id = ACR.RoleId and AO.AccountProcess = AR.Process 
		--  where AO.Id = @Id and AR.Name = @RoleName 
		    --AO.Id in (1,2) and 
		  Group by AO.Id, AR.NAME
   
   RETURN;
END