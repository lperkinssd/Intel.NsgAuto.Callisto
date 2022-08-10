-- ============================================================================================  
-- Author       : bricschx  
-- Create date  : 2020-11-12 10:46:02.880  
-- Description  : Creates a new auto checker attribute type  
-- Example      : EXEC [qan].[CreateAcAttributeType] NULL, NULL, 'bricschx', 'test', 'Test', 1;  
-- ============================================================================================  
CREATE PROCEDURE [qan].[CreateAcAttributeType]  
(  
   @Id INT OUT  
 , @Message VARCHAR(500) OUTPUT  
 , @By VARCHAR(25)  
 , @Name VARCHAR(50)  
 , @NameDisplay VARCHAR(50)  
 , @DataTypeId INT  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @ActionDescription VARCHAR (1000) = 'Create';  
 DECLARE @ErrorsExist       BIT = 0;  
 DECLARE @On                DATETIME2(7) = GETUTCDATE();  
 DECLARE @Succeeded         BIT = 0;  
 DECLARE @TempId            INT;  
  
 SET @Id = NULL;  
 SET @Message = NULL;  
  
 -- begin standardization  
 SET @Name = NULLIF(LOWER(RTRIM(LTRIM(@Name))), '');  
 SET @NameDisplay = NULLIF(RTRIM(LTRIM(@NameDisplay)), '');  
 -- end standardization  
  
 SET @ActionDescription = @ActionDescription + '; Name = ' + ISNULL(@Name, 'null')  
            + '; NameDisplay = ' + ISNULL(@NameDisplay, 'null')  
            + '; DataTypeId = ' + ISNULL(CAST(@DataTypeId AS VARCHAR(20)), 'null');  
  
 -- begin validation  
 SELECT @TempId = MAX([Id]) FROM [ref].[AcAttributeDataTypes] WITH (NOLOCK) WHERE [Id] = @DataTypeId;  
  
 IF (@Name IS NULL)  
 BEGIN  
  SET @Message = 'Name is required';  
  SET @ErrorsExist = 1;  
 END;  
 ELSE IF (@NameDisplay IS NULL)  
 BEGIN  
  SET @Message = 'Display Name is required';  
  SET @ErrorsExist = 1;  
 END;  
 ELSE IF (@TempId IS NULL)  
 BEGIN  
  SET @Message = 'Data Type is invalid: ' + ISNULL(CAST(@DataTypeId AS VARCHAR(20)), '');  
  SET @ErrorsExist = 1;  
 END  
 ELSE IF (EXISTS(SELECT 1 FROM [qan].[AcAttributeTypes] WITH (NOLOCK) WHERE [Name] = @Name))  
 BEGIN  
  SET @Message = 'Name already in use';  
  SET @ErrorsExist = 1;  
 END  
 ELSE IF (EXISTS(SELECT 1 FROM [qan].[AcAttributeTypes] WITH (NOLOCK) WHERE [NameDisplay] = @NameDisplay))  
 BEGIN  
  SET @Message = 'Display Name already in use';  
  SET @ErrorsExist = 1;  
 END;  
 -- end validation  
  
 IF (@ErrorsExist = 0)  
 BEGIN  
	Declare @DfFamilyId INT;
	SET @DfFamilyId = (SELECT DF.Id FROM [qan].[PreferredRole] pfr WITH (NOLOCK) INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName 
						INNER JOIN [ref].Designfamilies DF on pr.Process=DF.Name
							WHERE pfr.UserId =  @By)
  INSERT INTO [qan].[AcAttributeTypes]  
  (  
     [Name]  
   , [NameDisplay]  
   , [DataTypeId]  
   , [CreatedBy]  
   , [CreatedOn]  
   , [UpdatedBy]  
   , [UpdatedOn] 
   
  )  
  VALUES  
  (  
     @Name  
   , @NameDisplay  
   , @DataTypeId  
   , @By  
   , @On  
   , @By  
   , @On  
   
  );  
  
  SELECT @Id = SCOPE_IDENTITY();  

  --Adding into Attribute Design mapping table
  insert into [qan].[AcAttributeDesignFamilies] (AttributeId,DesignFamilyId,CreatedBy,UpdatedBy)
	values(@Id,@DfFamilyId,@By,@By)
  
  SET @Succeeded = 1;  
 END;  
  
 EXEC [qan].[CreateUserAction] NULL, @By, @ActionDescription, 'Auto Checker', 'Create', 'AcAttributeType', @Id, NULL, @Succeeded, @Message;  
  
END
