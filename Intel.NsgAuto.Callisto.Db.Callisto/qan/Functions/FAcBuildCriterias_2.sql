-- ===================================================================================================================================  
-- Author       : bricschx  
-- Create date  : 2020-11-13 09:38:40.883  
-- Description  : Gets auto checker build criterias  
-- Example      : SELECT * FROM [qan].[FAcBuildCriterias](1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);  
-- ===================================================================================================================================  
CREATE FUNCTION [qan].[FAcBuildCriterias]  
(  
   @Id                       BIGINT      = NULL  
 , @UserId                   VARCHAR(25) = NULL -- if not null will restrict results to user's allowed design families  
 , @Version                  INT         = NULL  
 , @IsPOR                    BIT         = NULL  
 , @IsActive                 BIT         = NULL  
 , @StatusId                 INT         = NULL  
 , @BuildCombinationId       INT         = NULL  
 , @DesignId                 INT         = NULL  
 , @FabricationFacilityId    INT         = NULL  
 , @TestFlowIdIsNull         BIT         = NULL  
 , @TestFlowId               INT         = NULL  
 , @ProbeConversionIdIsNull  BIT         = NULL  
 , @ProbeConversionId        INT         = NULL  
) 
RETURNS @AcBuildCriterias TABLE (
   [Id]  bigint,
   [Version] int,
   [IsPOR] bit,
   [IsActive] bit,  
   [StatusId] int,
   [StatusName] varchar(25),
   [CreatedBy]  varchar(25),
   [CreatedByUserName]  varchar(15),
   [CreatedOn]  datetime2,
   [UpdatedBy] varchar(25),  
   [UpdatedByUserName] varchar(15),
   [UpdatedOn] datetime2  ,
   [BuildCombinationId]  int,
   [BuildCombinationName] varchar(200),
   [DesignId] int,
   [DesignName]  varchar(10),
   [DesignFamilyId] int,
   [DesignFamilyName]  varchar(10),
   [DesignIsActive]   bit,  
   [DesignCreatedBy]  varchar(25),
   [DesignCreatedOn]  datetime2,
   [DesignUpdatedBy]  varchar(25),
   [DesignUpdatedOn]  datetime2,
   [FabricationFacilityId]  int,
   [FabricationFacilityName] varchar(50),
   [TestFlowId]  int,
   [TestFlowName] varchar(50),
   [ProbeConversionId] int,
   [ProbeConversionName] varchar(50),
   [EffectiveOn] datetime2
    )
AS
BEGIN
       DECLARE @Process Varchar(MAX);
       SET @Process = (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) 
                                  INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId);
       
       Insert into @AcBuildCriterias
              SELECT  
    B.[Id]  
  , B.[Version]  
  , B.[IsPOR]  
  , B.[IsActive]  
  , B.[StatusId]  
  , S.[Name] 
  , B.[CreatedBy]  
  , UC.[IdSid] 
  , B.[CreatedOn]  
  , B.[UpdatedBy]  
  , UU.[IdSid] 
  , B.[UpdatedOn]  
  , B.[BuildCombinationId]  
  , C.[Name] 
  , B.[DesignId]  
  , D.[Name] 
  , D.[DesignFamilyId] 
  , DF.[Name] 
  , D.[IsActive] 
  , D.[CreatedBy]
  , D.[CreatedOn]
  , D.[UpdatedBy]
  , D.[UpdatedOn]
  , B.[FabricationFacilityId]  
  , F.[Name]
  , B.[TestFlowId]  
  , T.[Name]
  , B.[ProbeConversionId]  
  , P.[Name]
  , B.[EffectiveOn]  
 FROM [qan].[AcBuildCriterias]                 AS B  WITH (NOLOCK)  
 LEFT OUTER JOIN [ref].[Statuses]              AS S  WITH (NOLOCK) ON (S.[Id]     = B.[StatusId])  
 LEFT OUTER JOIN [qan].[AcBuildCombinations]   AS C  WITH (NOLOCK) ON (C.[Id]     = B.[BuildCombinationId])  
 LEFT OUTER JOIN [qan].[Products]              AS D  WITH (NOLOCK) ON (D.[Id]     = B.[DesignId])  
 LEFT OUTER JOIN [ref].[DesignFamilies]        AS DF WITH (NOLOCK) ON (DF.[Id]    = D.[DesignFamilyId])  
 LEFT OUTER JOIN [qan].[FabricationFacilities] AS F  WITH (NOLOCK) ON (F.[Id]     = B.[FabricationFacilityId])  
 LEFT OUTER JOIN [qan].[TestFlows]             AS T  WITH (NOLOCK) ON (T.[Id]     = B.[TestFlowId])  
 LEFT OUTER JOIN [qan].[ProbeConversions]      AS P  WITH (NOLOCK) ON (P.[Id]     = B.[ProbeConversionId])  
 --LEFT OUTER JOIN [qan].[PreferredRole]         AS UC WITH (NOLOCK) ON (UC.[UserId] = B.[CreatedBy])  
 --LEFT OUTER JOIN [qan].[PreferredRole]         AS UU WITH (NOLOCK) ON (UU.[UserId] = B.[UpdatedBy])  
 LEFT OUTER JOIN [qan].[Users]                 AS UC WITH (NOLOCK) ON (UC.[IdSid] = B.[CreatedBy])  
 LEFT OUTER JOIN [qan].[Users]                 AS UU WITH (NOLOCK) ON (UU.[IdSid] = B.[UpdatedBy])  
 WHERE (@Id                      IS NULL OR B.[Id] = @Id)  
   --AND (@UserId                  IS NULL OR DF.[Name] IN (SELECT pr.Process FROM [qan].[PreferredRole] pfr WITH (NOLOCK) INNER JOIN [qan].[ProcessRoles] pr WITH (NOLOCK) ON pfr.ActiveRole = pr.RoleName WHERE pfr.UserId = @UserId))  
   AND (@UserId                  IS NULL OR DF.[Name] = @Process)  
   AND (@Version                 IS NULL OR B.[Version] = @Version)  
   AND (@IsPOR                   IS NULL OR B.[IsPOR] = @IsPOR)  
   AND (@IsActive                IS NULL OR B.[IsActive] = @IsActive)  
   AND (@StatusId                IS NULL OR B.[StatusId] = @StatusId)  
   AND (@BuildCombinationId      IS NULL OR B.[BuildCombinationId] = @BuildCombinationId)  
   AND (@DesignId                IS NULL OR B.[DesignId] = @DesignId)  
   AND (@FabricationFacilityId   IS NULL OR B.[FabricationFacilityId] = @FabricationFacilityId)  
   AND (@TestFlowIdIsNull        IS NULL OR (@TestFlowIdIsNull = 0 AND B.[TestFlowId] IS NOT NULL) OR (@TestFlowIdIsNull = 1 AND B.[TestFlowId] IS NULL))  
   AND (@TestFlowId              IS NULL OR B.[TestFlowId] = @TestFlowId)  
   AND (@ProbeConversionIdIsNull IS NULL OR (@ProbeConversionIdIsNull = 0 AND B.[ProbeConversionId] IS NOT NULL) OR (@ProbeConversionIdIsNull = 1 AND B.[ProbeConversionId] IS NULL))  
   AND (@ProbeConversionId       IS NULL OR B.[ProbeConversionId] = @ProbeConversionId) 

       RETURN;
END