
-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Create new Product Ownership
-- =============================================
CREATE PROCEDURE [qan].[CreateProductOwership] 
	-- Add the parameters for the stored procedure here
	 	@Succeeded bit OUTPUT,
		@Message varchar(500) OUTPUT,
		@UserId varchar(25),
		@ProductTypeId int ,
		@ProductPlatformId int ,
		@CodeNameId int ,
		@ProductCodeName varchar(255)=null,
		@ProductBrandNameId int ,
		@ProductBrandName varchar(255)=null,
		@ProductLifeCycleStatusId int ,
		@ProductLaunchDate DATE ,
		@Contacts [qan].[IProductOwnershipContactsCreate] readonly,		
		@IsActive bit ,
		@CreatedBy varchar(25) ,	
		@UpdatedBy varchar(25) 	
		
	
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @On    DATETIME2(7) = GETUTCDATE();
	-- New ProductCodeName Insert/Get the ProductCodeId
	DECLARE @Id int
	DECLARE @PMEId int = null
	DECLARE @TMEId int  = null
	DECLARE @PMTId int  = null
	DECLARE @PDTId int  = null
	DECLARE @PQEId int  = null
	DECLARE @OthersId int = null
	DECLARE @PMEManagerId int = null
	DECLARE @PMEManagerBackupId int = null
	DECLARE @PMTManagerId int = null
	DECLARE @PMTManagerBackupId int = null
	DECLARE @outputId int
	DECLARE @MessageI varchar(500)
	DECLARE @ContactId int
	DECLARE @ContactName varchar(255)
	DECLARE @RoleName varchar(255)
	DECLARE @By varchar(25)

	if @ProductLaunchDate='1900-01-01' 
		SET @ProductLaunchDate = NULL

	DECLARE @process				   VARCHAR(25)
	SET @process =                     (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                          INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);

	CREATE TABLE #CREATECONTACT       
	(   ContactName                    VARCHAR(255),
		ContactId                      INT,	
		ContactRoleId				   INT,
		ProductOwnershipId		       INT, 
		Email                          VARCHAR(255),
		AlternateEmail                          VARCHAR(255),
		idSid                          VARCHAR(15),
		RoleName                       VARCHAR(255),
		WWID                           VARCHAR(20),			
		RoleId						   INT		
	);

	INSERT INTO #CREATECONTACT
	(
		 ContactName                    
		,ContactId  
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
	FROM @Contacts

	UPDATE #CONTACT SET AlternateEmail = NULL where ISNULL(AlternateEmail,'')=''

	UPDATE #CONTACT SET AlternateEmail = LTRIM(RTRIM(AlternateEmail)) where AlternateEmail iS NOT NULL

	MERGE qan.ProductContacts AS TARGET
		USING #CONTACT AS SOURCE
		ON TARGET.WWID = SOURCE.WWID	
	WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([Name],[WWID],[idSid],[Email],[AlternateEmail],[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES ([ContactName],[WWID],[idSid],LTRIM(RTRIM([Email])),AlternateEmail,1,@UserId,@On,@UserId,@On)
	WHEN MATCHED AND ISNULL(SOURCE.AlternateEmail,'') !=ISNULL(TARGET.AlternateEmail,'')   THEN 
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

	--SELECT @PMEId=ISNULL(ContactRoleId,null)    FROM @CREATECONTACT WHERE ROLENAME='PME'
	--SELECT @TMEId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='TME'
	--SELECT @PMTId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='PMT'
	--SELECT @PDTId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='PDT'
	--SELECT @PQEId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='PQE'
	--SELECT @OthersId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='Others'
	--SELECT @PMEManagerId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='PMEManager'
	--SELECT @PMEManagerBackupId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='PMEManager Backup'
	--SELECT @PMTManagerId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='PMTManager'
	--SELECT @PMTManagerBackupId=ISNULL(ContactRoleId,null)     FROM @CREATECONTACT WHERE ROLENAME='PMTManager Backup'

	IF (@ProductLifeCycleStatusId =0)
		BEGIN
			SET @ProductLifeCycleStatusId = null
		END
	
	IF (@ProductCodeName is NOT NULL)  
		BEGIN
			EXECUTE [qan].[CreateProductCodeName] @Id OUTPUT,@MessageI OUTPUT,@ProductCodeName,@UserId,@process
			select @CodeNameId = @Id
		END
	ELSE
		BEGIN
			SET @CodeNameId = NULL
		END
    -- New ProductBrandName Insert/Get the ProductCodeId
	IF (@ProductBrandName is NOT NULL)  
		BEGIN
			EXECUTE [qan].[CreateProductBrandName]  @outputId OUTPUT,@MessageI OUTPUT,@ProductBrandName,@UserId,@process
			Select @ProductBrandNameId = @outputId
		END
	ELSE
		BEGIN
			SET @ProductBrandNameId  = NULL
		END

	


	

	INSERT INTO [qan].[ProductOwnerships]
           ([ProductTypeId]
           ,[ProductPlatformId]
           ,[CodeNameId]
		   ,[ProductClassification]
           ,[ProductBrandNameId]
           ,[ProductLifeCycleStatusId]
           ,[ProductLaunchDate]
     --      ,[PMEId]
     --      ,[TMEId]
     --      ,[PMTId]
     --      ,[PDTId]
     --      ,[PQEId]
		   --,[PMEManagerId]
		   --,[PMEManagerBackupId]
		   --,[PMTManagerId]
		   --,[PMTManagerBackupId]
     --      ,[OthersId]
           ,[IsActive]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[UpdatedBy]
           ,[UpdatedOn])
     VALUES
           (@ProductTypeId,
			@ProductPlatformId,
			@CodeNameId,
			@process,
			@ProductBrandNameId,			
			@ProductLifeCycleStatusId,
			@ProductLaunchDate,
			--@PMEId,
			--@TMEId,
			--@PMTId,
			--@PDTId,
			--@PQEId,
			--@OthersId,
			--@PMEManagerId,
			--@PMEManagerBackupId,
			--@PMTManagerId,
			--@PMTManagerBackupId,
			@IsActive,
			@CreatedBy,
			@On,
			@UpdatedBy,
			@On)

			UPDATE #CREATECONTACT SET ProductOwnershipId  = CAST(SCOPE_IDENTITY() as [int]);
			
		  INSERT INTO [qan].[ProductOwnershipsContacts]
           ([OwnershipId]
           ,[ContactRoleId]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[UpdatedBy]
           ,[UpdatedOn])
		  SELECT ProductOwnershipId,
		   ContactRoleId,
		   @UserId,
		   @On,
		   @UserId,
		   @On
		  FROM #CREATECONTACT

			EXECUTE [qan].[GetProductOwnerships] @UserId, @process

			SET @Message = 'Successful'
			SET @Succeeded = 1
			--Select @Message
    
END