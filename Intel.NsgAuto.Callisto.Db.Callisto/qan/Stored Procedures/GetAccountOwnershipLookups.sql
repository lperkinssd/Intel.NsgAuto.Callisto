


-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get all Product Ownership Lookup Data
-- =============================================
CREATE PROCEDURE [qan].[GetAccountOwnershipLookups] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(25)
)
AS
BEGIN
	
	 SELECT * FROM ref.AccountClients (NOLOCK) WHERE IsActive = 1 and Process = @process
	
	 SELECT * FROM  ref.AccountCustomers (NOLOCK) WHERE IsActive = 1 and Process = @process
	
	 SELECT * FROM  ref.AccountSubsidiaries (NOLOCK) WHERE IsActive = 1 and Process = @process	

	SELECT * FROM  ref.AccountProducts (NOLOCK) WHERE IsActive = 1 and Process = @process

	SELECT * FROM  ref.AccountRoles (NOLOCK) WHERE Process=@process and IsActive = 1
	 


END