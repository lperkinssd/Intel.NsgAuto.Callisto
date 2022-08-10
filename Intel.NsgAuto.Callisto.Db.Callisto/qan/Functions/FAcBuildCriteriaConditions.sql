-- ===============================================================================================================    
-- Author       : bricschx    
-- Create date  : 2020-11-13 11:10:42.940    
-- Description  : Gets auto checker build criteria conditions    
-- Example      : SELECT * FROM [qan].[FAcBuildCriteriaConditions](NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL);    
-- ===============================================================================================================    
CREATE FUNCTION [qan].[FAcBuildCriteriaConditions]    
(    
   @Id                      BIGINT       = NULL    
 , @UserId                  VARCHAR(25)  = NULL -- if not null will restrict results to user's allowed design families    
 , @BuildCriteriaId         BIGINT       = NULL    
 , @AttributeTypeId         INT          = NULL    
 , @AttributeTypeName       VARCHAR(50)  = NULL    
 , @ComparisonOperationId   INT          = NULL    
 , @ComparisonOperationKey  VARCHAR(25)  = NULL    
 , @Value                   VARCHAR(MAX) = NULL    
)  

RETURNS @AcBuildCriteriaConditions TABLE
(
     [Id]  bigint,
    [BuildCriteriaId] bigint,
    [AttributeTypeId]   int,
    [AttributeTypeName]  varchar(50),
    [AttributeTypeNameDisplay]  varchar(50),
    [AttributeTypeDataTypeId]    int,
    [AttributeTypeDataTypeName]  varchar(50),
    [AttributeTypeDataTypeNameDisplay]  varchar(50),
    [AttributeTypeCreatedBy]   varchar(25),
    [AttributeTypeCreatedOn]   datetime2,
    [AttributeTypeUpdatedBy]    varchar(25),
    [AttributeTypeUpdatedOn]    datetime2,
    [ComparisonOperationId]    int,
    [ComparisonOperationKey]    varchar(25),
    [ComparisonOperationKeyTreadstone] varchar(20),
    [ComparisonOperationName]   varchar(50),
    [ComparisonOperationOperandTypeId]   int,
    [ComparisonOperationOperandTypeName] varchar(50),
    [Value]  varchar(4000),
    [CreatedBy]   varchar(25),
    [CreatedOn]  datetime2,
    [UpdatedBy]   varchar(25),
    [UpdatedOn]  datetime2
)

AS
BEGIN
       DECLARE @Process Varchar(MAX);  
       SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK)   
     INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
       
        INSERT INTO @AcBuildCriteriaConditions
       SELECT    
    C.[Id]    
  , C.[BuildCriteriaId]    
  , C.[AttributeTypeId]    
  , A.[Name] AS [AttributeTypeName]    
  , A.[NameDisplay] AS [AttributeTypeNameDisplay]    
  , A.[DataTypeId] AS [AttributeTypeDataTypeId]    
  , D.[Name] AS [AttributeTypeDataTypeName]    
  , D.[NameDisplay] AS [AttributeTypeDataTypeNameDisplay]    
  , A.[CreatedBy] AS [AttributeTypeCreatedBy]    
  , A.[CreatedOn] AS [AttributeTypeCreatedOn]    
  , A.[UpdatedBy] AS [AttributeTypeUpdatedBy]    
  , A.[UpdatedOn] AS [AttributeTypeUpdatedOn]    
  , C.[ComparisonOperationId]    
  , O.[Key] AS [ComparisonOperationKey]    
  , O.[KeyTreadstone] AS [ComparisonOperationKeyTreadstone]    
  , O.[Name] AS [ComparisonOperationName]    
  , O.[OperandTypeId] AS [ComparisonOperationOperandTypeId]    
  , OT.[Name] AS [ComparisonOperationOperandTypeName]    
  , C.[Value]    
  , C.[CreatedBy]    
  , C.[CreatedOn]    
  , C.[UpdatedBy]    
  , C.[UpdatedOn]    
 FROM [qan].[AcBuildCriteriaConditions]                                                                                  AS C  WITH (NOLOCK)    
 LEFT OUTER JOIN [qan].[AcAttributeTypes]                                                                                AS A  WITH (NOLOCK) ON (A.[Id] = C.[AttributeTypeId])    
 LEFT OUTER JOIN [ref].[AcAttributeDataTypes]                                                                            AS D  WITH (NOLOCK) ON (D.[Id] = A.[DataTypeId])    
 LEFT OUTER JOIN [ref].[AcComparisonOperations]                                                                          AS O  WITH (NOLOCK) ON (O.[Id] = C.[ComparisonOperationId])    
 LEFT OUTER JOIN [ref].[AcOperandTypes]                                                                                  AS OT WITH (NOLOCK) ON (OT.[Id] = O.[OperandTypeId])    
 LEFT OUTER JOIN [qan].[FAcBuildCriterias](NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) AS BC ON (BC.[Id] = C.[BuildCriteriaId])    
 WHERE (@Id                     IS NULL OR C.[Id] = @Id)    
   --AND (@UserId                 IS NULL OR BC.[DesignFamilyName] IN (SELECT [Process] FROM [qan].[UserProcessRoles] WITH (NOLOCK) WHERE [IdSid] = @UserId))    
   AND (@UserId                 IS NULL OR BC.[DesignFamilyName] = @Process ) 
   AND (@BuildCriteriaId        IS NULL OR C.[BuildCriteriaId] = @BuildCriteriaId)    
   AND (@AttributeTypeId        IS NULL OR C.[AttributeTypeId] = @AttributeTypeId)    
   AND (@AttributeTypeName      IS NULL OR A.[Name] = @AttributeTypeName)    
   AND (@ComparisonOperationId  IS NULL OR C.[ComparisonOperationId] = @ComparisonOperationId)    
   AND (@ComparisonOperationKey IS NULL OR O.[Key] = @ComparisonOperationKey)    
   AND (@Value                  IS NULL OR C.[Value] = @Value) 
   RETURN;
END