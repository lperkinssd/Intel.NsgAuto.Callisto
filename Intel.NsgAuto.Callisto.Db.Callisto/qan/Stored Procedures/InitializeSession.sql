
-- =============================================================
-- Author:		jkurian
-- Create date: 2020-06-25 09:11:40.297
-- Description:	Creates a new wafer disclosure request
--				EXEC [qan].[InitializeSession] 'sessionid' 'jkurian'
-- =============================================================
CREATE PROCEDURE [qan].[InitializeSession]
(
	  @UserIdSid varchar(255)
	, @SessionId varchar(500)
    , @Users [qan].[IUsers] READONLY
	, @UserRoles [qan].[IUserRoles] READONLY
	, @UserProcessRoles [qan].[IUserProcessRoles] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @UserIdSid varchar(255);

	BEGIN TRY					
		-- Merge users to the users table
		MERGE [qan].[Users] AS TRG
		USING
		(
			SELECT 
				 [WWID] 
				,[IdSid]
				,[Name] 
				,[Email]
			FROM @Users
		) AS SRC
		ON
		(
			TRG.[WWID] = SRC.[WWID] AND
			TRG.[IdSid]= SRC.[IdSid] AND
			TRG.[Name] = SRC.[Name] AND
			TRG.[Email]= SRC.[Email]
		)
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT  ([WWID] ,[IdSid],[Name],[Email])
				VALUES (SRC.[WWID], SRC.[IdSid], SRC.[Name], [Email]);

		--SET @UserIdSid = (SELECT [IdSid] FROM @Users);
		-- Create the user session record
		INSERT INTO [qan].[UserSessions] 
           ([IdSid]
           ,[SessionId]
           ,[LoginTime])
		VALUES
           (@UserIdSid
           ,@SessionId
           ,GETUTCDATE());

	END TRY
	BEGIN CATCH
		-- 
		--ROLLBACK TRAN;
		--SET @ErrorMessage = ERROR_MESSAGE();
		--SET @ErrorSeverity = ERROR_SEVERITY();
		--SET @ErrorState = ERROR_STATE();
		--RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH	
	
	--BEGIN TRAN;
	BEGIN TRY
		-- SYNC THE USER ROLES
		MERGE [qan].[UserRoles] AS TRG
		USING
		(
			SELECT 
				[IdSid], [WWID], [RoleName] 
			FROM @UserRoles
		) AS SRC
		ON
		(
			TRG.[IdSid] = SRC.[IdSid] AND
			TRG.[WWID] = SRC.[WWID] AND
			TRG.[RoleName] = SRC.[RoleName]
		)
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT  ([IdSid], [WWID], [RoleName])
				VALUES (SRC.[IdSid], SRC.[WWID], SRC.[RoleName])
		WHEN NOT MATCHED BY SOURCE AND TRG.[IdSid] = @UserIdSid  THEN
			DELETE;

		--COMMIT TRAN;
	END TRY
	BEGIN CATCH
		-- 
		--ROLLBACK TRAN;
		--SET @ErrorMessage = ERROR_MESSAGE();
		--SET @ErrorSeverity = ERROR_SEVERITY();
		--SET @ErrorState = ERROR_STATE();
		--RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH	
	
	BEGIN TRY
		-- SYNC THE USER PROCESS ROLES
		MERGE [qan].[UserProcessRoles] AS TRG
		USING
		(
			SELECT 
				upr.[IdSid], upr.[WWID], upr.[RoleName], pr.[Process] 
			FROM @UserProcessRoles upr
				INNER JOIN [qan].[ProcessRoles] pr (NOLOCK)
					ON upr.[RoleName] = pr.[RoleName] 
		) AS SRC
		ON
		(
			TRG.[IdSid] = SRC.[IdSid] AND
			TRG.[WWID] = SRC.[WWID] AND
			TRG.[RoleName] = SRC.[RoleName] AND
			TRG.[Process] = SRC.[Process]
		)
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT  ([IdSid], [WWID], [RoleName], [Process])
				VALUES (SRC.[IdSid], SRC.[WWID], SRC.[RoleName], SRC.[Process])
		WHEN NOT MATCHED BY SOURCE AND TRG.[IdSid] = @UserIdSid  THEN
			DELETE;

		--COMMIT TRAN;
	END TRY
	BEGIN CATCH
		-- 
		--ROLLBACK TRAN;
		--SET @ErrorMessage = ERROR_MESSAGE();
		--SET @ErrorSeverity = ERROR_SEVERITY();
		--SET @ErrorState = ERROR_STATE();
		--RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH	

	-- Return the user process roles
	SELECT 
		  upr.[RoleName]
		, p.[Name]
		, p.[IsActive]
		, p.[CreatedBy]
		, p.[CreatedOn]
		, p.[UpdatedBy]
		, p.[UpdatedOn]
	FROM [qan].[UserProcessRoles] upr (NOLOCK)
		INNER JOIN [qan].[ProcessRoles] pr (NOLOCK)
			ON upr.[RoleName] = pr.[RoleName]
		INNER JOIN [ref].[Processes] p (NOLOCK)
			ON pr.[Process] = p.[Name]
	WHERE upr.[IdSid] = @UserIdSid
	AND p.IsActive = 1;

END