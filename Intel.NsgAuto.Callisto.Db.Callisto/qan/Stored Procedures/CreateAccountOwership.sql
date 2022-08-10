

-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Create new Product Ownership
-- =============================================
CREATE PROCEDURE [qan].[CreateAccountOwership] 	
	 	@Succeeded bit OUTPUT,
		@Message varchar(500) OUTPUT,
		@UserId varchar(25),
		@AccountClientId int
        ,@AccountCustomerId int
        ,@AccountSubsidiaryId int
        ,@AccountProductid int
		,@Contacts [qan].IAccountOwnershipContactCreate READONLY
  --    ,@AccountProcess int
        ,@IsActive bit        
        ,@Notes  varchar(4000)        
		,@CreatedBy varchar(25)	
		,@UpdatedBy varchar(25) 	
		
	
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @On                        DATETIME2(7) = GETUTCDATE()
	DECLARE @RoleName                  VARCHAR(25)
	 
    DECLARE @process				   VARCHAR(25)
	SET @process =                     (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                          INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);

	CREATE TABLE #CREATECONTACT       
	(   AccountName                    VARCHAR(255),
		AccountOwnershipId             INT,
		AccountOwnershipsContactId     INT,
		Email                          VARCHAR(255),
		AlternateEmail                 VARCHAR(255),
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

	UPDATE #CREATECONTACT SET AlternateEmail = LTRIm(RTRIM(AlternateEmail)) where AlternateEmail iS NOT NULL

	CREATE TABLE #CONTACT      
	(   AccountName                    VARCHAR(255),
		Email                          VARCHAR(255),
		AlternateEmail                 VARCHAR(255),
		idSid                          VARCHAR(15),		
		WWID                           VARCHAR(20)		
			
	);

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
	   INSERT ([Name],[WWID],[idSid],[Email],[AlternateEmail] ,[IsActive],[CreatedBy],[CreatedOn],[UpdatedBy],[UpdatedOn]) VALUES ([AccountName],[WWID],[idSid],LTRIm(RTRIM([Email])),AlternateEmail,1,@UserId,@On,@UserId,@On)
	WHEN MATCHED AND ISNULL(SOURCE.AlternateEmail,'') != ISNULL(TARGET.AlternateEmail,'')   THEN 
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

	INSERT INTO [qan].[AccountOwnerships]
           ([AccountClientId]
           ,[AccountCustomerId]
           ,[AccountSubsidiaryId]
           ,[AccountProductid]
           ,[AccountProcess]
           ,[IsActive]       
           ,[Notes]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[UpdatedBy]
           ,[UpdatedOn])
    VALUES
           (@AccountClientId,
			@AccountCustomerId,
			@AccountSubsidiaryId,			
			@AccountProductid,			
			@process,
			@IsActive,			
			@Notes,
			@UserId,
			@On,
			@UserId,
			@On)

			
	UPDATE #CREATECONTACT SET AccountOwnershipId  = CAST(SCOPE_IDENTITY() as [int]);	
	
	INSERT INTO [qan].[AccountOwnershipsContacts]
           ([OwnershipId]
           ,[ContactRoleId]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[UpdatedBy]
           ,[UpdatedOn])
	SELECT AccountOwnershipId,
		   AccountOwnershipsContactId,
		   @UserId,
		   @On,
		   @UserId,
		   @On
	FROM #CREATECONTACT

	EXECUTE [qan].[GetAccountOwnershipContacts] @UserId,@process
	EXECUTE [qan].[GetAccountOwnerships] @UserId,@process

	SET @Message = 'Successful'
	SET @Succeeded = 1
			
    
END