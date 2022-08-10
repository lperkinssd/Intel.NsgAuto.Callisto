
-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Delete Product Ownership
-- =============================================
CREATE PROCEDURE [qan].[DeleteAccountOwnership] 
	-- Add the parameters for the stored procedure here
	    @Succeeded BIT OUTPUT,
		@Message VARCHAR(500) OUTPUT,
		@UserId VARCHAR(25),
		@Id INT
AS
BEGIN
	DECLARE @On    DATETIME2(7) = GETUTCDATE()
	DECLARE @RoleName varchar(25)
	-- New ProductCodeName Insert/Get the ProductCodeId
	 
	DECLARE @process				   VARCHAR(25)
	SET @process =                     (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                          INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
	 update QAN.AccountOwnershipsContacts set IsActive=0, UpdatedBy=@UserId, UpdatedOn=@On WHERE OwnershipId=@Id
	 update QAN.AccountOwnerships set IsActive=0, UpdatedBy=@UserId, UpdatedOn=@On WHERE Id=@Id

	 EXECUTE [qan].[GetAccountOwnershipContacts] @UserId,@process
	 EXECUTE [qan].[GetAccountOwnerships] @UserId, @process

	 SET @Message = 'Successful'
	 SET @Succeeded = 1
END