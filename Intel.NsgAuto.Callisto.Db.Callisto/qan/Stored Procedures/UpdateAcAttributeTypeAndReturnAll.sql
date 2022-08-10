-- ==========================================================================================================  
-- Author       : bricschx  
-- Create date  : 2020-11-16 09:56:13.600  
-- Description  : Updates an auto checker attribute type and returns all of them  
-- Example      : DECLARE @Message VARCHAR(500);  
--                EXEC [qan].[UpdateAcAttributeType] NULL, @Message OUTPUT, 'bricschx', 1, 'test', 'Test', 0;  
--                PRINT @Message; -- should print 'Data type is invalid: 0'  
-- ==========================================================================================================  
CREATE PROCEDURE [qan].[UpdateAcAttributeTypeAndReturnAll]  
(  
   @Succeeded BIT OUTPUT  
 , @Message VARCHAR(500) OUTPUT  
 , @UserId VARCHAR(25)  
 , @Id INT  
 , @Name VARCHAR(50)  
 , @NameDisplay VARCHAR(50)  
 , @DataTypeId INT  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SET @Succeeded = 0;  
 SET @Message = NULL;  
  
 EXEC [qan].[UpdateAcAttributeType] @Succeeded OUTPUT, @Message OUTPUT, @UserId, @Id, @Name, @NameDisplay, @DataTypeId;  
  
 SELECT * FROM [qan].[FAcAttributeTypes](NULL, NULL, NULL,@UserId) ORDER BY [Name], [Id];  
  
END
