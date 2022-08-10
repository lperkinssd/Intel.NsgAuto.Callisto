

-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Update Product Ownership
-- =============================================
CREATE PROCEDURE [qan].[UpdateProductOwership] 
	-- Add the parameters for the stored procedure here

	 	@Succeeded bit OUTPUT,
		@Message varchar(500) OUTPUT,
		@UserId varchar(25),
		@Id int,	
		@RecordChanged bit,
		@ProductLifeCycleStatusId int ,
		@ProductLaunchDate DATE=null ,
		@Contacts [qan].[IProductOwnershipContactsCreate] readonly,		
		@IsActive bit ,

--		@CreatedBy varchar(25) ,	
		@UpdatedBy varchar(25) 	
		
	
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @On    DATETIME2(7) = GETUTCDATE();
	-- New ProductCodeName Insert/Get the ProductCodeId
	DECLARE @RecordId int
	
	DECLARE @outputId int
	DECLARE @MessageI varchar(500)
	DECLARE @ContactId int
	DECLARE @ContactName varchar(255)
	DECLARE @RoleName varchar(255)
	DECLARE @By varchar(25)
	DECLARE @outputId1 int
	DECLARE @ProductName varchar(255)
	DECLARE @RecordInserted bit=0

	DECLARE @process				   VARCHAR(25)
	SET @process =                     (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                          INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
	if @ProductLaunchDate='1900-01-01' 
		SET @ProductLaunchDate = NULL

	IF (@ProductLifeCycleStatusId =0)
		BEGIN
			SET @ProductLifeCycleStatusId = null
		END

	CREATE TABLE #CREATECONTACT       
	(   ContactName                    VARCHAR(255),			
		ContactId                      INT,	
		ContactRoleId				   INT,
		ProductOwnershipId		       INT, 
		Email                          VARCHAR(255),
		AlternateEmail                 VARCHAR(255),
		idSid                          VARCHAR(15),
		RoleName                       VARCHAR(255),
		WWID                           VARCHAR(20),			
		RoleId						   INT,
		ProductOwnershipContactId      INT
	);

	CREATE TABLE #CHANGEDCONTACT      
	(   AccountName                    VARCHAR(255),
		Email                          VARCHAR(255),
		AlternateEmail                 VARCHAR(255),
		RoleName					   VARCHAR(25),		
		Type						   VARCHAR(25),		
			
	);

		INSERT INTO #CREATECONTACT
	(
		 ContactName                    
		,ProductOwnershipContactId  
		,ProductOwnershipId
		,Email 
		,AlternateEmail
		,idSid                          
		,RoleName                       
		,WWID)
	SELECT  
	     ContactName                    
		,ContactId   
		,ProductOwnershipId  
		,Email
		,AlternateEmail
		,idSid                          
		,RoleName                       
		,WWID
	FROM @Contacts

	UPDATE #CREATECONTACT SET AlternateEmail = NULL where ISNULL(AlternateEmail,'')=''

	UPDATE #CREATECONTACT SET AlternateEmail = LTRIM(RTRIM(AlternateEmail)) where AlternateEmail IS NOT NULL
	
		CREATE TABLE #CONTACT      
	(   ContactName                    VARCHAR(255),
		Email                          VARCHAR(255),
		AlternateEmail                 VARCHAR(255),
		idSid                          VARCHAR(15),		
		WWID                           VARCHAR(20)		
			
	);


	 
	INSERT INTO #CONTACT
	(
		 ContactName                    		         		  
		,Email 
		,AlternateEmail
		,idSid               
		,WWID)
	SELECT  distinct
	     ContactName                    
		,Email  
		,AlternateEmail
		,idSid                 
		,WWID
	FROM #CREATECONTACT

	UPDATE #CONTACT SET AlternateEmail = NULL where ISNULL(AlternateEmail,'')=''

	INSERT INTO #CHANGEDCONTACT      
	(   AccountName,
		Email,
		AlternateEmail,
		RoleName,
		Type		
	)
	SELECT distinct 
		ContactName                    
	   ,Email 
	   ,AlternateEmail
	   ,RoleName
	   ,'Input'		  
	FROM #CREATECONTACT

	UPDATE #CHANGEDCONTACT SET AlternateEmail = NULL where ISNULL(AlternateEmail,'')=''
	
	MERGE qan.ProductContacts AS TARGET
		USING #CONTACT AS SOURCE
		ON TARGET.WWID = SOURCE.WWID	
	WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([Name],[WWID],[idSid],[Email],[AlternateEmail],[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES ([ContactName],[WWID],[idSid],LTRIM(RTRIM([Email])),AlternateEmail,1,@UserId,@On,@UserId,@On)
	WHEN MATCHED AND ISNULL(SOURCE.AlternateEmail,'') ! = ISNULL(TARGET.AlternateEmail,'')  THEN 
	   --INSERT ([Name],[WWID],[idSid],[Email],[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES ([AccountName],[WWID],[idSid],LTRIm(RTRIM([Email])),1,@UserId,@On,@UserId,@On);
		UPDATE SET TARGET.AlternateEmail = SOURCE.ALTERNATEEMAIL;

	UPDATE TARGET SET ContactId = SOURCE.Id
		FROM #CREATECONTACT TARGET
		INNER JOIN QAN.ProductContacts SOURCE ON SOURCE.WWID = TARGET.WWID

	UPDATE TARGET SET RoleId = SOURCE.Id
		FROM #CREATECONTACT TARGET
		INNER JOIN REF.ProductRoles SOURCE ON SOURCE.NAME = TARGET.RoleName and SOURCE.Process =@process

    


	MERGE qan.ProductContactRoles AS TARGET
		USING #CREATECONTACT AS SOURCE
		ON TARGET.ContactId = SOURCE.ContactId and TARGET.RoleId = Source.RoleId	
	WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([RoleId],[ContactId],[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES (RoleId,ContactId,1,@UserId,@On,@UserId,@On);

	UPDATE TARGET SET ContactRoleId = SOURCE.Id
		FROM #CREATECONTACT TARGET
		INNER JOIN qan.ProductContactRoles SOURCE ON SOURCE.ContactId = TARGET.ContactId AND SOURCE.RoleId = TARGET.RoleId

    INSERT INTO #CHANGEDCONTACT      
	(   AccountName,
		Email,
		RoleName,
		Type
	)
    SELECT AC.Name,AC.Email,AR.Name,'Output' FROM  QAN.ProductOwnershipsContacts ACC
				INNER JOIN QAN.ProductContactRoles ACR on ACR.Id = ACC.ContactRoleId
				INNER JOIN QAN.ProductContacts AC on AC.Id = ACR.ContactId
				INNER JOIN ref.ProductRoles AR on AR.Id = ACR.RoleId
	WHERE --ContactRoleId NOT IN (SELECT AccountOwnershipsContactId FROM #CREATECONTACT) AND
	OwnershipId = @Id

	--Added 1/6
	DELETE FROM QAN.ProductOwnershipsContacts  
		WHERE Id NOT IN (SELECT ContactId FROM @Contacts) 
		AND OwnershipId = @Id
	--Added 1/6
	IF Exists(SELECT * FROM #CREATECONTACT WHERE ProductOwnershipContactId = 0)
	   SET @RecordInserted = 1


	MERGE qan.ProductOwnershipsContacts AS TARGET
		USING #CREATECONTACT AS SOURCE
		ON TARGET.Id = SOURCE.ProductOwnershipContactId 
	WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([OwnershipId],[ContactRoleId],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES (@Id,ContactRoleId,@UserId,@On,@UserId,@On);
--	INSERT INTO [qan].[ProductOwnershipsContacts]
--           ([OwnershipId]
--           ,[ContactRoleId]
--           ,[CreatedBy]
--           ,[CreatedOn]
--           ,[UpdatedBy]
--           ,[UpdatedOn])
--Select distinct @Id,ContactRoleId,@UserId,@On,@UserId,@On FROM #CREATECONTACT

 -- COMMENTED ON 1/6
	--DELETE FROM QAN.ProductOwnershipsContacts  
	--	WHERE ContactRoleId NOT IN (SELECT ContactRoleId FROM #CREATECONTACT) 
	--	AND OwnershipId = @Id

	

	-- COMMENTED ON 1/6

	UPDATE [qan].[ProductOwnerships]
	   SET 
	 
		  [ProductLifeCycleStatusId] = @ProductLifeCycleStatusId
		  ,[ProductLaunchDate] = @ProductLaunchDate
	
		  ,[UpdatedBy] = @UserId
		  ,[UpdatedOn] = @On
	 WHERE Id=@Id 
	 and (

		  (isnull([ProductLifeCycleStatusId],'') <> isnull(@ProductLifeCycleStatusId,'')) OR
		  (isnull([ProductLaunchDate],'') <> isnull(@ProductLaunchDate,'')) OR (@RecordChanged =1) OR (@RecordInserted =1)
		  ) 
		  
			EXECUTE [qan].[GetProductOwnerships] @UserId, @process

			

			SELECT ET.BodyXml, ETB.Value as BodyXslValue, ET.Subject as Subject FROM REF.EmailTemplates (NoLock) ET
			  INNER JOIN REF.EmailTemplateBodyXsls (NoLock) ETB ON ET.BodyXslId = ETB.ID
			  WHERE ET.NAME = 'ProductOwnershipChange' 

		--	UPDATE #CHANGEDCONTACT set Email ='CallistoSupport@intel.com'
			
			IF (@RecordChanged =1)
				BEGIN
					SELECT * FROM #CHANGEDCONTACT
				END

			SET @Message = 'Successful'
			SET @Succeeded = 1
			--Select @Message
					drop table #CONTACT
					drop table  #CHANGEDCONTACT      
					drop table #CREATECONTACT ;
    
END