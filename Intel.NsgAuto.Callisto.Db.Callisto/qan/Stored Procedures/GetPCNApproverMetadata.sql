

-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get all Product Ownership Lookup Data
-- =============================================
CREATE PROCEDURE [qan].[GetPCNApproverMetadata] 
(
	  @UserId VARCHAR(25),
	--  @process VARCHAR(255),
	  @IsActive BIT = 1
)
AS
BEGIN
	DECLARE @Process Varchar(MAX);
	SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                  INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
		 	 
	Execute [qan].[GetPCNApproverLookups] @UserId, @Process

END