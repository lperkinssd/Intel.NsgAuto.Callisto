
-- =============================================
-- Author:		jakemurx
-- Create date: 2021-03-19 16:11:20.861
-- Description:	Create Qual Filter exceptions
-- =============================================
CREATE PROCEDURE [npsg].[CreateOdmQualFilterExceptions] 
	-- Add the parameters for the stored procedure here
	  @UserId varchar(50),
	  @Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE LotCursor CURSOR FOR SELECT DISTINCT MediaIPN, SLot 
								 FROM [npsg].[OdmQualFilters] WITH (NOLOCK)
								 WHERE [ScenarioId] = @Id; 

	DECLARE @LotId varchar(50), @MediaIpn varchar(50), @myInt integer
	DECLARE @OdmIdPlaceHolder INT = 0;
	DECLARE @MatScenarioId INT = (SELECT [MatVersion] FROM [npsg].[OdmQualFilterScenarios]  WITH (NOLOCK) WHERE [Id] = @Id);

	OPEN LotCursor
    FETCH NEXT FROM LotCursor INTO  @MediaIpn, @LotId
	
	WHILE @@FETCH_STATUS =0
    BEGIN
		
		--select @LotId, @MediaIpn
		-- @OdmIdPlaceHolder is used here because MAT does not have ODM Id available
		INSERT INTO [npsg].[OdmQualFilterNonQualifiedMediaExceptions] (
			 [ScenarioId]
			, [OdmId]
			, [DesignId]
			, [SCodeMMNumber]
			, [MediaIPN]
			, [SLot]
			)
			SELECT DISTINCT @Id, @OdmIdPlaceHolder, [Design_Id], [Scode], [Media_IPN], @LotId 
			FROM [npsg].[MAT]  WITH (NOLOCK) WHERE [MatVersion] = @MatScenarioId AND [Media_IPN] = @MediaIpn
			EXCEPT
			SELECT DISTINCT @Id, @OdmIdPlaceHolder, [DesignId], [SCode], [MediaIPN], @LotId 
			FROM [npsg].[OdmQualFilters]  WITH (NOLOCK) WHERE [SLot] = @LotId AND [ScenarioId] = @Id

		FETCH NEXT FROM LotCursor INTO @MediaIpn, @LotId

	END
	CLOSE LotCursor
	DEALLOCATE LotCursor
	   	 
	-- Update the ODM ID based on the S-Lot
	UPDATE [npsg].[OdmQualFilterNonQualifiedMediaExceptions]
		SET [OdmId] = nqm.[OdmId]
	FROM  [npsg].[OdmQualFilterNonQualifiedMediaExceptions] ex
		INNER JOIN [npsg].[OdmQualFilters] nqm 
			ON ex.[SLot] = nqm.[SLot]
	WHERE nqm.[ScenarioId] = @Id
		AND ex.[ScenarioId] = @Id
		AND ex.[OdmId] = @OdmIdPlaceHolder;

	-- Merge all the non qualified media exceptions into [npsg].[OdmQualFilters]  as qualified data records
	DECLARE @QualifiedCategoryId INT = (SELECT oqfc.Id FROM [ref].[OdmQualFilterCategories] oqfc WITH (NOLOCK) WHERE oqfc.[Name] = 'Qualified');
		MERGE [npsg].[OdmQualFilters] AS TRG
		USING
		(
			SELECT
				 exc.[ScenarioId]
			   , exc.[OdmId]
			   , exc.[DesignId]
			   , exc.[SCodeMMNumber]
			   , exc.[MediaIPN]
			   , exc.[SLot]
			FROM  [npsg].[OdmQualFilterNonQualifiedMediaExceptions] exc WITH (NOLOCK)  
			WHERE exc.[ScenarioId] = @Id
		) AS SRC
		ON
		(
			TRG.[OdmId] = SRC.[OdmId] AND
			TRG.[DesignId] = SRC.[DesignId] AND
			TRG.[SCode] = SRC.[SCodeMMNumber] AND
			TRG.[MediaIPN] = SRC.[MediaIPN] AND
			TRG.[SLot] = SRC.[SLot] AND
			TRG.[ScenarioId] = @Id
		)
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (
					[ScenarioId]
				   ,[OdmId]
				   ,[DesignId]
				   ,[SCode]
				   ,[MediaIPN]
				   ,[SLot]
				   ,[OdmQualFilterCategoryId])
				VALUES (
					  @Id
					, SRC.[OdmId]
					, SRC.[DesignId]
					, SRC.[SCodeMMNumber]
					, SRC.[MediaIPN]
					, SRC.[SLot]
					, @QualifiedCategoryId -- This is qualified because it is coming from qulified exception list
					)
		WHEN MATCHED THEN
			UPDATE SET [OdmQualFilterCategoryId] = @QualifiedCategoryId; -- This is qualified because it is coming from qulified exception list

END