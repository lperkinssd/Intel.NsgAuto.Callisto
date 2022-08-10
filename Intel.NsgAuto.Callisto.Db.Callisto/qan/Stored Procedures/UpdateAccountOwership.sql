


-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Update Product Ownership
-- =============================================
CREATE PROCEDURE [qan].[UpdateAccountOwership] 
	-- Add the parameters for the stored procedure here

	 	@Succeeded bit OUTPUT,
		@Message varchar(500) OUTPUT,
		@UserId varchar(25),
		@Id int,	
		@RecordChanged bit,
        @Contacts [qan].IAccountOwnershipContactCreate READONLY 
        ,@Notes  varchar(4000)  
		,@UpdatedBy varchar(25) 	
		
	
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @On    DATETIME2(7) = GETUTCDATE()
	DECLARE @RoleName varchar(25)
	DECLARE @Product  varchar(255)
	DECLARE @DC  varchar(255)
	DECLARE @MainCustomer  varchar(255)
	DECLARE @Customer  varchar(255)
	DEclare @RecordInserted bit = 0
	-- New ProductCodeName Insert/Get the ProductCodeId
	 
	DECLARE @process				   VARCHAR(25)
	SET @process =                     (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                          INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
	 
	

	CREATE TABLE  #CREATECONTACT    
	(   AccountName                    VARCHAR(255),
		AccountOwnershipId             INT,
		AccountOwnershipsContactId     INT,
		Email                          VARCHAR(255),
		AlternateEmail                  VARCHAR(255),
		idSid                          VARCHAR(15),
		RoleName                       VARCHAR(255),
		WWID                           VARCHAR(20),
		ContactId				       INT,
		OwnershipId					   INT,
		RoleId						   INT
	);

	INSERT INTO #CREATECONTACT
	(
		AccountName                    
		,AccountOwnershipId             
		,AccountOwnershipsContactId     
		,Email  
		,AlternateEmail
		,idSid                          
		,RoleName                       
		,WWID)
	SELECT  
	     AccountName                    
		,AccountOwnershipId             
		,AccountOwnershipsContactId     
		,Email  
		,AlternateEmail
		,idSid                          
		,RoleName                       
		,WWID
	FROM @Contacts

	UPDATE #CREATECONTACT SET AlternateEmail = NULL where ISNULL(AlternateEmail,'')=''

	UPDATE #CREATECONTACT SET AlternateEmail = LTRIM(RTRIM(AlternateEmail)) where AlternateEmail IS NOT NULL

	CREATE TABLE #CONTACT      
	(   AccountName                    VARCHAR(255),
		Email                          VARCHAR(255),
		AlternateEmail                 VARCHAR(255),
		idSid                          VARCHAR(15),		
		WWID                           VARCHAR(20)		
			
	);

	CREATE TABLE #CHANGEDCONTACT      
	(   AccountName                    VARCHAR(255),
		Email                          VARCHAR(255),
		AlternateEmail                 VARCHAR(255),
		RoleName					   VARCHAR(25),
		Type						   VARCHAR(25)
	);

	INSERT INTO #CHANGEDCONTACT      
	(   AccountName,
		Email,
		AlternateEmail,
		RoleName,
		Type		
	)
	SELECT distinct 
		AccountName                    
	   ,Email 
	   ,AlternateEmail
	   ,RoleName
	   ,'Input'		  
	FROM #CREATECONTACT
	
	
	UPDATE #CHANGEDCONTACT SET AlternateEmail = NULL where ISNULL(AlternateEmail,'')=''

	INSERT INTO #CONTACT
	(
		 AccountName                    		         		  
		,Email  
		,AlternateEmail
		,idSid               
		,WWID)
	SELECT  distinct
	     AccountName                    
		,Email   
		,AlternateEmail
		,idSid                 
		,WWID
	FROM @Contacts
	 
	 UPDATE #CONTACT SET AlternateEmail = NULL where ISNULL(AlternateEmail,'')=''

	MERGE qan.AccountContacts AS TARGET
		USING #CONTACT AS SOURCE
		ON TARGET.WWID = SOURCE.WWID	
	WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([Name],[WWID],[idSid],[Email],[AlternateEmail],[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES ([AccountName],[WWID],[idSid],LTRIM(RTRIM([Email])),AlternateEmail,1,@UserId,@On,@UserId,@On)
	WHEN MATCHED AND ISNULL(SOURCE.AlternateEmail,'') !=ISNULL(TARGET.AlternateEmail,'')  THEN 
	   --INSERT ([Name],[WWID],[idSid],[Email],[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES ([AccountName],[WWID],[idSid],LTRIm(RTRIM([Email])),1,@UserId,@On,@UserId,@On);
		UPDATE SET TARGET.AlternateEmail = SOURCE.ALTERNATEEMAIL;
	

    UPDATE TARGET SET ContactId = SOURCE.Id
		FROM #CREATECONTACT TARGET
		INNER JOIN QAN.AccountContacts SOURCE ON SOURCE.WWID = TARGET.WWID

	UPDATE TARGET SET RoleId = SOURCE.Id
		FROM #CREATECONTACT TARGET
		INNER JOIN REF.AccountRoles SOURCE ON SOURCE.NAME = TARGET.RoleName and SOURCE.Process =@process

	MERGE qan.AccountContactRoles AS TARGET
		USING #CREATECONTACT AS SOURCE
		ON TARGET.ContactId = SOURCE.ContactId and TARGET.RoleId = Source.RoleId	
	WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([RoleId],[ContactId],[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES (RoleId,ContactId,1,@UserId,@On,@UserId,@On);
	
	UPDATE TARGET SET AccountOwnershipsContactId = SOURCE.Id
		FROM #CREATECONTACT TARGET
		INNER JOIN qan.AccountContactRoles SOURCE ON SOURCE.ContactId = TARGET.ContactId AND SOURCE.RoleId = TARGET.RoleId

	INSERT INTO #CHANGEDCONTACT      
	(   AccountName,
		Email,
		RoleName,
		Type
	)
    SELECT AC.Name,AC.Email,AR.Name,'Output' FROM  QAN.AccountOwnershipsContacts ACC
				INNER JOIN QAN.AccountContactRoles ACR on ACR.Id = ACC.ContactRoleId
				INNER JOIN QAN.AccountContacts AC on AC.Id = ACR.ContactId
				INNER JOIN ref.AccountRoles AR on AR.Id = ACR.RoleId
	WHERE --ContactRoleId NOT IN (SELECT AccountOwnershipsContactId FROM #CREATECONTACT) AND
	OwnershipId = @Id
	
	
	--Added 1/6
	DELETE FROM QAN.AccountOwnershipsContacts  
		WHERE Id NOT IN (SELECT AccountOwnershipId FROM #CREATECONTACT) 
		AND OwnershipId = @Id
	-- Added 1/6

	IF Exists(SELECT * FROM #CREATECONTACT WHERE AccountOwnershipId = 0)
	   SET @RecordInserted = 1


    MERGE qan.AccountOwnershipsContacts AS TARGET
		USING #CREATECONTACT AS SOURCE
		ON TARGET.Id = SOURCE.AccountOwnershipId 
	WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([OwnershipId],[ContactRoleId],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES (@Id,AccountOwnershipsContactId,@UserId,@On,@UserId,@On);
	  

	
	--Commented 1/6
	--DELETE FROM QAN.AccountOwnershipsContacts  
	--	WHERE ContactRoleId NOT IN (SELECT AccountOwnershipsContactId FROM #CREATECONTACT) 
	--	AND OwnershipId = @Id
	--Commented 1/6

	UPDATE [qan].[AccountOwnerships]
    SET  
      [Notes] = @Notes     
      ,[UpdatedBy] = @UserId
      ,[UpdatedOn] = @On
	 WHERE Id=@Id 
	 and ((isnull(Notes,'') <> isnull(@Notes,'')) or (@RecordInserted=1) or (@RecordInserted=1))
  
	EXECUTE [qan].[GetAccountOwnershipContacts] @UserId,@process

	EXECUTE [qan].[GetAccountOwnerships] @UserId,@process
	
	

	SELECT ET.BodyXml, ETB.Value as BodyXslValue, ET.Subject as Subject FROM REF.EmailTemplates (NOLOCK) ET
			  INNER JOIN REF.EmailTemplateBodyXsls  (NOLOCK) ETB ON ET.BodyXslId = ETB.ID
			  WHERE ET.NAME = 'AccountOwnershipChange' 


	SELECT  (STUFF( (SELECT ', ' +  P.[Name] as [text()]  
		FROM [Callisto].[qan].[Products] P
	    INNER JOIN [Callisto].[ref].[DesignFamilies] DF ON P.DesignFamilyId = DF.Id
        WHERE DF.NAME = @process
		FOR XML PATH ('')),  1, 1, '')) as Name

	--update #CHANGEDCONTACT set Email='CallistoSupport@intel.com'

	IF (@RecordChanged =1)
		BEGIN
		  SELECT * FROM #CHANGEDCONTACT
		END

	SET @Message = 'Successful'
	SET @Succeeded = 1

END