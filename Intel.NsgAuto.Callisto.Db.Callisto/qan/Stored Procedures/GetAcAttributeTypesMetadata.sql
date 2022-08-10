-- =======================================================================  
-- Author       : bricschx  
-- Create date  : 2020-11-12 10:16:49.850  
-- Description  : Gets attribute types and metadata  
-- Example      : EXEC [qan].[GetAcAttributeTypesMetadata] 'bricschx';  
-- =======================================================================  
CREATE PROCEDURE [qan].[GetAcAttributeTypesMetadata]  
(  
   @UserId VARCHAR(25)  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 -- record set #1: attribute types  
 SELECT * FROM [qan].[FAcAttributeTypes](NULL, NULL, NULL,@UserId) ORDER BY [Name];  
  
 -- record set #2: attribute data types  
 SELECT * FROM [qan].[FAcAttributeDataTypes](NULL, NULL) ORDER BY [Id];  
  
 -- record set #3: comparison operations  
 SELECT * FROM [qan].[FAcComparisonOperations](NULL, NULL, 0, NULL, NULL) ORDER BY [Id];  
  
 -- record set #4: data type comparison operations  
 SELECT * FROM [ref].[AcAttributeDataTypeOperations] WITH (NOLOCK) ORDER BY [AttributeDataTypeId], [ComparisonOperationId];  
  
END
