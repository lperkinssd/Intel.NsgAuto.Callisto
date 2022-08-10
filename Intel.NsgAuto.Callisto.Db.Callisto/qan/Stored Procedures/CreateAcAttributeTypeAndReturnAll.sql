
-- ============================================================================================  
-- Author       : bricschx  
-- Create date  : 2020-11-12 10:46:02.880  
-- Description  : Creates a new auto checker attribute type and returns all of them  
-- Example      : EXEC [qan].[CreateAcAttributeTypeAndReturnAll] 'bricschx', 'test', 'Test', 1  
-- ============================================================================================  
CREATE PROCEDURE [qan].[CreateAcAttributeTypeAndReturnAll]  
(  
   @Succeeded BIT OUTPUT  
 , @Message VARCHAR(500) OUTPUT  
 , @UserId VARCHAR(25)  
 , @Name VARCHAR(50)  
 , @NameDisplay VARCHAR(50)  
 , @DataTypeId INT  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @Id INT;  
  
 SET @Succeeded = 0;  
 SET @Message = NULL;  
  
 EXEC [qan].[CreateAcAttributeType] @Id OUTPUT, @Message OUTPUT, @UserId, @Name, @NameDisplay, @DataTypeId;  
  
 IF (@Id IS NOT NULL) SET @Succeeded = 1;  
  
 SELECT * FROM [qan].[FAcAttributeTypes](NULL, NULL, NULL,@UserId) ORDER BY [Name], [Id];  
  
END
