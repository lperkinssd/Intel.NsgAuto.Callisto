-- ============================================================================  
-- Author       : bricschx  
-- Create date  : 2020-11-13 14:51:55.720  
-- Description  : Gets all data needed for creating a new build criteria.  
--                If @Id is not null and valid, record sets for all versions  
--                of that specific build criteria will be included as well.  
--                The build criteria conditions will only be included for @Id.  
-- Example      : EXEC [qan].[GetAcBuildCriteriaCreate] 'bricschx', 1;  
-- ============================================================================  
CREATE PROCEDURE [qan].[GetAcBuildCriteriaCreate]  
(  
   @UserId  VARCHAR(25)  
 , @Id      BIGINT      = NULL  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @BuildCombinationId      INT;  
 DECLARE @DesignId                INT;  
 DECLARE @FabricationFacilityId   INT;  
 DECLARE @TestFlowIdIsNull        BIT;  
 DECLARE @TestFlowId              INT;  
 DECLARE @ProbeConversionIdIsNull BIT;  
 DECLARE @ProbeConversionId       INT;  
  
 IF (@Id IS NOT NULL)  
 BEGIN  
  -- if @Id is not a valid build criteria id, then set it to null (the where condition won't match any records and the max operation will return null)  
  SELECT  
     @Id = MAX([Id])  
   , @BuildCombinationId = MAX([BuildCombinationId])  
   , @DesignId = MAX([DesignId])  
   , @FabricationFacilityId = MAX([FabricationFacilityId])  
   , @TestFlowId = MAX([TestFlowId])  
   , @ProbeConversionId = MAX([ProbeConversionId])  
  FROM [qan].[AcBuildCriterias] WITH (NOLOCK) WHERE [Id] = @Id;  
  
  IF (@TestFlowId IS NULL) SET @TestFlowIdIsNull = 1;  
  IF (@ProbeConversionId IS NULL) SET @ProbeConversionIdIsNull = 1;  
 END;  
  
 -- record set #1: attribute types  
 SELECT * FROM [qan].[FAcAttributeTypes](NULL, NULL, NULL,@UserId) ORDER BY [Name];  
  
 -- record set #2: attribute data types  
 SELECT * FROM [qan].[FAcAttributeDataTypes](NULL, NULL) ORDER BY [Id];  
  
 -- record set #3: attribute type values  
 SELECT * FROM [qan].[FAcAttributeTypeValues](NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [Value], [Id];  
  
 -- record set #4: comparison operations  
 SELECT * FROM [qan].[FAcComparisonOperations](NULL, NULL, 0, NULL, NULL) ORDER BY [Id];  
  
 -- record set #5: data type comparison operations  
 SELECT * FROM [ref].[AcAttributeDataTypeOperations] WITH (NOLOCK) ORDER BY [AttributeDataTypeId], [ComparisonOperationId];  
  
 -- record set #6: designs  
 SELECT * FROM [qan].[FProducts](NULL, @UserId, NULL, NULL, NULL, NULL) ORDER BY [Name];  
  
 -- record set #7: fabrication facilities  
 SELECT [Id], [Name] FROM [qan].[FabricationFacilities] WITH (NOLOCK) ORDER BY [Name];  
  
 -- record set #8: test flows  
 SELECT [Id], [Name] FROM [qan].[TestFlows] WITH (NOLOCK) ORDER BY [Name];  
  
 -- record set #9: probe conversions  
 SELECT [Id], [Name] FROM [qan].[ProbeConversions] WITH (NOLOCK) ORDER BY [Name];  
  
 -- record set #10: build combinations  
 SELECT * FROM [qan].[FAcBuildCombinations](NULL, @UserId, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [DesignName], [FabricationFacilityName], [TestFlowName], [ProbeConversionName], [Id];  
  
 -- record set #11: build criteria templates  
 SELECT * FROM [qan].[FAcBuildCriteriaTemplates](NULL, NULL, NULL) ORDER BY [Id];  
  
 -- record set #12: build criteria template conditions  
 SELECT * FROM [qan].[FAcBuildCriteriaTemplateConditions](NULL, NULL, NULL, NULL, NULL, NULL, NULL) ORDER BY [TemplateId], [AttributeTypeName], [Id];  
  
 IF (@Id IS NOT NULL)  
 BEGIN  
  -- record set #13: build criterias (not just for @Id, but all matching: @BuildCombinationId, @DesignId, @FabricationFacilityId, @TestFlowId, and @ProbeConversionId)  
  SELECT * FROM [qan].[FAcBuildCriterias](NULL, @UserId, NULL, NULL, NULL, NULL, @BuildCombinationId, @DesignId, @FabricationFacilityId, @TestFlowIdIsNull, @TestFlowId, @ProbeConversionIdIsNull, @ProbeConversionId) ORDER BY [Id] DESC;  
  
  -- record set #14: build criteria conditions (only where BuildCriteriaId = @Id)  
  SELECT * FROM [qan].[FAcBuildCriteriaConditions](NULL, @UserId, @Id, NULL, NULL, NULL, NULL, NULL) ORDER BY [AttributeTypeName], [Id];  
 END;  
  
END
