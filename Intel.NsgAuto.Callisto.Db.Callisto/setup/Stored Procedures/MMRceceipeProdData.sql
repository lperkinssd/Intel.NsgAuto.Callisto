


-- =================================================================================
-- Author       : jayapa1x
-- Create date  : 2021-11-23 16:38:31.110
-- Description  : Creates the initial Account Clients
-- Example      : EXEC [setup].[CreateAccountClients] 'jayapa1x';
--                SELECT * FROM [qan].[AccountClients];
-- =================================================================================
CREATE PROCEDURE [setup].[MMRceceipeProdData]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	
	EXECUTE [setup].[CreateAccountContacts]  @By	
	EXECUTE [setup].[CreateAccountRoles] @By
	EXECUTE [setup].[AccountContactRoles] @By	
	EXECUTE  [setup].[CreateAccountClients]  @By	
	EXECUTE [setup].[CreateAccountCustomers] @By	
	EXECUTE [setup].[CreateAccountRoles] @By	
	EXECUTE [setup].[CreateAccountSubsidiaries] @By
	EXECUTE [setup].[CreateAccountOwnerships]  @By
	EXECUTE [setup].[CreateAccountOwnershipsContacts]  @By
	
	EXECUTE [setup].[CreateProductContacts] @By
	EXECUTE [setup].[CreateProductRoles] @By	
	EXECUTE [setup].[CreateProductContactRoles] @By	
	EXECUTE [setup].[CreateProductLifeCycleStatuses] @By	
	EXECUTE [setup].[CreateProductPlatforms] @By	
	EXECUTE [setup].[CreateProductTypes] @By	
	EXECUTE [setup].[CreateProductBrandNames] @By	
	EXECUTE [setup].[CreateProductCodeNames] @By
	EXECUTE [setup].[CreateProductOwnerships] @By
	EXECUTE [setup].[CreateProductOwnershipsContacts] @By


	EXECUTE  [setup].[CreateEmailTemplateBodyXsls] 
	EXECUTE  [setup].[CreateEmailTemplates] 
	
END