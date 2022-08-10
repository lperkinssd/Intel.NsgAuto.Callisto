

-- ===============================================================================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get Product Ownership Lookups Data and Product Ownership data
-- ================================================================================================
CREATE PROCEDURE [qan].[GetAccountOwnershipMetadata] 
(
	  @UserId VARCHAR(25)
	 
)
AS
BEGIN
     DECLARE @Process Varchar(MAX);
	 SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                  INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
     EXECUTE [qan].[GetAccountOwnershipLookups] @UserId ,@Process
	 EXECUTE [qan].[GetAccountOwnershipContacts] @UserId,@Process
	 EXECUTE [qan].[GetAccountOwnerships] @UserId ,@Process
	 
	 


END