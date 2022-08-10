


-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get all Product Ownership Lookup Data
-- =============================================
CREATE PROCEDURE [qan].[GetPCNManagerLookups] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(255),
	  @IsActive BIT = 1
)
AS
BEGIN
		 	 
	 SELECT distinct Id, Name FROM  qan.ProductCodeNames (NOLOCK) WHERE IsActive = @IsActive and Process = @process

	 SELECT distinct Id, Name FROM  ref.AccountCustomers (NOLOCK) WHERE IsActive = @IsActive and Process = @process

	 Select Name, Id from(

	 Select 'All' as Name, 0 as Id
	 UNION
	 SELECT  Name,Id FROM  ref.AccountRoles (NOLOCK) WHERE IsActive = @IsActive and PCN = 1 and Name like '%Manager%' and Process = @process
	 UNION
	 SELECT  Name, Id FROM  ref.ProductRoles (NOLOCK) WHERE IsActive = @IsActive and PCN = 1 and Name like '%Manager%' and Process = @process) Source
	 Order by Id asc

END