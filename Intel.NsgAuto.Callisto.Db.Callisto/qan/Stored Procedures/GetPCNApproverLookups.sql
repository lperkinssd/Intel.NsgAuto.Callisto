

-- =============================================
-- Author:		JAYAPA1x
-- Create date: 2021-11-02 23:38:14.143
-- Description:	Get all Product Ownership Lookup Data
-- =============================================
CREATE PROCEDURE [qan].[GetPCNApproverLookups] 
(
	  @UserId VARCHAR(25),
	  @process VARCHAR(255),
	  @IsActive BIT = 1
)
AS
BEGIN
		 	 
	 SELECT distinct Id, Name FROM  qan.ProductCodeNames (NOLOCK) WHERE IsActive = @IsActive and Process=@process

	 SELECT distinct Id, Name FROM  ref.AccountCustomers (NOLOCK) WHERE IsActive = @IsActive and Process=@process

END