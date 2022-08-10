-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Delete Product Ownership
-- =============================================
CREATE PROCEDURE [qan].[DeleteProductOwnership] 
	-- Add the parameters for the stored procedure here
	    @Succeeded bit OUTPUT,
		@Message varchar(500) OUTPUT,
		@UserId varchar(25),
		@Id int
AS
BEGIN

	 DECLARE @process				   VARCHAR(25)
	 SET @process =                     (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                          INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
     DECLARE @On    DATETIME2(7) = GETUTCDATE()
	 UPDATE QAN.ProductOwnershipsContacts SET ISACTIVE=0, UpdatedBy=@UserId, UpdatedOn=@On where OwnershipId=@Id
	 UPDATE QAN.ProductOwnerships SET ISACTIVE=0, UpdatedBy=@UserId, UpdatedOn=@On where Id=@Id
	 EXECUTE [qan].[GetProductOwnerships] @UserId, @process

	 SET @Message = 'Successful'
	 SET @Succeeded = 1
END