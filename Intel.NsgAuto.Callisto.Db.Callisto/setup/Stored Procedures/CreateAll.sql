-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-09-28 10:22:06.197
-- Description  : Executes all setup Create* procedures
-- Example      : EXEC [setup].[CreateAll];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateAll]
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [setup].[CreateAcAttributeDataTypeOperations];
	EXEC [setup].[CreateAcAttributeDataTypes];
	EXEC [setup].[CreateAcComparisonOperations];
	EXEC [setup].[CreateAcOperandTypes];
	EXEC [setup].[CreateCustomerQualStatuses];
	EXEC [setup].[CreateEmailTemplates];
	EXEC [setup].[CreateEmailTemplateBodyXsls];
	EXEC [setup].[CreateDesignFamilies];
	EXEC [setup].[CreateOpalTypes];
	EXEC [setup].[CreateOsatAttributeDataTypeOperations];
	EXEC [setup].[CreateOsatAttributeDataTypes];
	EXEC [setup].[CreateOsatComparisonOperations];
	EXEC [setup].[CreateOsatOperandTypes];
	EXEC [setup].[CreatePartUseTypes];
	EXEC [setup].[CreateProcessAndSecurity];
	EXEC [setup].[CreateProductLabelAttributeTypes];
	EXEC [setup].[CreatePLCStages];
	EXEC [setup].[CreateReviewTypes];
	EXEC [setup].[CreateSpeedItemCategories];
	EXEC [setup].[CreateStatuses];
	EXEC [setup].[CreateOdmLotDispositionActions];
	EXEC [setup].[CreateOdmLotDispositionReasons];
	EXEC [setup].[CreateOdmNames];
	EXEC [setup].[CreateOdmQualFilterCategories];
	EXEC [setup].[CreateOdmQualFilterStatuses];

END
