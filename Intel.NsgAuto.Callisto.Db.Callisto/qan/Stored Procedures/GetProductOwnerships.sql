
-- ===============================================================================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get Product Ownership Data
-- ===============================================================================================
CREATE PROCEDURE [qan].[GetProductOwnerships] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(25)
)
AS
BEGIN

    EXECUTE [qan].[GetProductOwnershipContacts] @UserId, @process

	SELECT  PO.[Id]
       ,PT.Id as ProductTypeId
	   ,PT.Name as ProductTypeName
       ,PP.Id as ProductPlatformId
	   ,PP.Name as ProductPlatformName
       ,PCN.Id as CodeNameId
	   ,PCN.Name as CodeName
	   ,ProductClassification
       ,PBN.Id as ProductBrandNameId
	   ,PBN.Name as ProductBrandName
       ,PLCS.Id as ProductLifeCycleStatusId
	   ,PLCS.Name as ProductLifeCycleStatusName
       ,[ProductLaunchDate]
	   ,Names.PME as PME    
	   ,NaMes.TME as  TME   
	   ,Names.PMT as PMT   
	   ,Names.PDT as PDT   
	   ,Names.PQE as PQE   
	   ,Names.Others as OTHERS
	   ,Names.PMEManager as PMEManager
	   ,Names.PMEManagerBackup as PMEManagerBackup
	   ,Names.PMTManager as PMTManager
	    ,Names.PMTManagerBackup as PMTManagerBackup
	  , CASE WHEN ISNULL(Email.Email,'') != '' AND ISNULL(AlternateEmail.Email,'') != '' THEN Email.Email + ';' + AlternateEmail.Email
	         WHEN ISNULL(Email.Email,'') != '' AND ISNULL(AlternateEmail.Email,'') = '' THEN Email.Email 
			 WHEN ISNULL(Email.Email,'') = '' AND ISNULL(AlternateEmail.Email,'') != '' THEN AlternateEmail.Email 
			 Else Null END AS Email

	        
       ,PO.[IsActive]
       ,PO.[CreatedBy]
       ,PO.[CreatedOn]
       ,PO.[UpdatedBy]
       ,PO.[UpdatedOn]
    FROM [Callisto].[qan].[ProductOwnerships] PO
    
	INNER JOIN [ref].[ProductTypes] PT ON PO.[ProductTypeId] = PT.ID
    LEFT OUTER JOIN ref.ProductPlatforms PP ON PO.[ProductPlatformId] = PP.ID
    LEFT OUTER JOIN qan.ProductCodeNames PCN ON PO.[CodeNameId] = PCN.ID
    LEFT OUTER JOIN qan.ProductBrandNames PBN on PO.ProductBrandNameId = PBN.ID
    LEFT OUTER JOIN ref.ProductLifeCycleStatuses PLCS on PO.ProductLifeCycleStatusId = PLCS.ID
    LEFT OUTER JOIN (SELECT ID,Others,PDT,PME,PMEManagerBackUp,PMEManager,PMT,PMTManagerBackUp,PMTManager,PQE,TME FROM 
					(

SELECT AO.Id,REPLACE(AR.Name,' ','') as Value, Name =	 stuff( (select ' ' + AC1.Name as [text()]
               FROM qan.ProductOwnerships (NOLOCK) A1 
						    LEFT OUTER JOIN QAN.ProductOwnershipsContacts (NOLOCK) ACC1 on A1.ID = ACC1.OwnershipId and ACC1.IsActive = 1
						    LEFT OUTER JOIN QAN.ProductContactRoles (NOLOCK) ACR1 on ACR1.Id = ACC1.ContactRoleId
						    LEFT OUTER JOIN QAN.ProductContacts (NOLOCK) AC1 on AC1.ID = ACR1.ContactId
							LEFT OUTER JOIN ref.ProductRoles (NOLOCK) AR1 on AR1.Id = ACR1.RoleId
							Where A1.ID = AO.ID and AR.Name = AR1.Name
			   
               for xml path ('')),  1, 1, '')
		FROM qan.ProductOwnerships (NOLOCK) AO
		LEFT OUTER JOIN QAN.ProductOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId and ACC.IsActive = 1
		LEFT OUTER JOIN QAN.ProductContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.ProductContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.ProductRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.ProductClassification = AR.Process 
		GROUP BY AO.Id,AR.NAME) d 
						    PIVOT (Max(Name) for Value in (Others,PDT,PME,PMEManagerBackUp,PMEManager,PMT,PMTManagerBackUp,PMTManager,PQE,TME)) piv) Names on Names.Id = PO.ID
	LEFT OUTER JOIN (SELECT AO.Id, Email =	 stuff( (select distinct  ';' + LTRIM(RTRIM(AC1.Email)) as [text()]
               FROM qan.ProductOwnerships (NOLOCK) A1 
						    LEFT OUTER JOIN QAN.ProductOwnershipsContacts (NOLOCK) ACC1 on A1.ID = ACC1.OwnershipId and ACC1.IsActive = 1
						    LEFT OUTER JOIN QAN.ProductContactRoles (NOLOCK) ACR1 on ACR1.Id = ACC1.ContactRoleId
						    LEFT OUTER JOIN QAN.ProductContacts (NOLOCK) AC1 on AC1.ID = ACR1.ContactId
							LEFT OUTER JOIN ref.ProductRoles (NOLOCK) AR1 on AR1.Id = ACR1.RoleId
							Where A1.ID = AO.ID 			   
               for xml path ('')),  1, 1, '')
		FROM qan.ProductOwnerships (NOLOCK) AO
		LEFT OUTER JOIN QAN.ProductOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId and ACC.IsActive = 1
		LEFT OUTER JOIN QAN.ProductContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.ProductContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.productRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.ProductClassification = AR.Process 
		GROUP BY AO.Id) EMAIL on EMAIL.Id = PO.Id
	LEFT OUTER JOIN (SELECT AO.Id, Email =	 stuff( (select distinct  ';' + LTRIM(RTRIM(AC1.AlternateEmail)) as [text()]
               FROM qan.ProductOwnerships (NOLOCK) A1 
						    LEFT OUTER JOIN QAN.ProductOwnershipsContacts (NOLOCK) ACC1 on A1.ID = ACC1.OwnershipId and ACC1.IsActive = 1
						    LEFT OUTER JOIN QAN.ProductContactRoles (NOLOCK) ACR1 on ACR1.Id = ACC1.ContactRoleId
						    LEFT OUTER JOIN QAN.ProductContacts (NOLOCK) AC1 on AC1.ID = ACR1.ContactId
							LEFT OUTER JOIN ref.ProductRoles (NOLOCK) AR1 on AR1.Id = ACR1.RoleId
							Where A1.ID = AO.ID 			   
               for xml path ('')),  1, 1, '')
		FROM qan.ProductOwnerships (NOLOCK) AO
		LEFT OUTER JOIN QAN.ProductOwnershipsContacts (NOLOCK) ACC on AO.ID = ACC.OwnershipId and ACC.IsActive = 1
		LEFT OUTER JOIN QAN.ProductContactRoles (NOLOCK) ACR on ACR.Id = ACC.ContactRoleId
		LEFT OUTER JOIN QAN.ProductContacts (NOLOCK) AC on AC.ID = ACR.ContactId
		LEFT OUTER JOIN ref.productRoles (NOLOCK) AR on AR.Id = ACR.RoleId and AO.ProductClassification = AR.Process 
		GROUP BY AO.Id) AlternateEmail on AlternateEmail.Id = PO.Id
		WHERE PO.IsActive = 1 and PO.ProductClassification = @process 


END