
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [qan].[CreateAccountContactRoles] 
	@ContactId varchar(4000) OUTPUT,
	@ContactName varchar(4000),
	@RoleName nvarchar(4000),
	@By nvarchar(25)

AS
BEGIN
	Declare @RoleId int=null	
	Declare @On Datetime2(7) = GetutcDate()

	;WITH DATA as (SELECT  value as Name FROM  STRING_SPLIT(@ContactName, ';') )
	    MERGE qan.AccountContacts TARGET
	    USING data Source ON LTRIM(RTRIM(Source.Name)) =TARGET.Name		 
		WHEN not matched by TARGET then 
		   INSERT (Name,IsActive,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn) values (LTRIM(RTRIM(Source.Name)),1,'Jayapa1x',GetUTCDATE(),'Jayapa1x',GetUTCDATE());

	SELECT @RoleId = Id FROM ref.AccountRoles WHERE Name=@RoleName	

	
	;WITH DATA as (select AC.Id as Id,@RoleId as RoleId from qan.AccountContacts AC 
															 JOIN (SELECT  LTRIM(RTRIM(value)) as Name FROM  STRING_SPLIT(@ContactName, ';')) Contacts on Contacts.Name = AC.Name) 
		  MERGE QAN.ACCOUNTCONTACTROLES TARGET
		  USING DATA SOURCE ON SOURCE.Id = TARGET.CONTACTID and SOURCE.ROLEID =TARGET.ROLEID
		  WHEN NOT MATCHED BY TARGET THEN
		       INSERT ([RoleId] ,[ContactId] ,[IsActive]  ,[CreatedBy]  ,[CreatedOn]  ,[UpdatedBy]  ,[UpdatedOn]) VALUES (Source.Id,Source.RoleId,1,@By,@On,@By,@On);
		     	

	
	SELECT @ContactId=STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(ACR.Id,'N/A')), ',') 
	   FROM qan.AccountContacts AC 
	   INNER JOIN (SELECT  LTRIM(RTRIM(value)) as Name FROM  STRING_SPLIT(@ContactName, ';')) Contacts ON Contacts.Name = AC.Name
	   INNER JOIN QAN.AccountContactRoles ACR on ACR.ContactId = AC.ID and ACR.RoleId = @RoleId
	   		 	  
END