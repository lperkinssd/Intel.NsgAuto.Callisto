﻿namespace Intel.NsgAuto.Callisto.Business.Core
{
    public static class StoredProcedures
    {
        
        public const string SP_APPROVEMATVERSION = "[qan].[ApproveMATVersion]";
        public const string SP_CANCELMATVERSION = "[qan].[CancelMATVersion]";       
        public const string SP_CREATEACATTRIBUTETYPEANDRETURNALL = "[qan].[CreateAcAttributeTypeAndReturnAll]";
        public const string SP_CREATEACBUILDCRITERIA = "[qan].[CreateAcBuildCriteria]";
        public const string SP_CREATEACBUILDCRITERIACOMMENTRETURNALL = "[qan].[CreateAcBuildCriteriaCommentReturnAll]";
        public const string SP_CREATEMATSNAPSHOTS = "[qan].[CreateMATSnapshots]";
        public const string SP_CREATEODMQUALFILTERLOTDISPOSITION = "[qan].[CreateOdmQualFilterLotDisposition]";
        public const string SP_UPDATEODMQUALFILTERLOTDISPOSITIONS = "[qan].[UpdateOdmQualFilterLotDispositions]";
        public const string SP_CREATEACCOUNTOWNERSHIP = "[qan].[CreateAccountOwership]";
        public const string SP_CREATEOSATATTRIBUTETYPEANDRETURNALL = "[qan].[CreateOsatAttributeTypeAndReturnAll]";
        public const string SP_CREATEOSATBUILDCRITERIASET = "[qan].[CreateOsatBuildCriteriaSet]";
        public const string SP_GETDESIGNSINBULKUPDATE = "[qan].[GetDesignsInBulkUpdate]";
        public const string SP_CREATEOSATBUILDCRITERIASETCOMMENTRETURNALL = "[qan].[CreateOsatBuildCriteriaSetCommentReturnAll]";
        public const string SP_CREATEOSATQUALFILTEREXPORTANDRETURN = "[qan].[CreateOsatQualFilterExportAndReturn]";
        public const string SP_CREATEOSATQUALFILTERIMPORTANDRETURN = "[qan].[CreateOsatQualFilterImportAndReturn]";
        public const string SP_CREATEOSATBUILDCRITERIASETBULKUPDATEIMPORT = "[qan].[CreateOsatBuildCriteriaSetBulkUpdateImport]";
        public const string SP_CREATESPEEDACCESSTOKEN = "[qan].[CreateSpeedAccessToken]";
        public const string SP_CREATEPRODUCTOWNERSHIP = "[qan].[CreateProductOwership]";
        public const string SP_CREATETASKBYNAMERETURNTASK = "[stage].[CreateTaskByNameReturnTask]";
        public const string SP_DELETEPRODUCTOWNERSHIP = "[qan].[DeleteProductOwnership]";
        public const string SP_DELETEACCOUNTOWNERSHIP = "[qan].[DeleteAccountOwnership]";
        public const string SP_CREATETASKMESSAGE = "[stage].[CreateTaskMessage]";
        public const string SP_GETACATTRIBUTETYPESMETADATA = "[qan].[GetAcAttributeTypesMetadata]";
        public const string SP_GETACBUILDCOMBINATIONS = "[qan].[GetAcBuildCombinations]";
        public const string SP_GETACBUILDCRITERIA = "[qan].[GetAcBuildCriteria]";
        public const string SP_GETACBUILDCRITERIAANDVERSIONS = "[qan].[GetAcBuildCriteriaAndVersions]";
        public const string SP_GETACBUILDCRITERIAEXPORTCONDITIONS = "[qan].[GetAcBuildCriteriaExportConditions]";
        public const string SP_GETACBUILDCRITERIACREATE = "[qan].[GetAcBuildCriteriaCreate]";
        public const string SP_GETACBUILDCRITERIADETAILS = "[qan].[GetAcBuildCriteriaDetails]";
        public const string SP_GETACBUILDCRITERIAS = "[qan].[GetAcBuildCriterias]";
        public const string SP_GETACCOUNTOWNERSHIPMETADATA = "[qan].[GetAccountOwnershipMetadata]";
        public const string SP_GETCUSTOMERS = "[qan].[GetCustomers]";
        public const string SP_GETEMAILTEMPLATES = "[ref].[GetEmailTemplates]";
        public const string SP_GETFORMFACTORS = "[qan].[GetFormFactors]";
        public const string SP_GETITEMTYPEREVIEWERS = "[qan].[GetReviewItemTypeReviewers]";
        public const string SP_GETITEMTYPES = "[qan].[GetReviewItemTypes]";
        public const string SP_GETLATESTODMQUALFILTER = "[qan].[GetLatestOdmQualFilter]";
        public const string SP_GETMATS = "[qan].[GetMATs]";
        public const string SP_GETMATSTAGESANDREVIEWERS = "[qan].[GetMATStagesAndReviewers]";
        public const string SP_GETMATVERSIONDETAILS = "[qan].[GetMATVersionDetails]";
        public const string SP_GETMATVERSIONS = "[qan].[GetMATVersions]";
        public const string SP_GETMMRECIPEDETAILS = "[qan].[GetMMRecipeDetails]";
        public const string SP_GETMMRECIPES = "[qan].[GetMMRecipes]";
        public const string SP_GETMMRECIPESREVIEWABLE = "[qan].[GetMMRecipesReviewable]";
        public const string SP_GETMMRECIPEREFERENCETABLES = "[qan].[GetMMRecipeReferenceTables]";
        public const string SP_GETMMRECIPESBYSTATUS = "[qan].[GetMMRecipesByStatus]";
        public const string SP_GETMMRECIPENEW = "[qan].[GetMMRecipeNew]";
        public const string SP_GETODMLOTDISPOSITIONACTIONS = "[qan].[GetOdmLotDispositionActions]";
        public const string SP_GETODMLOTDISPOSITIONREASONS = "[qan].[GetOdmLotDispositionReasons]";
        public const string SP_GETODMMATVERSIONDETAILS = "[qan].[GetOdmMatVersionDetails]";
        public const string SP_GETODMMATVERSIONS = "[qan].[GetOdmMatVersions]";
        public const string SP_GETODMPRFVERSIONDETAILS = "[qan].[GetOdmPrfVersionDetails]";
        public const string SP_GETODMPRFVERSIONS = "[qan].[GetOdmPrfVersions]";
        public const string SP_GETODMQUALFILTER = "[qan].[GetODMQualFilter]";
        public const string SP_GETODMQUALFILTEREXPLANATIONS = "[qan].[GetODMQualFilterExplanations]";
        public const string SP_GETODMQUALFILTERSCENARIO = "[qan].[GetOdmQualFilterScenario]";
        public const string SP_GETODMQUALFILTERHISTORICALSCENARIO = "[qan].[GetOdmQualFilterHistoricalScenario]";
        //public const string SP_GETODMQUALFILTERSCENARIOPUBLISHED = "[qan].[GetOdmQualFilterScenarioPublished]";
        public const string SP_PUBLISHODMQUALFILTER = "[qan].[PublishOdmQualFilter]";
        public const string SP_GETODMQUALFILTERSCENARIOVERSIONS = "[qan].[GetOdmQualFilterScenarioVersions]";
        public const string SP_GETODMQUALFILTERSCENARIOVERSIONSDAILY = "[qan].[GetOdmQualFilterScenarioVersionsDaily]";
        public const string SP_GETODMQUALFILTERSCENARIOHISTORICALVERSIONS = "[qan].[GetOdmQualFilterScenarioHistoricalVersions]";
        public const string SP_GETOSATATTRIBUTETYPESMANAGE = "[qan].[GetOsatAttributeTypesManage]";
        public const string SP_GETOSATBUILDCOMBINATIONANDBUILDCRITERIASETS = "[qan].[GetOsatBuildCombinationAndBuildCriteriaSets]";
        public const string SP_GETOSATBUILDCOMBINATIONS = "[qan].[GetOsatBuildCombinations]";
        public const string SP_GETOSATBUILDCRITERIASET = "[qan].[GetOsatBuildCriteriaSet]";
        public const string SP_GETOSATBUILDCRITERIASETANDVERSIONS = "[qan].[GetOsatBuildCriteriaSetAndVersions]";
        public const string SP_GETOSATBUILDCRITERIACONDITIONS = "[qan].[GetOsatBuildCriteriaConditions]";
        public const string SP_GETOSATBUILDCRITERIASETCREATE = "[qan].[GetOsatBuildCriteriaSetCreate]";
        public const string SP_GETOSATBUILDCRITERIASETDETAILS = "[qan].[GetOsatBuildCriteriaSetDetails]";
        public const string SP_GETOSATBUILDCRITERIASETS = "[qan].[GetOsatBuildCriteriaSets]";
        public const string SP_GETOSATDESIGNSUMMARY = "[qan].[GetOsatDesignSummary]";
        public const string SP_GETOSATPASVERSIONDETAILS = "[qan].[GetOsatPasVersionDetails]";
        public const string SP_GETOSATPASVERSIONS = "[qan].[GetOsatPasVersions]";
        public const string SP_GETOSATPASVERSIONSLISTANDIMPORT = "[qan].[GetOsatPasVersionsListAndImport]";
        public const string SP_GETOSATQUALFILTER = "[qan].[GetOsatQualFilter]";
        public const string SP_GETOSATBUILDCRITERIASETBULKUPDATECHANGES = "[qan].[GetOsatBuildCriteriaSetBulkUpdateChanges]";
        public const string SP_GETOSATBUILDCRITERIASETBULKIMPORTDESIGNANDVERSION = "[qan].[GetOsatBuildCriteriaSetBulkImportDesignAndVersion]";
        public const string SP_GETOSATBUILDCRITERIASETSTATUSFORBULKUPDATEIMPORT = "[qan].[GetOsatBuildCriteriaSetStatusForBulkUpdateImport]";
        public const string SP_GETOSATQUALFILTEREXPORTS = "[qan].[GetOsatQualFilterExports]";
        public const string SP_GETOSATQUALFILTEREXPORT = "[qan].[GetOsatQualFilterExport]";
        public const string SP_GETOSATQUALFILTERIMPORTDETAILS = "[qan].[GetOsatQualFilterImportDetails]";
        public const string SP_GETOSATQUALFILTERIMPORTS = "[qan].[GetOsatQualFilterImports]";
        public const string SP_GETOSATQUALFILTERPUBLISH = "[qan].[GetOsatQualFilterPublish]";
        public const string SP_GETOSATQUALFILTERRECORDS = "[qan].[GetOsatQualFilterRecords]";
        public const string SP_GETOSATQUALFILTERRECORDSCUSTOM = "[qan].[GetOsatQualFilterRecordsCustom]";
        public const string SP_GETPARTS = "[qan].[GetParts]";
        public const string SP_GETPCNAPPROVERMETADATA = "[qan].[GetPCNApproverMetadata]";
        public const string SP_GETPCNAPPROVERLIST = "[qan].[GetPCNApproverList]";
        public const string SP_GETPCNMANAGERMETADATA = "[qan].[GetPCNManagerMetadata]";
        public const string SP_GETPCNMANAGERLIST = "[qan].[GetPCNManagerList]";
        public const string SP_GETPRODUCTFAMILIES = "[qan].[GetProductFamilies]";
        public const string SP_GETPRODUCTLABELS = "[qan].[GetProductLabels]";
        public const string SP_GETPRODUCTLABELSETVERSIONS = "[qan].[GetProductLabelSetVersions]";
        public const string SP_GETPRODUCTOWNERSHIPMETADATA = "[qan].[GetProductOwnershipMetadata]";        
        public const string SP_GETPRODUCTS = "[qan].[GetProducts]";
        public const string SP_GetOsatBulkUpdateMetaData = "[qan].[GetOsatBulkUpdateMetaData]";
        public const string SP_GETSPEEDITEM = "[stage].[GetSpeedItem]";
        public const string SP_GETSPEEDITEMCHARACTERISTICDETAILV2RECORDS = "[stage].[GetItemCharacteristicDetailV2Records]";
        public const string SP_GETSPEEDITEMDETAILV2RECORDS = "[stage].[GetItemDetailV2Records]";
        public const string SP_GETSTATUSES = "[qan].[GetStatuses]";
        public const string SP_GETTASKMESSAGES = "[stage].[GetTaskMessages]";
        public const string SP_GETTASKS = "[stage].[GetTasks]";
        public const string SP_GETUNEXPIREDSPEEDACCESSTOKEN = "[qan].[GetUnexpiredSpeedAccessToken]";
        public const string SP_IMPORTMATS = "[qan].[ImportMATs]";
        public const string SP_IMPORTMATRECORDS = "[qan].[ImportMatRecords]";
        public const string SP_IMPORTOSATPASVERSIONRETURNVERSION = "[qan].[ImportOsatPasVersionReturnVersion]";
        public const string SP_IMPORTPRFRECORDS = "[qan].[ImportPrfRecords]";
        public const string SP_IMPORTPRODUCTLABELS = "[qan].[ImportProductLabels]";
        public const string SP_INITIALIZESESSION = "[qan].[InitializeSession]";
        public const string SP_REJECTMATVERSION = "[qan].[RejectMATVersion]";
        public const string SP_RUNODMQUALFILTERSCENARIO = "[qan].[RunOdmQualFilterScenario]";
        public const string SP_SUBMITMATVERSION = "[qan].[SubmitMATVersion]";
        public const string SP_UPDATEACATTRIBUTETYPEANDRETURNALL = "[qan].[UpdateAcAttributeTypeAndReturnAll]";
        public const string SP_UPDATEACBUILDCRITERIAAPPROVEDRETURNDETAILS = "[qan].[UpdateAcBuildCriteriaApprovedReturnDetails]";
        public const string SP_UPDATEACBUILDCRITERIACANCELEDRETURNDETAILS = "[qan].[UpdateAcBuildCriteriaCanceledReturnDetails]";
        public const string SP_UPDATEACBUILDCRITERIAREJECTEDRETURNDETAILS = "[qan].[UpdateAcBuildCriteriaRejectedReturnDetails]";
        public const string SP_UPDATEACBUILDCRITERIASUBMITTEDRETURNDETAILS = "[qan].[UpdateAcBuildCriteriaSubmittedReturnDetails]";
        public const string SP_UPDATEACCOUNTOWNERSHIP = "[qan].[UpdateAccountOwership]";
        public const string SP_UPDATEMMRECIPE = "[qan].[UpdateMMRecipe]";
        public const string SP_UPDATEMMRECIPEAPPROVEDRETURNDETAILS = "[qan].[UpdateMMRecipeApprovedReturnDetails]";
        public const string SP_UPDATEMMRECIPECANCELEDRETURNDETAILS = "[qan].[UpdateMMRecipeCanceledReturnDetails]";
        public const string SP_UPDATEMMRECIPEREJECTEDRETURNDETAILS = "[qan].[UpdateMMRecipeRejectedReturnDetails]";
        public const string SP_UPDATEMMRECIPESUBMITTEDRETURNDETAILS = "[qan].[UpdateMMRecipeSubmittedReturnDetails]";
        public const string SP_UPDATEOSATATTRIBUTETYPEANDRETURNALL = "[qan].[UpdateOsatAttributeTypeAndReturnAll]";
        public const string SP_UPDATEOSATBUILDCOMBINATIONPUBLISHDISABLEDRETURNALL = "[qan].[UpdateOsatBuildCombinationPublishDisabledReturnAll]";
        public const string SP_UPDATEOSATBUILDCOMBINATIONPUBLISHENABLEDRETURNALL = "[qan].[UpdateOsatBuildCombinationPublishEnabledReturnAll]";
        public const string SP_UPDATEOSATBUILDCRITERIASETAPPROVEDRETURNDETAILS = "[qan].[UpdateOsatBuildCriteriaSetApprovedReturnDetails]";
        public const string SP_UPDATEOSATBUILDCRITERIASETFORBULKUPDATE = "[qan].[UpdateOsatBuildCriteriaSetForBulkUpdate]";
        public const string SP_UPDATEOSATBUILDCRITERIASETCANCELEDRETURNDETAILS = "[qan].[UpdateOsatBuildCriteriaSetCanceledReturnDetails]";
        public const string SP_UPDATEOSATBUILDCRITERIASETREJECTEDRETURNDETAILS = "[qan].[UpdateOsatBuildCriteriaSetRejectedReturnDetails]";
        public const string SP_UPDATEOSATBUILDCRITERIASETSUBMITTEDRETURNDETAILS = "[qan].[UpdateOsatBuildCriteriaSetSubmittedReturnDetails]";
        public const string SP_UPDATEOSATPASVERSIONCANCELEDRETURNDETAILS = "[qan].[UpdateOsatPasVersionCanceledReturnDetails]";
        public const string SP_UPDATEOSATPASVERSIONSUBMITTEDRETURNDETAILS = "[qan].[UpdateOsatPasVersionSubmittedReturnDetails]";
        public const string SP_UPDATEOSATQUALFILTEREXPORTDELIVERED = "[qan].[UpdateOsatQualFilterExportDelivered]";
        public const string SP_UPDATEOSATQUALFILTEREXPORTGENERATED = "[qan].[UpdateOsatQualFilterExportGenerated]";
        public const string SP_UPDATEOSATQUALFILTERIMPORTCANCELED = "[qan].[UpdateOsatQualFilterImportCanceled]";
        public const string SP_UPDATEOSATQUALFILTERIMPORTCANCELEDRETURNDETAILS = "[qan].[UpdateOsatQualFilterImportCanceledReturnDetails]";
        public const string SP_UPDATEOSATQUALFILTERIMPORTPOR = "[qan].[UpdateOsatQualFilterImportPor]";
        public const string SP_UPDATEOSATQUALFILTERIMPORTPORRETURNDETAILS = "[qan].[UpdateOsatQualFilterImportPorReturnDetails]";
        public const string SP_UPDATEPRODUCTLABELSETVERSIONAPPROVED = "[qan].[UpdateProductLabelSetVersionApproved]";
        public const string SP_UPDATEPRODUCTLABELSETVERSIONCANCELED = "[qan].[UpdateProductLabelSetVersionCanceled]";
        public const string SP_UPDATEPRODUCTLABELSETVERSIONREJECTED = "[qan].[UpdateProductLabelSetVersionRejected]";
        public const string SP_UPDATEPRODUCTLABELSETVERSIONSUBMITTED = "[qan].[UpdateProductLabelSetVersionSubmitted]";
        public const string SP_UPDATEPRODUCTOWNERSHIP = "[qan].[UpdateProductOwership]";
        public const string SP_UPDATETASKABORT = "[stage].[UpdateTaskAbort]";
        public const string SP_UPDATETASKEND = "[stage].[UpdateTaskEnd]";
        public const string SP_UPDATETASKPROGRESS = "[stage].[UpdateTaskProgress]";
        public const string SP_UPDATETASKRESOLVED = "[stage].[UpdateTaskResolved]";
        public const string SP_UPDATETASKSRESOLVEALLABOERTEDRETURNTASK = "[stage].[UpdateTasksResolveAllAbortedReturnTask]";
        public const string SP_UPDATETASKUNRESOLVED = "[stage].[UpdateTaskUnresolved]";
        public const string SP_GETODMLOTWIPDETAILS = "[qan].[GetOdmLotWipDetails]";
        public const string SP_SAVELOTDISPOSITIONS = "[qan].[SaveLotDispositions]";
        public const string SP_IMPORTODMMANUALDISPOSITIONS = "[qan].[ImportOdmManualDispositions]";
        public const string SP_GETODMMANUALDISPOSITIONSVERSIONS = "[qan].[GetOdmManualDispositionsVersions]";
        public const string SP_GETODMMANUALDISPOSITIONSBYVERSION = "[qan].[GetOdmManualDispositionsByVersion]";
        public const string SP_GETPREFERREDROLE = "[qan].[GetPreferredRole]";
        public const string SP_SAVEPREFERREDROLE = "[qan].[SavePreferredRole]";
        public const string SP_TASKPROCESSIOGREMOVABLESLOTS = "[stage].[TaskProcessIOGRemovableSLots]";
        public const string SP_GETQUALFILTERIOGREMOVABLESLOTUPLOADS = "[stage].[GetQualFilterIOGRemovableSLotUploads]";
        public const string SP_GETODMPROHIBITEDSCENARIORUNTIME = "[ref].[GetOdmProhibitedScenarioRunTime]";
        public const string SP_GETIOGREMOVABLESLOTSDETAILS = "[stage].[GetIOGRemovableSLotsDetails]";
    }
}
