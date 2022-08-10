


-- =============================================================
-- Author                    : jkurian
-- Create date : 2021-03-01 15:40:06.638
-- Description : Create new ODM Qual Filter records for this scenarioId
-- EXEC [npsg].[CreateOdmQualFilters] 50, 'jkurian'
-- =============================================================
CREATE PROCEDURE [npsg].[CreateOdmQualFilters]
(
            @ScenarioId INT,
            @UserId varchar(50)
)
AS
BEGIN

            ------ If qual filter results exist for the current scenario id, then do not create it again!
            ----DECLARE @QualFilterResultsCount INT = (SELECT COUNT(*) FROM [npsg].[OdmQualFilters] oqf WITH (NOLOCK) WHERE oqf.ScenarioId = @ScenarioId);
            ----IF @QualFilterResultsCount > 0
            ----BEGIN
            ----      -- TO DO: Log the activity into a logging table
            ----      Return;
            ----END

            DECLARE @On datetime2(7) = GETUTCDATE();
			DECLARE @designFamilyId INT;
			SELECT @designFamilyId = Id FROM [ref].[DesignFamilies] WITH (NOLOCK) WHERE Name = 'NAND';

            -- Get all the data set ids
            DECLARE @PrfVersion INT,
                                    @MatVersion INT,
                                    @OdmWipSnapshotVersion INT,
                                    @LotShipSnapshotVersion INT,
                                    @LotDispositionSnapshotVersion INT,
                                    @LatestManualDispositionsVersion INT,
                                    @CreatedBy VARCHAR(25),
                                    @CreatedOn datetime2(7);
            -- Get all versions for the scenario to create the scenario model that will be used for Qual filter Logic
            SELECT
                        @PrfVersion = [PrfVersion]
                        ,@MatVersion = [MatVersion]
                        ,@OdmWipSnapshotVersion = [OdmWipSnapshotVersion]
                        ,@LotShipSnapshotVersion = [LotShipSnapshotVersion]
                        ,@LotDispositionSnapshotVersion = [LotDispositionSnapshotVersion]
                        ,@LatestManualDispositionsVersion = [ManualDispositionsVersion]
                        ,@CreatedBy = [CreatedBy]
                        ,@CreatedOn = [CreatedOn]
            FROM [npsg].[OdmQualFilterScenarios] WITH (NOLOCK)
            WHERE [Id] = @ScenarioId;

            ----SELECT @PrfVersion, @MatVersion, @OdmWipSnapshotVersion, @LotShipSnapshotVersion, @LotDispositionSnapshotVersion, @CreatedBy, @CreatedOn

            -- Got the latest MAT table attribute Id
            -- Got the latest PRF table attribute Id
            -- Get PRF for the scenario - that is, latest
            -- Get MAT for the scenario - that is, latest
            -- Create a temp table for MAT and get only the latest MAT so that the SLots Media Attributes table will join and form the data set faster
            CREATE TABLE #MediaAttributes(
                        [MatVersion] [int] NOT NULL,
                        [Design_Id] [varchar](50) NULL,
                        [Scode] [varchar](50) NULL,
                        [Cell_Revision] [varchar](50) NULL,
                        [Major_Probe_Program_Revision] [varchar](50) NULL,
                        [Probe_Revision] [varchar](50) NULL,
                        [Burn_Tape_Revision] [varchar](50) NULL,
                        [Custom_Testing_Required] [varchar](50) NULL,
                        [Custom_Testing_Required2] [varchar](50) NULL,
                        [Product_Grade] [varchar](100) NULL,
                        [Prb_Conv_Id] [varchar](100) NULL,
                        [Fab_Conv_Id] [varchar](100) NULL,
                        [Fab_Excr_Id] [varchar](100) NULL,
                        [Media_Type] [varchar](100) NULL,
                        [Media_IPN] [varchar](50) NULL,
                        [Device_Name] [varchar](100) NULL,
                        [Reticle_Wave_Id] [varchar](100) NULL,
                        [Fab_Facility] [varchar](100) NOT NULL,
            );          
            INSERT INTO #MediaAttributes
           ([MatVersion]
           ,[Design_Id]
           ,[Scode]
           ,[Cell_Revision]
           ,[Major_Probe_Program_Revision]
           ,[Probe_Revision]
           ,[Burn_Tape_Revision]
           ,[Custom_Testing_Required]
           ,[Custom_Testing_Required2]
           ,[Product_Grade]
           ,[Prb_Conv_Id]
           ,[Fab_Conv_Id]
           ,[Fab_Excr_Id]
           ,[Media_Type]
           ,[Media_IPN]
           ,[Device_Name]
           ,[Reticle_Wave_Id]
           ,[Fab_Facility]
                           )
                        SELECT DISTINCT
                                    m.[MatVersion]
           , LTRIM(RTRIM(m.[Design_Id]))
           , LTRIM(RTRIM(m.[Scode]))
           , m.[Cell_Revision]
           , m.[Major_Probe_Program_Revision]
           , m.[Probe_Revision]
           , m.[Burn_Tape_Revision]
           , m.[Custom_Testing_Required]
           , m.[Custom_Testing_Required2]
           , m.[Product_Grade]
           , m.[Prb_Conv_Id]
           , m.[Fab_Conv_Id]
           , m.[Fab_Excr_Id]
           , m.[Media_Type]
           , LTRIM(RTRIM(m.[Media_IPN]))
           , m.[Device_Name]
           , m.[Reticle_Wave_Id]
           , m.[Fab_Facility]
                        FROM [npsg].[MAT] m WITH (NOLOCK)
						JOIN [qan].[Products] pt WITH (NOLOCK)
							ON m.Design_Id = pt.Name
							AND pt.DesignFamilyId = @designFamilyId
							AND pt.IsActive = 1
                        WHERE m.MatVersion = @MatVersion;

            ------SELECT * FROM #MediaAttributes;
            ------ Get latest Wip Snapshots data
            ----IF OBJECT_ID('tempdb..#LatestWipSnapshots') IS NOT NULL 
            ----BEGIN
            ----      TRUNCATE TABLE #LatestWipSnapshots;
            ----END
            ----ELSE
            ----BEGIN
            ----      CREATE TABLE #LatestWipSnapshots(
            ----                    media_lot_id VARCHAR(255)
            ----                  , intel_part_number   VARCHAR(255)
            ----                  , subcon_name          VARCHAR(255)
            ----      );
            ----END

            ----INSERT INTO #LatestWipSnapshots
            ----(
            ----        media_lot_id
            ----      , intel_part_number
            ----      , subcon_name          
            ----)
            ----SELECT DISTINCT
            ----        media_lot_id
            ----      , intel_part_number
            ----      , subcon_name
            ----FROM [npsg].[OdmWipSnapshots] WITH (NOLOCK)
            ----WHERE [Version] = @OdmWipSnapshotVersion

            DECLARE @OdmId INT;
            DECLARE @OdmNameVar varchar(255);
            IF CURSOR_STATUS('global','OdmCursor')>=-1  BEGIN  DEALLOCATE OdmCursor END

            DECLARE OdmCursor CURSOR FOR 
                        SELECT [Id], [Name] FROM [ref].[Odms] WITH (NOLOCK);
                        --ORDER BY [Id]; -- WHERE [Name] = 'PEGATRON';
            OPEN OdmCursor
            FETCH NEXT FROM OdmCursor INTO @OdmId, @OdmNameVar

            WHILE @@FETCH_STATUS =0
            BEGIN
                        
                        -- Truncate the previous qual filters

                        -- join PRF and MAT tables to identify which SCODEs are being built at each ODM.
                        IF OBJECT_ID('tempdb..#ActiveSCodes') IS NOT NULL 
                        BEGIN
                                    TRUNCATE TABLE #ActiveSCodes;
                        END
                        ELSE
                        BEGIN
                                    CREATE TABLE #ActiveSCodes(
                                      SCode                       VARCHAR(50)
                                    , MediaIPN      VARCHAR(50)
                                    , OdmDesc      VARCHAR(50)
                                    , OdmName    VARCHAR(255)
                                    , OdmId                       INT
                        );
                        END

                        INSERT INTO #ActiveSCodes
                        (
                                      SCode                       
                                    , MediaIPN      
                                    , OdmDesc      
                                    , OdmName
                                    , OdmId
                        )
                        SELECT DISTINCT
                                      LTRIM(RTRIM(mat.Scode)) AS SCode
                                    , LTRIM(RTRIM(mat.Media_IPN)) AS MediaIPN
                                    , prf.Odm_desc AS OdmDesc
                                    , odm.[Name] AS OdmName
                                    , odm.Id AS  OdmId
                        FROM #MediaAttributes mat WITH (NOLOCK)
                                    INNER JOIN [npsg].[PRFDCR] prf WITH (NOLOCK)
                                                ON mat.Scode = prf.MM_Number
                                    INNER JOIN [npsg].[OdmNameMappings] onm WITH (NOLOCK)
                                                ON prf.Odm_Desc = onm.OdmDescription
                                    INNER JOIN [ref].[Odms] odm WITH (NOLOCK)
                                                ON onm.MappedOdmId = odm.Id
                        WHERE 
                                                prf.PrfVersion = @PrfVersion
                                    AND mat.MatVersion = @MatVersion
                                    AND odm.[Name] = @OdmNameVar;

                        --SELECT @OdmNameVar;   
                        --SELECT * FROM #ActiveSCodes WITH (NOLOCK) ORDER BY SCode ASC, MediaIPN ASC, OdmDesc ASC;
                        -- Data Looks same - good.

                        --PRINT 'Truncating #ActiveSLots for ' + @OdmNameVar              
                        -- Get the list of all the BOH inventory at the ODMs based on the Media_IPNs found in the active SCodes list.
                        IF OBJECT_ID('tempdb..#ActiveSLots') IS NOT NULL 
                        BEGIN
                                    TRUNCATE TABLE #ActiveSLots;
                        END
                        ELSE
                        BEGIN
                                    CREATE TABLE #ActiveSLots(
                                                  SCode                       VARCHAR(50)
                                                , SLot               VARCHAR(255)
                                                , MediaIPN      VARCHAR(255)
                                                , SubConName           VARCHAR(255)
                                                , OdmName    VARCHAR(255)
                                                , OdmId                       INT
                                    );
                        END

                        INSERT INTO #ActiveSLots
                        (
                                      SCode                       
                                    , SLot               
                                    , MediaIPN      
                                    , SubConName
                                    , OdmName
                                    , OdmId
                        )
                        SELECT DISTINCT 
                                      asco.SCode AS SCode
                                    , owbs.media_lot_id AS SLot
                                    , asco.MediaIPN AS MediaIPN
                                    , owbs.subcon_name AS SubConName
                                    , asco.[OdmName] AS OdmName
                                    , asco.[OdmId] AS OdmId
                        FROM #ActiveSCodes asco WITH (NOLOCK)
                                    INNER JOIN [npsg].[OdmWipBohSnapshots] owbs WITH (NOLOCK)
                                                ON asco.OdmName = owbs.subcon_name
                                                AND asco.MediaIPN = owbs.intel_part_number
                                    ----INNER JOIN #LatestWipSnapshots lws WITH (NOLOCK)
                                    ----      ON asco.OdmName = lws.subcon_name
                                    ----      AND owbs.media_lot_id = lws.media_lot_id
                        WHERE asco.OdmName = @OdmNameVar; 

                        --PRINT 'Loaded #ActiveSLots for ' + @OdmNameVar
                        --SELECT * FROM #ActiveSLots WITH (NOLOCK);
                        ---- Data Looks same - good.

                        -- Now let's get the shipment details on the lots that we are after
                        -- Join the media lot list obtained from the ODM BOH to the OSAT Ship data. 
                        -- This gives the complete attribute list for each lot. We need to write a union query  
                        -- because if the lot is shipped from Amkor then the S_Lot is in the shipping_label_lot column and 
                        -- if it shipped from PTI it is in the lot_id column
    
                        -- First, get shipment data for SLots for which the lot id was gone to lot ship lot_id column
                        IF OBJECT_ID('tempdb..#SLotShipments') IS NOT NULL 
                        BEGIN
                                    TRUNCATE TABLE #SLotShipments;
                        END
                        ELSE
                        BEGIN
                                    CREATE TABLE #SLotShipments(
                                                  SCode                                                                                               VARCHAR(50)
                                                , SLot                                                                                       VARCHAR(255)
                                                , MediaIPN                                                                              VARCHAR(50)
                                                , SubConName                                                                       VARCHAR(255)
                                                , OdmName                                                                            VARCHAR(255)
                                                , OdmId                                                                                               INT
                                                , DesignId                                                                                VARCHAR(10) 
                                                , probe_program_rev                                                 VARCHAR(MAX)
                                                , Major_Probe_Program_Revision                 VARCHAR(MAX)
                                                , burn_tape_revision                                      VARCHAR(MAX)
                                                , Custom_Testing_Required                          VARCHAR(MAX)
                                                , product_grade                                                                     VARCHAR(MAX)
                                                , prb_conv_id                                                             VARCHAR(MAX)
                                                , reticle_wave_id                                                        VARCHAR(MAX)
                                                , cell_revision                                                             VARCHAR(MAX)
                                                , cmos_revision                                                                      VARCHAR(MAX)
                                                , fab_conv_id                                                              VARCHAR(MAX)
                                                , fab_excr_id                                                               VARCHAR(MAX)
                                    );
                        END
                        INSERT INTO #SLotShipments
                        (
                                      Scode                                    
                                    , SLot
                                    , MediaIPN
                                    , SubConName
                                    , OdmName
                                    , OdmId
                                    , DesignId                                            
                                    , probe_program_rev             
                                    , Major_Probe_Program_Revision
                                    , burn_tape_revision
                                    , Custom_Testing_Required
                                    , product_grade
                                    , prb_conv_id
                                    , reticle_wave_id
                                    , cell_revision
                                    , cmos_revision
                                    , fab_conv_id
                                    , fab_excr_id               
                        )           
                        SELECT DISTINCT 
                                      asl.SCode                                                      AS SCode
                                    , asl.SLot                                                         AS SLot
                                    , asl.MediaIPN                                    AS MediaIPN
                                    , asl.SubConName                             AS SubConName
                                    , asl.OdmName                                               AS OdmName
                                    , asl.OdmId                                                     AS OdmId
                                    , lss.design_id                                     AS DesignId                                                    
                                    , lss.probe_program_rev                   
                                    , lss.major_probe_prog_rev  AS Major_Probe_Program_Revision
                                    , lss.burn_tape_revision
                                    , lss.custom_testing_reqd     AS Custom_Testing_Required
                                    , lss.product_grade
                                    , lss.prb_conv_id
                                    , lss.reticle_wave_id
                                    , lss.cell_revision
                                    , lss.cmos_revision
                                    , lss.fab_conv_id
                                    , lss.fab_excr_id
                        FROM #ActiveSLots asl WITH (NOLOCK)
                                    INNER JOIN [npsg].[OdmLotShipSnapshots] lss WITH (NOLOCK)
                                    --INNER JOIN [TREADSTONENPSGPRD].treadstone.[dbo].[lot_ship] lss WITH (NOLOCK)
                                                ON   asl.SLot = lss.media_lot_id
                                    WHERE lss.[Version] = @LotShipSnapshotVersion
                                                AND location_type='TST'
                                                AND asl.OdmName = @OdmNameVar;

                        --SELECT * FROM #SLotShipments WITH (NOLOCK) ORDER BY SCode ASC,SLot ASC,MediaIPN ASC, SubConName ASC;
                        -- DATA MATCHES. ALL GOOD. 
                        --PRINT 'Loaded #SLotShipments';
                        --SELECT COUNT(*)  FROM #SLotShipments;

                        /*
                        * Mark all S-Lots from Manual Dispsositions as non-qualified. 
                        */
                        IF OBJECT_ID('tempdb..#ManualLotDispositions') IS NOT NULL 
                        BEGIN
                                    TRUNCATE TABLE #ManualLotDispositions;
                        END
                        ELSE
                        BEGIN
                                    CREATE TABLE #ManualLotDispositions(
                                                [Version] [int] NOT NULL,
                                                [SLot] [varchar](255) NOT NULL,
                                                [IntelPartNumber] [varchar](50) NOT NULL,
                                                [LotDispositionReasonId] [int] NOT NULL,
                                                [Notes] [varchar](max) NULL,
                                                [LotDispositionActionId] [int] NOT NULL,
                                                [CreatedOn] [datetime2](7) NOT NULL,
                                                [CreatedBy] [varchar](255) NOT NULL,
                                                [UpdatedOn] [datetime2](7) NOT NULL,
                                                [UpdatedBy] [varchar](255) NOT NULL
                                                );
                        END
                        INSERT INTO #ManualLotDispositions
                                                            ([Version]
                                                            ,[SLot]
                                                            ,[IntelPartNumber]
                                                            ,[LotDispositionReasonId]
                                                            ,[Notes]
                                                            ,[LotDispositionActionId]
                                                            ,[CreatedOn]
                                                            ,[CreatedBy]
                                                            ,[UpdatedOn]
                                                            ,[UpdatedBy])
                                                SELECT DISTINCT
                                                                        [Version]
                                                              , [SLot]
                                                              , [IntelPartNumber]
                                                              , [LotDispositionReasonId]
                                                              , [Notes]
                                                              , [LotDispositionActionId]
                                                              , [CreatedOn]
                                                              , [CreatedBy]
                                                              , [UpdatedOn]
                                                              , [UpdatedBy]
                                                  FROM [npsg].[OdmManualDispositions] WITH (NOLOCK)
                                                  WHERE [Version] = @LatestManualDispositionsVersion;

                        -- START manual dispsotions handling
                        IF OBJECT_ID('tempdb..#SLotsWithManualLotDispositions') IS NOT NULL 
                        BEGIN
                                    TRUNCATE TABLE #SLotsWithManualLotDispositions;
                        END
                        ELSE
                        BEGIN
                                    CREATE TABLE #SLotsWithManualLotDispositions(
                                      SCode                                                                                               VARCHAR(50)
                                    , SLot                                                                                       VARCHAR(255)
                                    , MediaIPN                                                                              VARCHAR(50)
                                    , SubConName                                                                       VARCHAR(255)
                                    , OdmName                                                                            VARCHAR(255)
                                    , OdmId                                                                                               INT
                                    , DesignId                                                                                VARCHAR(10) 
                                    , probe_program_rev                                                 VARCHAR(MAX)
                                    , Major_Probe_Program_Revision                 VARCHAR(MAX)
                                    , burn_tape_revision                                      VARCHAR(MAX)
                                    , Custom_Testing_Required                          VARCHAR(MAX)
                                    , product_grade                                                                     VARCHAR(MAX)
                                    , prb_conv_id                                                             VARCHAR(MAX)
                                    , reticle_wave_id                                                        VARCHAR(MAX)
                                    , cell_revision                                                             VARCHAR(MAX)
                                    , cmos_revision                                                                      VARCHAR(MAX)
                                    , fab_conv_id                                                              VARCHAR(MAX)
                                    , fab_excr_id                                                               VARCHAR(MAX)
                                    , [LotDispositionReasonId]                            [int] NOT NULL
                                    , [Notes]                                                                                  [varchar](MAX) NULL
                                    , [LotDispositionActionId]                             [int] NOT NULL
                                    , [CreatedOn]                                                             [datetime2](7) NOT NULL
                                    , [CreatedBy]                                                              [varchar](255) NOT NULL
                                    , [UpdatedOn]                                                            [datetime2](7) NOT NULL
                                    , [UpdatedBy]                                                             [varchar](255) NOT NULL
                        );
                        END
                        INSERT INTO #SLotsWithManualLotDispositions
                        (
                                      SCode                                                           
                                    , SLot                                                   
                                    , MediaIPN                                          
                                    , SubConName                                   
                                    , OdmName                                        
                                    , OdmId                                                           
                                    , DesignId                                            
                                    , probe_program_rev             
                                    , Major_Probe_Program_Revision     
                                    , burn_tape_revision  
                                    , Custom_Testing_Required  
                                    , product_grade                                 
                                    , prb_conv_id                         
                                    , reticle_wave_id                    
                                    , cell_revision                         
                                    , cmos_revision                                  
                                    , fab_conv_id                          
                                    , fab_excr_id
                                    , [LotDispositionReasonId]    
                                    , [Notes]                                                          
                                    , [LotDispositionActionId]     
                                    , [CreatedOn]                                     
                                    , [CreatedBy]                                      
                                    , [UpdatedOn]                                    
                                    , [UpdatedBy]                                     
                        )
                        SELECT DISTINCT
                                      sls.SCode                                                      
                                    , sls.SLot                                                         
                                    , sls.MediaIPN                                     
                                    , sls.SubConName                              
                                    , sls.OdmName                                               
                                    , sls.OdmId                                                      
                                    , sls.DesignId                                      
                                    , sls.probe_program_rev                   
                                    , sls.Major_Probe_Program_Revision           
                                    , sls.burn_tape_revision        
                                    , sls.Custom_Testing_Required         
                                    , sls.product_grade                            
                                    , sls.prb_conv_id                                
                                    , sls.reticle_wave_id               
                                    , sls.cell_revision                                
                                    , sls.cmos_revision                             
                                    , sls.fab_conv_id                                
                                    , sls.fab_excr_id
                                    , mld.[LotDispositionReasonId]        
                                    , mld.[Notes]                                                   
                                    , mld.[LotDispositionActionId]          
                                    , mld.[CreatedOn]                                          
                                    , mld.[CreatedBy]                                           
                                    , mld.[UpdatedOn]                                         
                                    , mld.[UpdatedBy]                                          
                        FROM #ManualLotDispositions mld  WITH (NOLOCK)
                                    INNER JOIN #SLotShipments sls WITH (NOLOCK)
                                                ON mld.SLot = sls.SLot
                        WHERE sls.OdmName = @OdmNameVar;

                        -- Create non qualified media records for those with bad burn tape revision
                        INSERT INTO [npsg].[OdmQualFilters]
                                       ([ScenarioId]
                                       ,[OdmId]
                                       ,[DesignId]
                                       ,[SCode]
                                       ,[MediaIPN]
                                       ,[SLot]
                                       ,[OdmQualFilterCategoryId])
                                       SELECT 
                                                              @ScenarioId                                                            AS ScenarioId
                                                            , slwmld.OdmId                                                                      AS OdmId
                                                            , slwmld.DesignId                                                       AS DesignId
                                                            , slwmld.SCode                                                                      AS SCode
                                                            , slwmld.MediaIPN                                                     AS MediaIPN
                                                            , slwmld.SLot                                                              AS SLot
                                                            , slwmld.[LotDispositionActionId]     AS OdmQualFilterCategoryId -- NOTE: ActionId & Category Id should be the same as for 'non-qualified'
                                                FROM #SLotsWithManualLotDispositions slwmld WITH (NOLOCK);
                        --SELECT *  FROM [npsg].[OdmQualFilters] WITH (NOLOCK);

                        -- Create automatic lot disposition records for the manually dispostioned S-Lots
                        INSERT INTO [npsg].[OdmQualFilterLotDispositions]
                                       ([ScenarioId]
                                       ,[OdmQualFilterId]
                                       ,[LotDispositionReasonId]
                                       ,[Notes]
                                       ,[LotDispositionActionId]
                                       ,[CreatedOn]
                                       ,[CreatedBy]
                                       ,[UpdatedOn]
                                       ,[UpdatedBy])
                        SELECT
                                                @ScenarioId                                                 AS [ScenarioId]
                                       , oqf.Id                                                                                  AS [OdmQualFilterId]
                                       , swmld.LotDispositionReasonId    AS [LotDispositionReasonId]
                                       , swmld.Notes                                                          AS [Notes]
                                       , swmld.LotDispositionActionId     AS [LotDispositionActionId]
                                       , swmld.CreatedOn                                     AS [CreatedOn]
                                       , swmld.CreatedBy                                      AS [CreatedBy]
                                       , swmld.UpdatedOn                                    AS [UpdatedOn]
                                       , swmld.UpdatedBy                                     AS [UpdatedBy]
                        FROM [npsg].[OdmQualFilters] oqf WITH (NOLOCK)
                                    INNER JOIN #SLotsWithManualLotDispositions swmld WITH (NOLOCK)
                                                ON      oqf.OdmId = swmld.OdmId                
                                                            AND oqf.DesignId =swmld.DesignId 
                                                            AND oqf.SCode =swmld.SCode                    
                                                            AND oqf.MediaIPN =swmld.MediaIPN          
                                                            AND oqf.SLot =swmld.SLot
                        WHERE oqf.ScenarioId = @ScenarioId
                                    AND oqf.OdmId = @OdmId;

                        -- Delete all records from #SLotShipments where S-Lots are manually dispositioned
                        DELETE FROM #SLotShipments  WHERE SLot IN (SELECT SLot FROM #SLotsWithManualLotDispositions);
                        --SELECT * FROM [npsg].[OdmQualFilterLotDispositions] WITH (NOLOCK) 
                        --SELECT COUNT(*) FROM #SLotShipments

                        -- END manual dispositions handling


                        -- Let's do some data cleansing!
                        -- For burn_tape_revision data is expected to be numeric, but often found to be a non numeric.
                        -- So, we will automatically mark them as non-qualified in QAN.QUALFILTERS with qual filter category as Non Qualified
                        -- Also, we will create a lot dispostion record qan. generated by system with lot disposition reason as 'Bad Data Quality' 
                        -- and lot disposition action as Marked Non Qualified with created by 'system' & notes stating that Non numeric value for burn tape revision : <value>
                        -- After creating the above entries, we will remove these records from #SLotShipments so that we don't use in them in the further processings

                        -- Said all that, let's find the records with burn_tape_revision as non-numeric
                        
                        /*
                        * Mark all S-Lots with Bad Burn Tape Revisions as non-qualified. 
                        */
                        IF OBJECT_ID('tempdb..#SLotsWithBadBurnTapeRevision') IS NOT NULL 
                        BEGIN
                                    TRUNCATE TABLE #SLotsWithBadBurnTapeRevision;
                        END
                        ELSE
                        BEGIN
                                    CREATE TABLE #SLotsWithBadBurnTapeRevision(
                                      SCode                                                                                               VARCHAR(50)
                                    , SLot                                                                                       VARCHAR(255)
                                    , MediaIPN                                                                              VARCHAR(50)
                                    , SubConName                                                                       VARCHAR(255)
                                    , OdmName                                                                            VARCHAR(255)
                                    , OdmId                                                                                               INT
                                    , DesignId                                                                                VARCHAR(10) 
                                    --, probe_program_rev                                                          VARCHAR(MAX)
                                    --, Major_Probe_Program_Revision              VARCHAR(MAX)
                                    --, burn_tape_revision                                               VARCHAR(MAX)
                                    --, Custom_Testing_Required                                   VARCHAR(MAX)
                                    --, product_grade                                                                  VARCHAR(MAX)
                                    --, prb_conv_id                                                                      VARCHAR(MAX)
                                    --, reticle_wave_id                                                     VARCHAR(MAX)
                                    --, cell_revision                                                                      VARCHAR(MAX)
                                    --, cmos_revision                                                                   VARCHAR(MAX)
                                    --, fab_conv_id                                                                       VARCHAR(MAX)
                                    --, fab_excr_id                                                            VARCHAR(MAX)
                        );
                        END
                        INSERT INTO #SLotsWithBadBurnTapeRevision
                        (
                                      SCode                                                           
                                    , SLot                                                   
                                    , MediaIPN                                          
                                    , SubConName                                   
                                    , OdmName                                        
                                    , OdmId                                                           
                                    , DesignId                                            
                                    --, probe_program_rev                      
                                    --, Major_Probe_Program_Revision  
                                    --, burn_tape_revision           
                                    --, Custom_Testing_Required           
                                    --, product_grade                              
                                    --, prb_conv_id                                  
                                    --, reticle_wave_id                 
                                    --, cell_revision                                  
                                    --, cmos_revision                               
                                    --, fab_conv_id                                   
                                    --, fab_excr_id                        
                        )
                        SELECT DISTINCT
                                      SCode                                                           
                                    , SLot                                                   
                                    , MediaIPN                                          
                                    , SubConName                                   
                                    , OdmName                                        
                                    , OdmId                                                           
                                    , DesignId                                            
                                    --, probe_program_rev                      
                                    --, Major_Probe_Program_Revision  
                                    --, burn_tape_revision           
                                    --, Custom_Testing_Required           
                                    --, product_grade                              
                                    --, prb_conv_id                                  
                                    --, reticle_wave_id                 
                                    --, cell_revision                                  
                                    --, cmos_revision                               
                                    --, fab_conv_id                                   
                                    --, fab_excr_id                        
                        FROM #SLotShipments sls WITH (NOLOCK)
                        WHERE (
								(ISNUMERIC(sls.burn_tape_revision) <> 1 AND sls.DesignId NOT IN ('N38A', 'N38B'))
								OR (ISNUMERIC(SUBSTRING(sls.burn_tape_revision, 1, 3)) <> 1 AND sls.DesignId IN ('N38A', 'N38B'))
							  )
                              AND sls.OdmName = @OdmNameVar;
                        --PRINT 'Loaded #SLotsWithBadBurnTapeRevision';
                        --SELECT * FROM #SLotsWithBadBurnTapeRevision WITH (NOLOCK);

                        -- Remove manual dispositions from the bad burn tape s-lots
                        DELETE FROM #SLotsWithBadBurnTapeRevision WHERE SLot IN (SELECT SLot FROM #SLotsWithManualLotDispositions);

                        -- Create these as non-qualified media and then create lot disposition reords and then delete them from SLotShipments
                        DECLARE @OdmQualFilterCategoryId INT = (SELECT oqfc.Id FROM [ref].[OdmQualFilterCategories] oqfc WITH (NOLOCK) WHERE oqfc.[Name] = 'Non Qualified');
                        -- Create non qualified media records for those with bad burn tape revision
                        INSERT INTO [npsg].[OdmQualFilters]
                                       ([ScenarioId]
                                       ,[OdmId]
                                       ,[DesignId]
                                       ,[SCode]
                                       ,[MediaIPN]
                                       ,[SLot]
                                       ,[OdmQualFilterCategoryId])
                                       SELECT 
                                                              @ScenarioId                                    AS ScenarioId
                                                            , slwbttr.OdmId                                              AS OdmId
                                                            , slwbttr.DesignId                               AS DesignId
                                                            , slwbttr.SCode                                               AS SCode
                                                            , slwbttr.MediaIPN                             AS MediaIPN
                                                            , slwbttr.SLot                                      AS SLot
                                                            , @OdmQualFilterCategoryId AS OdmQualFilterCategoryId
                                                FROM #SLotsWithBadBurnTapeRevision slwbttr WITH (NOLOCK);
                        --PRINT 'Loaded [npsg].[OdmQualFilters] with #SLotsWithBadBurnTapeRevision';
                        --SELECT *  FROM [npsg].[OdmQualFilters] WITH (NOLOCK);

                        -- Create automatic lot disposition records for those with bad burn tape revision
                        DECLARE @LotDispositionReasonId INT = (SELECT ldr.[Id] FROM [ref].[OdmLotDispositionReasons] ldr WITH (NOLOCK) WHERE ldr.[Description] = 'Bad Data Quality (Moved to Non-Qualified)');
                        DECLARE @LotDispositionActionId INT = (SELECT olda.[Id] FROM [ref].[OdmLotDispositionActions] olda WITH (NOLOCK) WHERE olda.ActionName = 'Marked_Non_Qualified');
                        INSERT INTO [npsg].[OdmQualFilterLotDispositions]
                                       ([ScenarioId]
                                       ,[OdmQualFilterId]
                                       ,[LotDispositionReasonId]
                                       ,[Notes]
                                       ,[LotDispositionActionId]
                                       ,[CreatedOn]
                                       ,[CreatedBy]
                                       ,[UpdatedOn]
                                       ,[UpdatedBy])
                        SELECT
                                                @ScenarioId                                     AS [ScenarioId]
                                       , oqf.Id                                                                      AS [OdmQualFilterId]
                                       , @LotDispositionReasonId AS [LotDispositionReasonId]
                                       , 'Marked non qualified by system due to non numeric burn tape revision value(s)'            AS [Notes]
                                       , @LotDispositionActionId AS [LotDispositionActionId]
                                       , oqfs.CreatedOn                                         AS [CreatedOn]
                                       , 'system'                                                      AS [CreatedBy]
                                       , @On                                                                       AS [UpdatedOn]
                                       , 'system'                                                      AS [UpdatedBy]
                        FROM [npsg].[OdmQualFilters] oqf WITH (NOLOCK)
                                    INNER JOIN [npsg].[OdmQualFilterScenarios] oqfs  WITH (NOLOCK)
                                                ON oqf.ScenarioId = oqfs.Id
                                    INNER JOIN #SLotsWithBadBurnTapeRevision swbbtr WITH (NOLOCK)
                                                ON  oqf.SLot = swbbtr.SLot
                                                AND oqf.OdmId          = swbbtr.OdmId
                                                AND oqf.DesignId      = swbbtr.DesignId
                                                AND oqf.SCode          = swbbtr.SCode
                        WHERE oqf.ScenarioId = @ScenarioId
                                    AND oqfs.Id = @ScenarioId
                                    AND oqf.OdmId = @OdmId;

                        -- Delete all records from #SLotShipments where burn tape revision is non-numeric
                        DELETE FROM #SLotShipments  WHERE SLot IN (SELECT SLot FROM #SLotsWithBadBurnTapeRevision);
                        --SELECT * FROM [npsg].[OdmQualFilterLotDispositions] WITH (NOLOCK) 
                        --SELECT COUNT(*) FROM #SLotShipments
                        -- Data matched. All good

                        

                        -- THE Actual logic
                        DECLARE @Cur_OdmName                                                              VARCHAR(255)
                        DECLARE @Cur_OdmId                                                                                INT                  
                        DECLARE @Cur_DesignId                                                                 varchar(10);                                                                
                        DECLARE @Cur_SCode                                                                                 varchar(25);    
                        DECLARE @Cur_SLot                                                                        VARCHAR(25);                        
                        DECLARE @Cur_MediaIPN                                                                varchar(25);    
                        DECLARE @Cur_DeviceName                                                                       VARCHAR(MAX);                                                
                        DECLARE @Cur_Cell_Revision                                                          VARCHAR(MAX);
                        DECLARE @Cur_Major_Probe_Program_Revision   VARCHAR(MAX);
                        --DECLARE @Cur_Probe_Revision                                                   VARCHAR(MAX);
                        DECLARE @Cur_Burn_Tape_Revision                                              VARCHAR(MAX);
                        DECLARE @Cur_Custom_Testing_Required            VARCHAR(MAX);
                        --DECLARE @Cur_Custom_Testing_Required2                   VARCHAR(MAX);
                        DECLARE @Cur_Product_Grade                                                       VARCHAR(MAX);
                        --DECLARE @Cur_Prb_Conv_Id                                                        VARCHAR(MAX);
                        DECLARE @Cur_Fab_Conv_Id                                                          VARCHAR(MAX);
                        DECLARE @Cur_Fab_Excr_Id                                                VARCHAR(MAX);
                        DECLARE @Cur_Media_Type                                                            VARCHAR(MAX);
                        DECLARE @Cur_Reticle_Wave_Id                                        VARCHAR(MAX);
                        --DECLARE @Cur_Fab_Facility                                                         VARCHAR(MAX);

                        DECLARE @QualFilterQuery VARCHAR(MAX);
                        --PRINT 'Create or Truncated #NonQualifiedSLots for : ' + @OdmNameVar;

                        IF OBJECT_ID('tempdb..#NonQualifiedSLots') IS NOT NULL 
                        BEGIN
                                    TRUNCATE TABLE #NonQualifiedSLots;
                        END
                        ELSE
                        BEGIN
                                    CREATE TABLE #NonQualifiedSLots(
                                      ScenarioId                                                    INT                  
                                    , OdmId                                                                                   INT
                                    , DesignId                                                                    VARCHAR(10)
                                    , SCode                                                                                   VARCHAR(50)
                                    , MediaIPN                                                                  VARCHAR(50)
                                    , SLot                                                                           VARCHAR(255)
                                    , OdmQualFilterCategoryId               INT
                                    , OdmName                                                                VARCHAR(255)
                                    , Query                                                                        VARCHAR(MAX)
                        );
                        END

                        DECLARE SLOTSMATCURSOR CURSOR
                        FOR
                                    SELECT DISTINCT
                                                  m.Design_Id                                                              
                                                , m.Scode                                                                                
                                                , m.Media_IPN 
                                                , m.Device_Name                                                       
                                                , m.Cell_Revision                                                        
                                                , m.Major_Probe_Program_Revision 
                                                --, m.Probe_Revision                                     
                                                , m.Burn_Tape_Revision                                
                                                , m.Custom_Testing_Required                      
                                                --, m.Custom_Testing_Required2                 
                                                , m.Product_Grade                                                     
                                                --, m.Prb_Conv_Id                                                     
                                                , m.Fab_Conv_Id                                                        
                                                , m.Fab_Excr_Id                                                          
                                                , m.Media_Type                                                         
                                                , m.Reticle_Wave_Id                                      
                                                --, m.Fab_Facility                                           
                                    --FROM #SLotsMediaAttributes;
                                    FROM #MediaAttributes m;
                                    --ORDER BY Design_Id, Scode, Media_IPN;

                        OPEN SLOTSMATCURSOR
                        FETCH NEXT FROM SLOTSMATCURSOR INTO 
                                                  @Cur_DesignId                                                                    
                                                , @Cur_SCode                                                                        
                                                , @Cur_MediaIPN       
                                                , @Cur_DeviceName                                                  
                                                , @Cur_Cell_Revision                                                
                                                , @Cur_Major_Probe_Program_Revision     
                                                --, @Cur_Probe_Revision                                          
                                                , @Cur_Burn_Tape_Revision                         
                                                , @Cur_Custom_Testing_Required               
                                                --, @Cur_Custom_Testing_Required2                      
                                                , @Cur_Product_Grade                                                          
                                                --, @Cur_Prb_Conv_Id                                                          
                                                , @Cur_Fab_Conv_Id                                                 
                                                , @Cur_Fab_Excr_Id                                                  
                                                , @Cur_Media_Type                                                  
                                                , @Cur_Reticle_Wave_Id                                           
                                                --, @Cur_Fab_Facility
            
                        -- Loop through all MAT records, MAT is for qualified media S-Lots inverse the logic since we are trying to find the non-qualified Media SLots. 
                        WHILE @@FETCH_STATUS = 0
                                    BEGIN
                                                --PRINT 'Entering the loop';
                                                --PRINT @Cur_DesignId + ' ' + @Cur_MediaIPN + ' ' + @Cur_SCode;
                        
                                                -- Create the query crieteria & Execute the dynamic SQL to identify the non qualified SLots
                                                SET @QualFilterQuery = ' INSERT INTO #NonQualifiedSLots (ScenarioId,OdmId,DesignId,SCode,MediaIPN,SLot,OdmQualFilterCategoryId,OdmName)
                                                                                                                                                SELECT '+ CAST(@ScenarioId AS VARCHAR(10)) +' AS ScenarioId, '+ CAST(@OdmId AS VARCHAR(10)) +' AS OdmId, DesignId, SCode, MediaIPN, SLot, '+ CAST(@OdmQualFilterCategoryId AS VARCHAR(10)) +' AS OdmQualFilterCategoryId, OdmName 
                                                                                                                                                FROM #SLotShipments WITH (NOLOCK) 
                                                                                                                                                WHERE DesignId='''+ @Cur_DesignId +''' AND OdmName='''+ @OdmNameVar +'''  AND MediaIPN='''+ @Cur_MediaIPN +''' AND SCode='''+ @Cur_SCode +''' AND ( ';

                                                -- attach major_probe_prog_rev criteria
                                                SET @QualFilterQuery = @QualFilterQuery + [npsg].[OdmParseMajorProbeProgRev](@Cur_Major_Probe_Program_Revision);             
                                                -- attach burn tape revision criteria
                                                SET @QualFilterQuery = @QualFilterQuery + ' OR ' + [npsg].[OdmParseBurnTapeRevisionWithDesignId](@Cur_DesignId, @Cur_Burn_Tape_Revision);            
                                                -- attach cell  revision criteria
                                                SET @QualFilterQuery = @QualFilterQuery + ' OR ' + [npsg].[OdmParseCellRevision](@Cur_Cell_Revision);
                                                -- attach fab  Excursion Id criteria
                                                SET @QualFilterQuery = @QualFilterQuery + ' OR ' + [npsg].[OdmParseFabExcrId](@Cur_Fab_Excr_Id);
                                                -- attach Prod Grade criteria
                                                SET @QualFilterQuery = @QualFilterQuery + ' OR ' + [npsg].[OdmParseProductGrade](@Cur_Product_Grade);
                                                -- attach fab conv id criteria
                                                SET @QualFilterQuery = @QualFilterQuery + ' OR ' + [npsg].[OdmParseFabConvId](@Cur_Fab_Conv_Id);
                                                -- attach reticle wave id criteria
                                                SET @QualFilterQuery = @QualFilterQuery + ' OR ' + [npsg].[OdmParseReticleWaveId](@Cur_Reticle_Wave_Id);
                                                -- attach custom test required criteria
                                                SET @QualFilterQuery = @QualFilterQuery + ' OR ' + [npsg].[OdmParseCustomTestingReqd](@Cur_Custom_Testing_Required);
                                                -- close the or conditions block
                                                SET @QualFilterQuery = @QualFilterQuery + ' );';

                                                --PRINT @QualFilterQuery; 
                          
                                                -- Execute the qual filter query
                                                EXEC(@QualFilterQuery);     
                        
                                                ---- Update the SQL query for traceability
                                                --UPDATE  #NonQualifiedSLots 
                                                -- SET Query = @QualFilterQuery
                                                --WHERE ScenarioId = @ScenarioId
                                                --         AND DesignId = @Cur_DesignId
                                                --         AND MediaIPN = @Cur_MediaIPN
                                                --         AND SCode    = @Cur_SCode

                                                FETCH NEXT FROM SLOTSMATCURSOR INTO 
                                                                          @Cur_DesignId                                                                    
                                                                        , @Cur_SCode                                                                        
                                                                        , @Cur_MediaIPN       
                                                                        , @Cur_DeviceName                                                  
                                                                        , @Cur_Cell_Revision                                                
                                                                        , @Cur_Major_Probe_Program_Revision     
                                                                        --, @Cur_Probe_Revision                                          
                                                                        , @Cur_Burn_Tape_Revision                         
                                                                        , @Cur_Custom_Testing_Required               
                                                                        --, @Cur_Custom_Testing_Required2                      
                                                                        , @Cur_Product_Grade                                                          
                                                                        --, @Cur_Prb_Conv_Id                                                          
                                                                        , @Cur_Fab_Conv_Id                                                 
                                                                        , @Cur_Fab_Excr_Id                                                  
                                                                        , @Cur_Media_Type                                                  
                                                                        , @Cur_Reticle_Wave_Id                                           
                                                                        --, @Cur_Fab_Facility

                                    END
                        CLOSE SLOTSMATCURSOR
                        DEALLOCATE SLOTSMATCURSOR

                        --PRINT 'Insert non-qualified records into [npsg].[OdmQualFilters] ';
                        INSERT INTO [npsg].[OdmQualFilters] 
                                    ([ScenarioId]
                                    ,[OdmId]
                                    ,[DesignId]
                                    ,[SCode]
                                    ,[MediaIPN]
                                    ,[SLot]
                                    ,[OdmQualFilterCategoryId])
                        SELECT ScenarioId
                                    , OdmId
                                    , DesignId
                                    , SCode
                                    , MediaIPN
                                    , SLot
                                    , OdmQualFilterCategoryId 
                        FROM #NonQualifiedSLots WITH (NOLOCK);

                        SET @LotDispositionReasonId = (SELECT ldr.[Id] FROM [ref].[OdmLotDispositionReasons] ldr WITH (NOLOCK) WHERE ldr.[Description] = 'Media Attributes Condition(s) Not Met (Marked Non-Qualified)');
                        INSERT INTO [npsg].[OdmQualFilterLotDispositions]
                                       ([ScenarioId]
                                       ,[OdmQualFilterId]
                                       ,[LotDispositionReasonId]
                                       ,[Notes]
                                       ,[LotDispositionActionId]
                                       ,[CreatedOn]
                                       ,[CreatedBy]
                                       ,[UpdatedOn]
                                       ,[UpdatedBy])
                                    SELECT 
                                                  nqs.ScenarioId                                                         AS [ScenarioId]
                                                , oqf.Id                                                                         AS [OdmQualFilterId]
                                                , @LotDispositionReasonId                           AS [LotDispositionReasonId]
                                                --, CONVERT(VARCHAR, @On, 7) + ': Marked non qualified by system since media attribute conditions are not met'       AS [Notes]
                                                , 'Marked non qualified by system since media attribute conditions are not met'     AS [Notes]
                                                , @LotDispositionActionId                            AS [LotDispositionActionId]
                                                , @On                                                                                      AS [CreatedOn]
                                                , 'system'                                                                                 AS [CreatedBy]
                                                , @On                                                                                      AS [UpdatedOn]
                                                , 'system'                                                                                 AS [UpdatedBy]
                                    FROM #NonQualifiedSLots nqs WITH (NOLOCK)
                                    INNER JOIN [npsg].[OdmQualFilters] oqf WITH (NOLOCK)
                                                ON nqs.ScenarioId = oqf.ScenarioId
                                                            AND nqs.DesignId = oqf.DesignId
                                                            AND nqs.OdmId = oqf.OdmId
                                                            AND nqs.SCode = oqf.SCode
                                                            AND nqs.SLot = oqf.SLot
                                                            AND nqs.MediaIPN = oqf.MediaIPN
                                                            AND nqs.OdmQualFilterCategoryId = oqf.OdmQualFilterCategoryId
                                    WHERE oqf.ScenarioId = @ScenarioId;

                        FETCH NEXT FROM OdmCursor INTO @OdmId, @OdmNameVar
            END

            CLOSE OdmCursor
            DEALLOCATE OdmCursor
                        
            --This step adds the qualified lot list into a table.
            --execute [npsg].[GetCanUseLot]

            --This step adds the qualified lot list into a table.
            EXECUTE [npsg].[CreateOdmQualFilterExceptions] @UserId, @ScenarioId

            -- TAKE PREVIOUS SCENARIO LOT DISPOSITIONS AND MERGE IT INTO CURRENT SCENARIO
            --EXECUTE [npsg].[UpdateOdmQualFilterLotDispositions] @UserId, @ScenarioId
            --DECLARE @PrevScenarioId INT = ISNULL(@ScenarioId, 0) - 1;
            DECLARE @PrevScenarioId INT = (SELECT ISNULL(MAX(Id), 0) FROM [npsg].[OdmQualFilterScenarios] WHERE Id < @ScenarioId)

            IF @PrevScenarioId > 0
            BEGIN
                        -- If the user has marked a lot as qualified, it means that we need to carry that user lot disposition action to next.
                        -- By default the system generated lot dispositions are marked no qualified. User may mark any as qualified. 
                        -- so if we get all the qualified ones, then it is marked as qualified manually by a user. 
                        -- so we get the id for 
                        DECLARE @LotDispositionQualifiedActionId INT = (SELECT olda.[Id] FROM [ref].[OdmLotDispositionActions] olda WITH (NOLOCK) WHERE olda.ActionName = 'Marked_Qualified');
                        CREATE TABLE #PastLotDispositions
                        (
                                      [LotDispositionId] [int]
                                    , [LotDispositionScenarioId] [int] NULL
                                    , [LotDispositionOdmQualFilterId] [int] NOT NULL
                                    , [LotDispositionReasonId] [int] NOT NULL
                                    , [Notes] [varchar](MAX) NULL
                                    , [LotDispositionActionId] [int] NULL 
                                    , [OdmQualFilterId] [int]
                                    , [OdmId] [int] NULL
                                    , [DesignId] [varchar](200) NULL
                                    , [SCode] [varchar](200) NULL
                                    , [MediaIPN] [varchar](200) NULL
                                    , [SLot] [varchar](255) NULL
                                    , [OdmQualFilterCategoryId] [int]     
                                    , [CreatedOn]                                                             [datetime2](7) NOT NULL
                                    , [CreatedBy]                                                              [varchar](255) NOT NULL
                                    , [UpdatedOn]                                                            [datetime2](7) NOT NULL
                                    , [UpdatedBy]                                                             [varchar](255) NOT NULL                 
                        );
                        INSERT INTO #PastLotDispositions
                        (
                                      [LotDispositionId]
                                    , [LotDispositionScenarioId] 
                                    , [LotDispositionOdmQualFilterId]
                                    , [LotDispositionReasonId]
                                    , [Notes]
                                    , [LotDispositionActionId] 
                                    , [OdmQualFilterId]
                                    , [OdmId]
                                    , [DesignId]
                                    , [SCode]
                                    , [MediaIPN]
                                    , [SLot]
                                    , [OdmQualFilterCategoryId]
                                    , [CreatedOn]
                                    , [CreatedBy]
                                    , [UpdatedOn]
                                    , [UpdatedBy]
                        )
                        SELECT
                                      ld.Id AS [LotDispositionId]
                                    , ld.ScenarioId AS [LotDispositionScenarioId] 
                                    , ld.OdmQualFilterId AS [LotDispositionOdmQualFilterId]
                                    , ld.[LotDispositionReasonId] 
                                    , ld.[Notes]
                                    , ld.[LotDispositionActionId] 
                                    , ld.[OdmQualFilterId]
                                    , qf.[OdmId]
                                    , qf.[DesignId]
                                    , qf.[SCode]
                                    , qf.[MediaIPN]
                                    , qf.[SLot]
                                    , qf.[OdmQualFilterCategoryId]
                                    , ld.[CreatedOn]
                                    , ld.[CreatedBy]
                                    , ld.[UpdatedOn]
                                    , ld.[UpdatedBy]
                        FROM [npsg].[OdmQualFilterLotDispositions] ld WITH (NOLOCK)
                                    LEFT JOIN [npsg].[OdmQualFilters] qf 
                                                ON ld.OdmQualFilterId = qf.Id
                                                            AND    ld.ScenarioId = @PrevScenarioId
                                                            AND qf.ScenarioId = @PrevScenarioId
                        WHERE ld.ScenarioId = @PrevScenarioId
                        AND ld.LotDispositionActionId = @LotDispositionQualifiedActionId;
                        -- Now, we got all the lot dispositions for the previous scenario with their qual filter details like S-Lot, IPN and SCode
                        -- so now, first merge the qualfilters from previous lot dispositions
                        MERGE [npsg].[OdmQualFilters] AS TRG
                        USING
                        (
                                    SELECT
                                                [LotDispositionId],
                                                [LotDispositionScenarioId] ,
                                                [LotDispositionOdmQualFilterId],
                                                [LotDispositionReasonId] ,
                                                [Notes],
                                                [LotDispositionActionId], 
                                                [OdmQualFilterId],
                                                [OdmId], --
                                                [DesignId], --
                                                [SCode], --
                                                [MediaIPN], --
                                                [SLot], --
                                                [OdmQualFilterCategoryId]
                                    FROM  #PastLotDispositions ld  
                        ) AS SRC
                        ON
                        (
                                    TRG.[OdmId] = SRC.[OdmId] AND
                                    TRG.[DesignId] = SRC.[DesignId] AND
                                    TRG.[SCode] = SRC.[SCode] AND
                                    TRG.[MediaIPN] = SRC.[MediaIPN] AND
                                    TRG.[SLot] = SRC.[SLot] AND
                                    TRG.[ScenarioId] = @ScenarioId
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
                                                              @ScenarioId
                                                            , SRC.[OdmId]
                                                            , SRC.[DesignId]
                                                            , SRC.[SCode]
                                                            , SRC.[MediaIPN]
                                                            , SRC.[SLot]
                                                            , SRC.[OdmQualFilterCategoryId]
                                                            )
                        WHEN MATCHED THEN
                                    UPDATE SET [OdmQualFilterCategoryId] = SRC.[OdmQualFilterCategoryId];
                        
                        -- So now, all the qual filter entries are up to date
                        -- Get all current scenrion qual filter entries and left join with current lot dispositions
                        -- then left join it with past lot dispositions ([npsg].[OdmQualFilterLotDispositions]) - This will tell us what lot dispositions are not in current scenario from past ones
                        -- then use that to merge the previous lot dispositions into the lot dispositions table
                        CREATE TABLE #UptoDateLotDispositions
                        (
                                      [LotDispositionId] [int]
                                    , [LotDispositionScenarioId] [int] NULL
                                    , [LotDispositionReasonId] [int] NULL
                                    , [Notes] [varchar](MAX) NULL
                                    , [LotDispositionActionId] [int] NULL
                                    , [OdmQualFilterId] [int]
                                    , [OdmId] [int] NULL
                                    , [DesignId] [varchar](200) NULL
                                    , [SCode] [varchar](200) NULL
                                    , [MediaIPN] [varchar](200) NULL
                                    , [SLot] [varchar](255) NULL
                                    , [OdmQualFilterCategoryId] [int]
                                    , [CreatedOn]                                                             [datetime2](7) NOT NULL
                                    , [CreatedBy]                                                              [varchar](255) NOT NULL
                                    , [UpdatedOn]                                                            [datetime2](7) NOT NULL
                                    , [UpdatedBy]                                                             [varchar](255) NOT NULL
                        );
                        INSERT INTO #UptoDateLotDispositions
                        (
                                      [LotDispositionId]
                                    , [LotDispositionScenarioId]
                                    , [LotDispositionReasonId]
                                    , [Notes]
                                    , [LotDispositionActionId]
                                    , [OdmQualFilterId]
                                    , [OdmId]
                                    , [DesignId]
                                    , [SCode]
                                    , [MediaIPN]
                                    , [SLot]
                                    , [OdmQualFilterCategoryId]                        
                                    , [CreatedOn]
                                    , [CreatedBy]
                                    , [UpdatedOn]
                                    , [UpdatedBy]
                        )
                        SELECT 
                                                  pld.[LotDispositionId]
                                                , pld.[LotDispositionScenarioId] 
                                                , pld.[LotDispositionReasonId] 
                                                , pld.[Notes]
                                                , pld.[LotDispositionActionId]
                                                , qf.[Id] AS [OdmQualFilterId]
                                                , qf.[OdmId]
                                                , qf.[DesignId]
                                                , qf.[SCode]
                                                , qf.[MediaIPN]
                                                , qf.[SLot]
                                                , qf.[OdmQualFilterCategoryId]                                            
                                                , pld.[CreatedOn]
                                                , pld.[CreatedBy]
                                                , pld.[UpdatedOn]
                                                , pld.[UpdatedBy]
                                    FROM [npsg].[OdmQualFilters] qf WITH (NOLOCK) -- current qual filters
                                                LEFT JOIN [npsg].[OdmQualFilterLotDispositions] ld -- current lot dispositions
                                                            ON qf.ScenarioId = ld.ScenarioId
                                                            AND qf.Id = ld.OdmQualFilterId
                                                LEFT JOIN #PastLotDispositions pld -- past lot disposition can be joined only on odmid, designid, scode, media ipn, s-lot
                                                            ON  qf.[OdmId]                       = pld.[OdmId] AND
                                                                        qf.[DesignId]   = pld.[DesignId] AND
                                                                        qf.[SCode]                  = pld.[SCode] AND
                                                                        qf.[MediaIPN] = pld.[MediaIPN] AND
                                                                        qf.[SLot]                      = pld.[SLot] 
                                    WHERE  qf.[ScenarioId] = @ScenarioId
                                                AND ld.ScenarioId = @ScenarioId
                                                AND pld.LotDispositionId IS NOT NULL;

                        MERGE [npsg].[OdmQualFilterLotDispositions] AS TRG
                        USING
                        (
                                    SELECT
                                                  [LotDispositionId]
                                                , [LotDispositionScenarioId]
                                                , [LotDispositionReasonId]
                                                , [Notes]
                                                , [LotDispositionActionId]
                                                , [OdmQualFilterId]
                                                , [OdmId]
                                                , [DesignId]
                                                , [SCode]
                                                , [MediaIPN]
                                                , [SLot]
                                                , [OdmQualFilterCategoryId]                                    
                                                , [CreatedOn]
                                                , [CreatedBy]
                                                , [UpdatedOn]
                                                , [UpdatedBy]
                                    FROM  #UptoDateLotDispositions  
                        ) AS SRC
                        ON
                        (
                                    TRG.[OdmQualFilterId] = SRC.[OdmQualFilterId] AND
                                    TRG.[ScenarioId] = @ScenarioId
                        )
                        WHEN NOT MATCHED BY TARGET THEN 
                                    INSERT (
                                                [ScenarioId]
                                                ,[OdmQualFilterId]
                                                ,[LotDispositionReasonId]
                                                ,[Notes]
                                                ,[LotDispositionActionId]
                                                ,[CreatedOn]
                                                ,[CreatedBy]
                                                ,[UpdatedOn]
                                                ,[UpdatedBy])
                                    VALUES
                                                ( @ScenarioId
                                                , SRC.OdmQualFilterId
                                                , SRC.LotDispositionReasonId
                                                , SRC.Notes 
                                                , SRC.LotDispositionActionId                                                                                    
                                                , SRC.[CreatedOn]
                                                , SRC.[CreatedBy]
                                                , SRC.[UpdatedOn]
                                                , SRC.[UpdatedBy])
                        WHEN MATCHED THEN
                                    UPDATE 
                                       SET [LotDispositionReasonId] = SRC.LotDispositionReasonId
                                                  ,[Notes]                                                         = SRC.Notes
                                                  ,[LotDispositionActionId] = SRC.LotDispositionActionId 
                                                  ,[CreatedOn] = SRC.[CreatedOn]
                                                  ,[CreatedBy] = SRC.[CreatedBy]
                                                  ,[UpdatedOn] = SRC.[UpdatedOn]
                                                  ,[UpdatedBy] = SRC.[UpdatedBy];

                        -- Now, take all exceptions from previous version and insert for the current scenario
                        CREATE TABLE #PastExceptions
                        (
                                    [OdmId] [int] NULL,
                                    [DesignId] [varchar](200) NULL,
                                    [SCodeMMNumber] [varchar](200) NULL,
                                    [MediaIPN] [varchar](200) NULL,
                                    [SLot] [varchar](255) NULL
                        );
                        INSERT INTO #PastExceptions
                        (
                                    [OdmId]
                                    ,[SCodeMMNumber]
                                    ,[MediaIPN]
                                    ,[SLot]
                        )
                        SELECT
                                                [OdmId]
                                                ,[SCodeMMNumber]
                                                ,[MediaIPN]
                                                ,[SLot]
                                    FROM  [npsg].[OdmQualFilterNonQualifiedMediaExceptions]
                                    WHERE [ScenarioId] = @PrevScenarioId;

                        MERGE [npsg].[OdmQualFilterNonQualifiedMediaExceptions] AS TRG
                        USING
                        (
                                    SELECT
                                                @ScenarioId AS [ScenarioId]
                                                ,[OdmId]
                                                ,[SCodeMMNumber]
                                                ,[MediaIPN]
                                                ,[SLot]
                                    FROM  #PastExceptions
                        ) AS SRC
                        ON
                        (
                                    TRG.[ScenarioId]                   = SRC.[ScenarioId]                 AND
                                    TRG.[OdmId]                         = SRC.[OdmId]                                   AND
                                    TRG.[SCodeMMNumber]      = SRC.[SCodeMMNumber]    AND
                                    TRG.[MediaIPN]                                = SRC.[MediaIPN]                  AND
                                    TRG.[SLot]                                         = SRC.[SLot]                           
                        )
                        WHEN NOT MATCHED BY TARGET THEN 
                                    INSERT (
                                                            [ScenarioId]
                                                            ,[OdmId]
                                                            ,[SCodeMMNumber]
                                                            ,[MediaIPN]
                                                            ,[SLot])
                                    VALUES
                                                   (SRC.[ScenarioId]
                                                   ,SRC.[OdmId]
                                                   ,SRC.[SCodeMMNumber]
                                                   ,SRC.[MediaIPN]
                                                   ,SRC.[SLot]
                                                   );
            
            END
            
			-- Exclude those SLots that ODMs have reported to remove
			;WITH QfToBeRemoved AS
			(
				SELECT qf.Id AS OdmQualFilterId
				FROM [npsg].[OdmQualFilters] qf WITH (NOLOCK)
				INNER JOIN  [npsg].[OdmQualFilterRemovableMedia] rm WITH (NOLOCK)
					ON rm.[OdmId] = qf.[OdmId]
					AND rm.[SLot] = qf.[SLot]
					AND rm.[MediaIPN] = qf.[MediaIPN]
					AND rm.[MMNum] = qf.[SCode]
				WHERE qf.[ScenarioId] = @ScenarioId
			)

			DELETE ld 
			FROM [npsg].[OdmQualFilterLotDispositions] ld WITH (NOLOCK)
			INNER JOIN QfToBeRemoved rm WITH (NOLOCK)
				ON ld.[OdmQualFilterId] = rm.[OdmQualFilterId]
			WHERE ld.[ScenarioId] = @ScenarioId

			DELETE qm 
			FROM [npsg].[OdmQualFilterNonQualifiedMediaExceptions] qm WITH (NOLOCK)
			INNER JOIN  [npsg].[OdmQualFilterRemovableMedia] rm WITH (NOLOCK)
				ON rm.[OdmId] = qm.[OdmId]
				AND rm.[SLot] = qm.[SLot]
				AND rm.[MediaIPN] = qm.[MediaIPN]
				AND rm.[MMNum] = qm.[SCodeMMNumber]
			WHERE qm.ScenarioId = @ScenarioId

			DELETE qf 
			FROM [npsg].[OdmQualFilters] qf WITH (NOLOCK)
			INNER JOIN  [npsg].[OdmQualFilterRemovableMedia] rm WITH (NOLOCK)
				ON rm.[OdmId] = qf.[OdmId]
				AND rm.[SLot] = qf.[SLot]
				AND rm.[MediaIPN] = qf.[MediaIPN]
				AND rm.[MMNum] = qf.[SCode]
			WHERE qf.[ScenarioId] = @ScenarioId

END