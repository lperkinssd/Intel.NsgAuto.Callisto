-- ============================================================================    
-- Author       : bricschx    
-- Create date  : 2020-11-12 09:31:45.810    
-- Description  : Gets auto checker attribute types    
-- Example      : SELECT * FROM [qan].[FAcAttributeTypes](NULL, NULL, NULL,'aayyasax');    
-- ============================================================================    
CREATE FUNCTION [qan].[FAcAttributeTypes]    
(    
   @Id         INT         = NULL    
 , @Name       VARCHAR(50) = NULL    
 , @DataTypeId INT         = NULL    
  ,@UserId     VARCHAR(25) = NULL    
)    
RETURNS @AcAttributeTypes TABLE
(
	 [Id] INT
	 ,[Name] VARCHAR(50)
	 ,[NameDisplay] VARCHAR(50)
	 ,[DataTypeId] INT
	 ,[DataTypeName] VARCHAR(50)   
	 ,[DataTypeNameDisplay]  VARCHAR(50)  
	,[CreatedBy] VARCHAR(25)   
    ,[CreatedOn] datetime2   
    ,[UpdatedBy] VARCHAR(25)      
    ,[UpdatedOn] datetime2
)
AS
BEGIN
	    DECLARE @Process Varchar(MAX);    
       SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK)     
     INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId); 

	 INSERT INTO @AcAttributeTypes
		 SELECT    
			A.[Id]    
		  , A.[Name]    
		  , A.[NameDisplay]    
		  , A.[DataTypeId]    
		  , D.[Name] AS [DataTypeName]    
		  , D.[NameDisplay] AS [DataTypeNameDisplay]    
		  , A.[CreatedBy]    
		  , A.[CreatedOn]    
		  , A.[UpdatedBy]    
		  , A.[UpdatedOn]    
		 FROM [qan].[AcAttributeTypes] AS A WITH (NOLOCK)  
		 INNER JOIN [qan].[AcAttributeDesignFamilies] AS AD WITH (NOLOCK) ON A.Id = AD.AttributeId
		 LEFT OUTER JOIN [ref].[DesignFamilies] AS DF WITH (NOLOCK) ON (DF.[Id]= AD.[DesignFamilyId])   
		 LEFT OUTER JOIN [ref].[AcAttributeDataTypes] AS D WITH (NOLOCK) ON (D.[Id] = A.[DataTypeId])   
   
		 WHERE (@Id IS NULL OR A.[Id] = @Id )    
		   AND DF.[Name] =@Process 
		   AND (@Name IS NULL OR A.[Name] = @Name)    
		   AND (@DataTypeId IS NULL OR A.[DataTypeId] = @DataTypeId) 
   
   RETURN;
END