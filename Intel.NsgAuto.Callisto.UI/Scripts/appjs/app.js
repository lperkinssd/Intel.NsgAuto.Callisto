/*!
 * Nsga client side framework root namespace implementation implementation
 * Author: Jose Kurian <jose.kurian@intel.com>
 * 
 *<remarks>
 * Usage examples : 
 * var args = 'framework initialization data';
 * Nsga.Framework.init(args);
 * 
 * Nsga namespace contains both code libraries as well as Immediately-Invoked Function Expressions (IIFE)
 * Immediately-Invoked Function Expression (IIFE) (function($) { //... })(jQuery);
   This is called Immediately-Invoked Function Expression or Self-executing anonymous function. 
   It enables the developer to hide his private declarations.
    ;(                                      // <---------------+
                                            //                 | encapsulate the function
        function($, window, document) {     // <--+ declare    | and call it passing three
                                            //    | anonymous  | arguments.
        }                                   // <--+ function   |
                                            //                 |
    )(jQuery, window, document);            // <---------------+
 * Wrapping the jQuery object into the dollar sign via a closure avoids conflicts with other libraries 
 * that also use the dollar sign as an abbreviation. window and document are passed through as local variables 
 * rather than as globals, because this speeds up the resolution process and can be more efficiently minified.
 *</remarks>
 *<uses>
 * jquery-1.8.1.js
 * json.js
 * Nsga.js
 *</uses>
 */
// If Nsga is already defined and loaded, append the implementations given below
Nsga = InitializeNamespace(Nsga);
function InitializeNamespace(namepace) {
    if (typeof (namepace) === "undefined") namepace = {}; else namepace = namepace || {};
    return namepace;
}
/// Nsga client side framework

Nsga.Callisto = {
    Messages: function () {
        // private method to get 
        var _showMessage = function (messageText, messageType, displayTime) {
            if (!displayTime) {
                displayTime = 5000;
            }
            DevExpress.ui.notify({
                message: messageText,
                type: messageType,
                position: {
                    my: "right",
                    offset: '0 100',
                    at: 'right top',
                    of: window
                },
                displayTime: displayTime,
                width: 450,
                closeOnClick: true
            });
        };

        // These are the public methods
        return {
            showWarning: function (message, displayTime) {
                _showMessage(message, "warning", displayTime);
            },
            showInfo: function (message, displayTime) {
                _showMessage(message, "info", displayTime);
            },
            showSuccess: function (message, displayTime) {
                _showMessage(message, "success", displayTime);
            },
            showError: function (message, displayTime) {
                _showMessage(message, "error", displayTime);
            }
        };
    }(),
    // This is where we declare all the constants
    Constants: function () {
        return {
            // for URLs make sure to include trailing / character since most code below depends on it
            URL_CREATEAUTOCHECKERATTRIBUTETYPE: "/api/AutoCheckerApi/CreateAttributeType/",
            URL_CREATEAUTOCHECKERBUILDCRITERIA: "/api/AutoCheckerApi/CreateBuildCriteria/",
            URL_CREATEAUTOCHECKERBUILDCRITERIACOMMENT: "/api/AutoCheckerApi/CreateBuildCriteriaComment/",
            URL_CREATEODMLOTDISPOSITION: "/api/ODMApi/CreateLotDisposition/",
            URL_SAVEODMLOTDISPOSITIONS: "/api/ODMApi/SaveLotDispositions/",
            URL_CHECKPROHIBITEDSCENARIORUNTIME: "/api/ODMApi/CheckProhibitedScenarioRunTime/",
            URL_ADMINISTRATIONSAVEPREFERREDROLE: "/api/Administration/SavePreferredRole/",
            URL_ADMINISTRATIONGETPREFERREDROLE: "/api/Administration/GetPreferredRole/",            
            URL_CREATEOSATATTRIBUTETYPE: "/api/Osat/CreateAttributeType/",
            URL_CREATEOSATBUILDCRITERIASET: "/api/Osat/CreateBuildCriteriaSet/",
            URL_CREATEOSATBUILDCRITERIASETCOMMENT: "/api/Osat/CreateBuildCriteriaSetComment/",
            URL_CREATEOSATQUALFILTEREXPORT: "/api/Osat/CreateQualFilterExport/",            
            URL_GETAUTOCHECKERBUILDCRITERIA: "/api/AutoCheckerApi/BuildCriteria/",
            URL_GETAUTOCHECKERBUILDCRITERIADETAILS: "/api/AutoCheckerApi/BuildCriteriaDetails/",
            URL_GETAUTOCHECKERBUILDCRITERIAANDVERSIONS: "/api/AutoCheckerApi/BuildCriteriaAndVersions/",
            URL_GETCUSTOMERS: "/api/Customers/",
            URL_GETFORMFACTORS: "/api/FormFactors/",
            URL_GETMMRECIPE: "/api/MMRecipes/",
            URL_GETMMRECIPES: "/api/MMRecipes/",
            URL_GETMMRECIPESREVIEWABLE: "/api/MMRecipes/GetReviewables/",
            URL_GETODMMATVERSIONDETAILS: "/api/ODMApi/GetMatVersionDetails/",
            URL_GETODMMATVERSIONS: "/api/ODMApi/GetMatVersions/",
            URL_GETODMPRFVERSIONDETAILS: "/api/ODMApi/GetPrfVersionDetails/",
            URL_GETODMPRFVERSIONS: "/api/ODMApi/GetPrfVersions/",
            URL_GETOSATBUILDCOMBINATIONS: "/api/Osat/GetBuildCombinations/",
            URL_GETOSATBUILDCOMBINATIONSBYOSATID: "/api/Osat/GetBuildCombinationsbyosatId/",            
            URL_GETODMQUALFILTERSCENARIO: "/api/ODMApi/GetQualFilterScenario/",
            URL_GETQUALFILTERHISTORICALSCENARIO: "/api/ODMApi/GetQualFilterHistoricalScenario/",
            URL_GETODMQUALFILTERSCENARIOVERSIONS: "/api/ODMApi/GetQualFilterScenarioVersions/",
            URL_GETODMQUALFILTERSCENARIOVERSIONSDAILY: "/api/ODMApi/GetQualFilterScenarioVersionsDaily/",
            URL_GETODMQUALFILTERSCENARIOHISTORICALVERSIONS: "/api/ODMApi/GetOdmQualFilterScenarioHistoricalVersions/",
            URL_GETQUALFILTERREMOVABLESLOTUPLOADS: "/api/ODMApi/GetQualFilterRemovableSLotUploads/",
            URL_GETOSATBUILDCRITERIASET: "/api/Osat/BuildCriteriaSet/",
            URL_GETOSATBUILDCRITERIASETDETAILS: "/api/Osat/BuildCriteriaSetDetails/",
            URL_GETOSATBUILDCRITERIASETS: "/api/Osat/BuildCriteriaSets",
            URL_GETALLREVIEWS: "/api/Osat/GetAllReviews",
            URL_GETOSATBUILDCRITERIASETANDVERSIONS: "/api/Osat/BuildCriteriaSetAndVersions/",
            URL_GETOSATPASVERSIONS: "/api/Osat/GetPasVersions/",
            URL_GETOSATQUALFILTERFILE: "/api/Osat/QualFilterFile/",
            URL_GETOSATQUALFILTERFILE_BULK_UPDATE: "/api/Osat/QualFilterFileBulkUpdate/",
            URL_GETPRODUCT: "/api/Products/",
            URL_GETPRODUCTFAMILIES: "/api/ProductFamilies/",
            URL_GETPRODUCTLABELS: "/api/ProductLabelSetVersions/GetProductLabels/",
            URL_GETPRODUCTLABELSETVERSIONS: "/api/ProductLabelSetVersions/",
            URL_GETSPEEDBOMDETAILSV2: "/api/Speed/BOMDetailsV2/",
            URL_GETSPEEDBOMEXPLOSIONDETAILSV2: "/api/Speed/BOMExplosionDetailsV2/",
            URL_GETSPEEDITEMCHARACTERISTICDETAILSV2: "/api/Speed/ItemCharacteristicDetailsV2/",
            URL_GETSPEEDITEMDETAILSV2: "/api/Speed/ItemDetailsV2/",
            URL_GETSPEEDITEMSOFTYPE: "/api/SpeedItems/OfType/",
            URL_GETLATESTODMQUALFILTER: "/api/ODMApi/GetLatestOdmQualFilter/",
            URL_GETMATS: "/api/MATVersions/GetMatsApi/",
            URL_GETMATVERSIONS: "/api/MATVersionsApi/",
            URL_GETMATVERSIONSACTIVE: "/api/MATVersionsApi/Active/",
            URL_GETTASKSOPEN: "/api/Tasks/Open/",
            URL_GETTASKSRECENT: "/api/Tasks/Recent/",
            URL_IMPORTMATRECORDS: "/api/ODMApi/ImportMat/",
            URL_IMPORTMATVERSION: "/api/MATVersionsApi/Import/",
            URL_IMPORTOSATPASVERSION: "/api/OSAT/ImportPasVersion/",
            URL_IMPORTOSATQUALFILTER: "/api/OSAT/ImportQualFilter/",
            URL_IMPORTOSATQUALFILTERBULKUPDATES: "/api/OSAT/ImportQualFilterBulkUpdates/",
            URL_PENDINGIMPORTOSATQUALFILTERBULKUPDATES: "/api/OSAT/PendingImportQualFilterBulkUpdates",
            URL_IMPORTPRFRECORDS: "/api/ODMApi/ImportPrf/",
            URL_IMPORTPRODUCTLABELSETVERSION: "/api/ProductLabelSetVersions/Import/",
            URL_PUBLISHSCENARIO: "/api/ODMApi/PublishScenario/",
            URL_RUNSCENARIO: "/api/ODMApi/RunScenario/",
            URL_RUNQUALFILTER: "/api/ODMApi/RunQualFilter/",
            URL_UPDATEAUTOCHECKERATTRIBUTETYPE: "/api/AutoCheckerApi/UpdateAttributeType/",
            URL_UPDATEAUTOCHECKERBUILDCRITERIAAPPROVED: "/api/AutoCheckerApi/ApproveBuildCriteria/",
            URL_UPDATEAUTOCHECKERBUILDCRITERIACANCELED: "/api/AutoCheckerApi/CancelBuildCriteria/",
            URL_UPDATEAUTOCHECKERBUILDCRITERIAREJECTED: "/api/AutoCheckerApi/RejectBuildCriteria/",
            URL_UPDATEAUTOCHECKERBUILDCRITERIASUBMITTED: "/api/AutoCheckerApi/SubmitBuildCriteria/",
            URL_UPDATEMATVERSIONAPPROVED: "/api/MATVersionsApi/Approve/",
            URL_UPDATEMATVERSIONCANCELED: "/api/MATVersionsApi/Cancel/",
            URL_UPDATEMATVERSIONREJECTED: "/api/MATVersionsApi/Reject/",
            URL_UPDATEMATVERSIONSUBMITTED: "/api/MATVersionsApi/Submit/",
            URL_UPDATEMMRECIPE: "/api/MMRecipes/Update/",
            URL_UPDATEMMRECIPEAPPROVED: "/api/MMRecipes/Approve/",
            URL_UPDATEMMRECIPECANCELED: "/api/MMRecipes/Cancel/",
            URL_UPDATEMMRECIPEREJECTED: "/api/MMRecipes/Reject/",
            URL_UPDATEMMRECIPESUBMITTED: "/api/MMRecipes/Submit/",
            URL_UPDATEOSATATTRIBUTETYPE: "/api/Osat/UpdateAttributeType/",
            URL_UPDATEOSATBUILDCOMBINATIONPUBLISH: "/api/Osat/UpdateBuildCombinationPublish/",
            URL_UPDATEOSATBUILDCRITERIASETAPPROVED: "/api/Osat/ApproveBuildCriteriaSet/",
            URL_UPDATEOSATBUILDCRITERIASETCANCELED: "/api/Osat/CancelBuildCriteriaSet/",
            URL_UPDATEOSATBUILDCRITERIASETREJECTED: "/api/Osat/RejectBuildCriteriaSet/",
            URL_UPDATEOSATBUILDCRITERIASETSUBMITTED: "/api/Osat/SubmitBuildCriteriaSet/",
            URL_UPDATEOSATBUILDCRITERIASETSAPPROVED: "/api/Osat/ApproveBuildCriteriaSets/",
            URL_UPDATEOSATBUILDCRITERIASETSCANCELED: "/api/Osat/CancelBuildCriteriaSets/",
            URL_UPDATEOSATBUILDCRITERIASETSREJECTED: "/api/Osat/RejectBuildCriteriaSets/",
            URL_UPDATEOSATBUILDCRITERIASETSSUBMITTED: "/api/Osat/SubmitBuildCriteriaSets/",
            URL_UPDATEOSATPASVERSIONCANCELED: "/api/Osat/CancelPasVersion/",
            URL_UPDATEOSATPASVERSIONSUBMITTED: "/api/Osat/SubmitPasVersion/",
            URL_UPDATEOSATQUALFILTERIMPORTCANCELED: "/api/Osat/UpdateQualFilterImportCanceled/",
            URL_UPDATEOSATQUALFILTERIMPORTPOR: "/api/Osat/UpdateQualFilterImportPor/",
            URL_UPDATEPRODUCTLABELSETVERSIONAPPROVED: "/api/ProductLabelSetVersions/Approve/",
            URL_UPDATEPRODUCTLABELSETVERSIONCANCELED: "/api/ProductLabelSetVersions/Cancel/",
            URL_UPDATEPRODUCTLABELSETVERSIONREJECTED: "/api/ProductLabelSetVersions/Reject/",
            URL_UPDATEPRODUCTLABELSETVERSIONSUBMITTED: "/api/ProductLabelSetVersions/Submit/",
            URL_UPDATETASKRESOLVED: "/api/Tasks/Resolve/",
            URL_UPDATETASKSRESOLVEALLABORTED: "/api/Tasks/ResolveAllAborted/",
            URL_UPDATETASKUNRESOLVED: "/api/Tasks/Unresolve/",
            URL_GETODMLOTWIPDETAILS: "/api/ODMApi/GetOdmLotWipDetails/",
            URL_GETPROHIBITEDTIMERANGES: "/api/ODMApi/GetProhibitedTimeRanges/",
            URL_GETREMOVABLESLOTDETAILS: "/api/ODMApi/GetRemovableSLotDetails/",
            URL_IMPORTODMDISPOSITIONS: "/api/ODMApi/ImportDispositions/",
            URL_CLEARARCHIVEODMMANUALDISPOSITION: "/api/ODMApi/ClearArchiveOdmManualDisposition/",
            URL_GETDISPOSITIONSBYVERSION: "/api/ODMApi/GetDispositionsByVersion/",
            URL_CREATEPRODUCTOWNERSHIP: "/api/ProductOwnership/CreateProductOwnership/",
            URL_DELETEPRODUCTOWNERSHIP: "/api/ProductOwnership/DeleteProductOwnership/",
            URL_UPDATEPRODUCTOWNERSHIP: "/api/ProductOwnership/UpdateProductOwnership/",
            URL_CREATEACCOUNTOWNERSHIP: "/api/AccountOwnership/CreateAccountOwnership/",
            URL_UPDATEACCOUNTOWNERSHIP: "/api/AccountOwnership/UpdateAccountOwnership/",
            URL_DELETEACCOUNTOWNERSHIP: "/api/AccountOwnership/DeleteAccountOwnership/",
            URL_GETAPPROVERLIST: "/api/PCNApprover/GetApproverList/",
            URL_GETPCNMANAGERAPPROVERLIST: "/api/PCNManagerFinder/GetApproverList/"
            // Add new constants here
        };
    }(),
    Administration: function () {
        // private methods
        var _getPreferredRole = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_ADMINISTRATIONGETPREFERREDROLE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _savePreferredRole = function (currentSelectedRole, onSuccess, onError, onSend, onComplete) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_ADMINISTRATIONSAVEPREFERREDROLE + currentSelectedRole,
                onSend,
                onComplete,
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                },
                true
            );
        };

        // public methods
        return {
            getPreferredRole: function (onSuccess, OnError) {
                _getPreferredRole(onSuccess, OnError);
            },
            savePreferredRole: function (entity, onSuccess, OnError, onSend, onComplete) {
                _savePreferredRole(entity, onSuccess, OnError, onSend, onComplete);
            },
        };
    }(),
    AutoChecker: function () {
        // private methods
        var _approveBuildCriteria = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEAUTOCHECKERBUILDCRITERIAAPPROVED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _cancelBuildCriteria = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEAUTOCHECKERBUILDCRITERIACANCELED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _createAttributeType = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEAUTOCHECKERATTRIBUTETYPE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _createBuildCriteria = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEAUTOCHECKERBUILDCRITERIA,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _createBuildCriteriaComment = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEAUTOCHECKERBUILDCRITERIACOMMENT,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getBuildCriteria = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETAUTOCHECKERBUILDCRITERIA + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getBuildCriteriaDetails = function (id, idCompare, onSuccess, onError) {
            var url = Nsga.Callisto.Constants.URL_GETAUTOCHECKERBUILDCRITERIADETAILS + id;
            if (idCompare) {
                url += "?idCompare=" + idCompare;
            }
            Nsga.Framework.getDataToUrl(
                null,
                url,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getBuildCriteriaAndVersions = function (designId, fabricationFacilityId, testFlowId, probeConversionId, onSuccess, onError) {
            if (designId === null || designId === undefined) designId = "";
            if (fabricationFacilityId === null || fabricationFacilityId === undefined) fabricationFacilityId = "";
            if (testFlowId === null || testFlowId === undefined) testFlowId = "";
            if (probeConversionId === null || probeConversionId === undefined) probeConversionId = "";
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETAUTOCHECKERBUILDCRITERIAANDVERSIONS + "?designId=" + designId + "&fabricationFacilityId=" + fabricationFacilityId + "&testFlowId=" + testFlowId + "&probeConversionId=" + probeConversionId,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _rejectBuildCriteria = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEAUTOCHECKERBUILDCRITERIAREJECTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _submitBuildCriteria = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEAUTOCHECKERBUILDCRITERIASUBMITTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _updateAttributeType = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEAUTOCHECKERATTRIBUTETYPE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            approveBuildCriteria: function (entity, onSuccess, OnError) {
                _approveBuildCriteria(entity, onSuccess, OnError);
            },
            cancelBuildCriteria: function (entity, onSuccess, OnError) {
                _cancelBuildCriteria(entity, onSuccess, OnError);
            },
            createAttributeType: function (entity, onSuccess, OnError) {
                _createAttributeType(entity, onSuccess, OnError);
            },
            createBuildCriteria: function (entity, onSuccess, OnError) {
                _createBuildCriteria(entity, onSuccess, OnError);
            },
            createBuildCriteriaComment: function (entity, onSuccess, OnError) {
                _createBuildCriteriaComment(entity, onSuccess, OnError);
            },
            getBuildCriteria: function (id, onSuccess, OnError) {
                _getBuildCriteria(id, onSuccess, OnError);
            },
            getBuildCriteriaDetails: function (id, idCompare, onSuccess, OnError) {
                _getBuildCriteriaDetails(id, idCompare, onSuccess, OnError);
            },
            getBuildCriteriaAndVersions: function (designId, fabricationFacilityId, testFlowId, probeConversionId, onSuccess, OnError) {
                _getBuildCriteriaAndVersions(designId, fabricationFacilityId, testFlowId, probeConversionId, onSuccess, OnError);
            },
            rejectBuildCriteria: function (entity, onSuccess, OnError) {
                _rejectBuildCriteria(entity, onSuccess, OnError);
            },
            submitBuildCriteria: function (entity, onSuccess, OnError) {
                _submitBuildCriteria(entity, onSuccess, OnError);
            },
            updateAttributeType: function (entity, onSuccess, OnError) {
                _updateAttributeType(entity, onSuccess, OnError);
            },
        };
    }(),
    Customers: function () {
        // private methods
        var _getAll = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETCUSTOMERS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            getAll: function (onSuccess, OnError) {
                _getAll(onSuccess, OnError);
            },
        };
    }(),
    FormFactors: function () {
        // private methods
        var _getAll = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETFORMFACTORS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            getAll: function (onSuccess, OnError) {
                _getAll(onSuccess, OnError);
            },
        };
    }(),
    MATVersions: function () {
        // private methods
        var _approve = function (review, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                review,
                Nsga.Callisto.Constants.URL_UPDATEMATVERSIONAPPROVED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _cancel = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEMATVERSIONCANCELED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _reject = function (review, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                review,
                Nsga.Callisto.Constants.URL_UPDATEMATVERSIONREJECTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _submit = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                { 'id': id },
                Nsga.Callisto.Constants.URL_UPDATEMATVERSIONSUBMITTED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getMATs = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETMATS + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getActive = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETMATVERSIONSACTIVE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getAll = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETMATVERSIONS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            approve: function (review, onSuccess, OnError) {
                _approve(review, onSuccess, OnError);
            },
            cancel: function (id, onSuccess, OnError) {
                _cancel(id, onSuccess, OnError);
            },
            reject: function (review, onSuccess, OnError) {
                _reject(review, onSuccess, OnError);
            },
            submit: function (id, onSuccess, OnError) {
                _submit(id, onSuccess, OnError);
            },
            getMATs: function (id, onSuccess, OnError) {
                _getMATs(id, onSuccess, OnError);
            },
            getActive: function (id, onSuccess, OnError) {
                _getActive(id, onSuccess, OnError);
            },
            getAll: function (id, onSuccess, OnError) {
                _getAll(id, onSuccess, OnError);
            },
            getActive: function (productId, onSuccess, OnError) {
                _getActive(productId, onSuccess, OnError);
            },
        };
    }(),
    MMRecipes: function () {
        // private methods
        var _approve = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEMMRECIPEAPPROVED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _cancel = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEMMRECIPECANCELED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _get = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETMMRECIPE + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getAll = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETMMRECIPES,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getReviewables = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETMMRECIPESREVIEWABLE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _reject = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEMMRECIPEREJECTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _submit = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEMMRECIPESUBMITTED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _update = function (model, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(model),
                Nsga.Callisto.Constants.URL_UPDATEMMRECIPE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            approve: function (entity, onSuccess, OnError) {
                _approve(entity, onSuccess, OnError);
            },
            cancel: function (id, onSuccess, OnError) {
                _cancel(id, onSuccess, OnError);
            },
            get: function (id, onSuccess, OnError) {
                _get(id, onSuccess, OnError);
            },
            getAll: function (onSuccess, OnError) {
                _getAll(onSuccess, OnError);
            },
            getReviewables: function (onSuccess, OnError) {
                _getReviewables(onSuccess, OnError);
            },
            reject: function (entity, onSuccess, OnError) {
                _reject(entity, onSuccess, OnError);
            },
            submit: function (id, onSuccess, OnError) {
                _submit(id, onSuccess, OnError);
            },
            update: function (model, onSuccess, OnError) {
                _update(model, onSuccess, OnError);
            },
        };
    }(),
    Odm: function () {
        // private methods
        var _saveLotDispositions = function (entity, onSuccess, onError, onSend, onComplete) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_SAVEODMLOTDISPOSITIONS,
                onSend,
                onComplete,
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                },
                true
            );
        };
        var _createLotDisposition = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEODMLOTDISPOSITION,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getLatestOdmQualFilter = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETLATESTODMQUALFILTER,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getMatVersionDetails = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMMATVERSIONDETAILS + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getMatVersions = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMMATVERSIONS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getPrfVersionDetails = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMPRFVERSIONDETAILS + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getPrfVersions = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMPRFVERSIONS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getQualFilterScenario = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMQUALFILTERSCENARIO + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getQualFilterHistoricalScenario = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETQUALFILTERHISTORICALSCENARIO + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getQualFilterScenarioVersions = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMQUALFILTERSCENARIOVERSIONS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getQualFilterScenarioVersionsDaily = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMQUALFILTERSCENARIOVERSIONSDAILY,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getOdmQualFilterScenarioHistoricalVersions = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETODMQUALFILTERSCENARIOHISTORICALVERSIONS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getQualFilterRemovableSLotUploads = function (loadToDate, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETQUALFILTERREMOVABLESLOTUPLOADS + loadToDate,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _checkProhibitedScenarioRunTime = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_CHECKPROHIBITEDSCENARIORUNTIME,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };

        var _runScenario = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_RUNSCENARIO,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _publishScenario = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_PUBLISHSCENARIO + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _clearArchiveOdmManualDisposition = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_CLEARARCHIVEODMMANUALDISPOSITION,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getProhibitedTimeRanges = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETPROHIBITEDTIMERANGES,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getRemovableSLotDetails = function (version, odmName, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETREMOVABLESLOTDETAILS + '?version=' + version + '&odmName=' + odmName,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getDispositionsByVersion = function (versionId, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETDISPOSITIONSBYVERSION + versionId,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        // public methods
        return {
            saveLotDispositions: function (entity, onSuccess, OnError, onSend, onComplete) {
                _saveLotDispositions(entity, onSuccess, OnError, onSend, onComplete);
            },
            createLotDisposition: function (entity, onSuccess, OnError) {
                _createLotDisposition(entity, onSuccess, OnError);
            },
            getLatestOdmQualFilter: function (onSuccess, OnError) {
                _getLatestOdmQualFilter(onSuccess, OnError);
            },
            getMatVersionDetails: function (id, onSuccess, OnError) {
                _getMatVersionDetails(id, onSuccess, OnError);
            },
            getMatVersions: function (onSuccess, OnError) {
                _getMatVersions(onSuccess, OnError);
            },
            getPrfVersionDetails: function (id, onSuccess, OnError) {
                _getPrfVersionDetails(id, onSuccess, OnError);
            },
            getPrfVersions: function (onSuccess, OnError) {
                _getPrfVersions(onSuccess, OnError);
            },
            getQualFilterScenario: function(id, onSuccess, OnError) {
                _getQualFilterScenario(id, onSuccess, OnError);
            },
            getQualFilterHistoricalScenario: function(id, onSuccess, OnError) {
                _getQualFilterHistoricalScenario(id, onSuccess, OnError);
            },
            getQualFilterScenarioVersions: function (onSuccess, OnError) {
                _getQualFilterScenarioVersions(onSuccess, OnError);
            },
            getQualFilterScenarioVersionsDaily: function (onSuccess, OnError) {
                _getQualFilterScenarioVersionsDaily(onSuccess, OnError);
            },
            getOdmQualFilterScenarioHistoricalVersions: function (onSuccess, OnError) {
                _getOdmQualFilterScenarioHistoricalVersions(onSuccess, OnError);
            },
            getQualFilterRemovableSLotUploads: function (loadToDate, onSuccess, OnError) {
                _getQualFilterRemovableSLotUploads(loadToDate, onSuccess, OnError);
            },
            checkProhibitedScenarioRunTime: function (onSuccess, OnError) {
                _checkProhibitedScenarioRunTime(onSuccess, OnError);
            },
            runScenario: function (onSuccess, onError) {
                _runScenario(onSuccess, onError);
            },
            publishScenario: function (id, onSuccess, OnError) {
                _publishScenario(id, onSuccess, OnError);
            },
            getOdmLotWipDetails: function (sLot, mediaIPN, sCode, odmName, onSuccess, onError) {
                _getOdmLotWipDetails(sLot, mediaIPN, sCode, odmName, onSuccess, onError);
            },
            getRemovableSLotDetails: function (version, odmName, onSuccess, onError) {
                _getRemovableSLotDetails(version, odmName, onSuccess, onError);
            },
            getProhibitedTimeRanges: function (onSuccess, OnError) {
                _getProhibitedTimeRanges(onSuccess, OnError);
            },
            clearArchiveOdmManualDisposition: function (onSuccess, onError) {
                _clearArchiveOdmManualDisposition(onSuccess, onError);
            },
            getDispositionsByVersion: function (versionId, onSuccess, onError) {
                _getDispositionsByVersion(versionId, onSuccess, onError);
            },            
        };
    }(),
    Osat: function () {
        // private methods
        var _approveBuildCriteriaSet = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETAPPROVED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _approveBuildCriteriaSets = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETSAPPROVED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _cancelBuildCriteriaSet = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETCANCELED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _cancelBuildCriteriaSets = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETSCANCELED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _cancelPasVersion = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEOSATPASVERSIONCANCELED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _createAttributeType = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEOSATATTRIBUTETYPE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _createBuildCriteriaSet = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEOSATBUILDCRITERIASET,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _createBuildCriteriaSetComment = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEOSATBUILDCRITERIASETCOMMENT,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _createQualFilterExport = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEOSATQUALFILTEREXPORT,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getBuildCombinations = function (designId, porBuildCriteriaSetExists, onSuccess, onError) {
            if (typeof porBuildCriteriaSetExists == "boolean") { } else { porBuildCriteriaSetExists = ""; }
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETOSATBUILDCOMBINATIONS + designId + "?porBuildCriteriaSetExists=" + porBuildCriteriaSetExists,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };

        var _getBuildCombinations2 = function (designId, osatId, porBuildCriteriaSetExists, onSuccess, onError) {
           
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETOSATBUILDCOMBINATIONSBYOSATID + "?designId=" + designId + "&osatId=" + osatId + "&porBuildCriteriaSetExists=" + porBuildCriteriaSetExists,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getBuildCriteriaSet = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETOSATBUILDCRITERIASET + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getBuildCriteriaSets = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_GETOSATBUILDCRITERIASETS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getAllReviews = function (ids, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(ids),
                Nsga.Callisto.Constants.URL_GETALLREVIEWS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getBuildCriteriaSetDetails = function (id, idCompare, onSuccess, onError) {
            var url = Nsga.Callisto.Constants.URL_GETOSATBUILDCRITERIASETDETAILS + id;
            if (idCompare) {
                url += "?idCompare=" + idCompare;
            }
            Nsga.Framework.getDataToUrl(
                null,
                url,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getBuildCriteriaSetAndVersions = function (buildCombinationId, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETOSATBUILDCRITERIASETANDVERSIONS + buildCombinationId,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getPasVersions = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETOSATPASVERSIONS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getQualFilterFile = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_GETOSATQUALFILTERFILE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _getQualFilterFileBulkUpdate = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_GETOSATQUALFILTERFILE_BULK_UPDATE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        }; 
        var _rejectBuildCriteriaSet = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETREJECTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _rejectBuildCriteriaSets = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETSREJECTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _submitBuildCriteriaSet = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETSUBMITTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _submitBuildCriteriaSets = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCRITERIASETSSUBMITTED,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _submitPasVersion = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEOSATPASVERSIONSUBMITTED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _updateAttributeType = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATATTRIBUTETYPE,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _updateBuildCombinationPublish = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEOSATBUILDCOMBINATIONPUBLISH,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _updateQualFilterImportCanceled = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEOSATQUALFILTERIMPORTCANCELED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };
        var _updateQualFilterImportPor = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEOSATQUALFILTERIMPORTPOR + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                }
            );
        };

        // public methods
        return {
            approveBuildCriteriaSet: function (entity, onSuccess, OnError) {
                _approveBuildCriteriaSet(entity, onSuccess, OnError);
            },
            approveBuildCriteriaSets: function (entity, onSuccess, OnError) {
                _approveBuildCriteriaSets(entity, onSuccess, OnError);
            },
            cancelBuildCriteriaSet: function (entity, onSuccess, OnError) {
                _cancelBuildCriteriaSet(entity, onSuccess, OnError);
            },
            cancelBuildCriteriaSets: function (entity, onSuccess, OnError) {
                _cancelBuildCriteriaSets(entity, onSuccess, OnError);
            },
            cancelPasVersion: function (id, onSuccess, OnError) {
                _cancelPasVersion(id, onSuccess, OnError);
            },
            createAttributeType: function (entity, onSuccess, OnError) {
                _createAttributeType(entity, onSuccess, OnError);
            },
            createBuildCriteriaSet: function (entity, onSuccess, OnError) {
                _createBuildCriteriaSet(entity, onSuccess, OnError);
            },
            createBuildCriteriaSetComment: function (entity, onSuccess, OnError) {
                _createBuildCriteriaSetComment(entity, onSuccess, OnError);
            },
            createQualFilterExport: function (entity, onSuccess, OnError) {
                _createQualFilterExport(entity, onSuccess, OnError);
            },
            getBuildCombinations: function (designId, onSuccess, OnError) {
                _getBuildCombinations(designId, null, onSuccess, OnError);
            },
            getBuildCombinations2: function (designId, porBuildCriteriaSetExists, onSuccess, OnError) {
                _getBuildCombinations(designId, porBuildCriteriaSetExists, onSuccess, OnError);
            },
            getBuildCombinations3: function (designId, osatId, porBuildCriteriaSetExists, onSuccess, OnError) {
                _getBuildCombinations2(designId, osatId, porBuildCriteriaSetExists, onSuccess, OnError);
            },
            getBuildCriteriaSet: function (id, onSuccess, OnError) {
                _getBuildCriteriaSet(id, onSuccess, OnError);
            },
            getBuildCriteriaSetDetails: function (id, idCompare, onSuccess, OnError) {
                _getBuildCriteriaSetDetails(id, idCompare, onSuccess, OnError);
            },
            getBuildCriteriaSets: function (entity, onSuccess, OnError) {
                _getBuildCriteriaSets(entity, onSuccess, OnError);
            },
            getAllReviews: function (entity, onSuccess, OnError) {
                _getAllReviews(entity, onSuccess, OnError);
            },
            getBuildCriteriaSetAndVersions: function (buildCombinationId, onSuccess, OnError) {
                _getBuildCriteriaSetAndVersions(buildCombinationId, onSuccess, OnError);
            },
            getPasVersions: function (onSuccess, OnError) {
                _getPasVersions(onSuccess, OnError);
            },
            getQualFilterFile: function (entity, onSuccess, OnError) {
                _getQualFilterFile(entity, onSuccess, OnError);
            },
            getQualFilterFileBulkUpdate: function (entity, onSuccess, OnError) {
                _getQualFilterFileBulkUpdate(entity, onSuccess, OnError);
            },
            rejectBuildCriteriaSet: function (entity, onSuccess, OnError) {
                _rejectBuildCriteriaSet(entity, onSuccess, OnError);
            },
            rejectBuildCriteriaSets: function (entity, onSuccess, OnError) {
                _rejectBuildCriteriaSets(entity, onSuccess, OnError);
            },
            submitBuildCriteriaSet: function (entity, onSuccess, OnError) {
                _submitBuildCriteriaSet(entity, onSuccess, OnError);
            },
            submitBuildCriteriaSets: function (entity, onSuccess, OnError) {
                _submitBuildCriteriaSets(entity, onSuccess, OnError);
            },
            submitPasVersion: function (id, onSuccess, OnError) {
                _submitPasVersion(id, onSuccess, OnError);
            },
            updateAttributeType: function (entity, onSuccess, OnError) {
                _updateAttributeType(entity, onSuccess, OnError);
            },
            updateBuildCombinationPublish: function (entity, onSuccess, OnError) {
                _updateBuildCombinationPublish(entity, onSuccess, OnError);
            },
            updateQualFilterImportCanceled: function (id, onSuccess, OnError) {
                _updateQualFilterImportCanceled(id, onSuccess, OnError);
            },
            updateQualFilterImportPor: function (id, onSuccess, OnError) {
                _updateQualFilterImportPor(id, onSuccess, OnError);
            },
        };
    }(),
    ProductFamilies: function () {
        // private methods
        var _getAll = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETPRODUCTFAMILIES,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            getAll: function (onSuccess, OnError) {
                _getAll(onSuccess, OnError);
            },
        };
    }(),
    ProductLabelSetVersions: function () {
        // private methods
        var _approve = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEPRODUCTLABELSETVERSIONAPPROVED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _cancel = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEPRODUCTLABELSETVERSIONCANCELED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _reject = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEPRODUCTLABELSETVERSIONREJECTED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _submit = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATEPRODUCTLABELSETVERSIONSUBMITTED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getProductLabels = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETPRODUCTLABELS + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getAll = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETPRODUCTLABELSETVERSIONS,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            approve: function (id, onSuccess, OnError) {
                _approve(id, onSuccess, OnError);
            },
            cancel: function (id, onSuccess, OnError) {
                _cancel(id, onSuccess, OnError);
            },
            reject: function (id, onSuccess, OnError) {
                _reject(id, onSuccess, OnError);
            },
            submit: function (id, onSuccess, OnError) {
                _submit(id, onSuccess, OnError);
            },
            getProductLabels: function (id, onSuccess, OnError) {
                _getProductLabels(id, onSuccess, OnError);
            },
            getAll: function (onSuccess, OnError) {
                _getAll(onSuccess, OnError);
            },
        };
    }(),
    Products: function () {
        // private methods
        var _getProduct = function (id, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETPRODUCT + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            getProduct: function (id, onSuccess, OnError) {
                _getProduct(id, onSuccess, OnError);
            },
        };
    }(),
    Speed: function () {
        // private methods
        var _getBOMDetailsV2 = function (itemId, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETSPEEDBOMDETAILSV2 + itemId,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getBOMExplosionDetailsV2 = function (itemId, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETSPEEDBOMEXPLOSIONDETAILSV2 + itemId,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getItemCharacteristicDetailsV2 = function (itemId, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETSPEEDITEMCHARACTERISTICDETAILSV2 + itemId,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getItemDetailsV2 = function (itemId, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETSPEEDITEMDETAILSV2 + itemId,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            getBOMDetailsV2: function (itemId, onSuccess, OnError) {
                _getBOMDetailsV2(itemId, onSuccess, OnError);
            },
            getBOMExplosionDetailsV2: function (itemId, onSuccess, OnError) {
                _getBOMExplosionDetailsV2(itemId, onSuccess, OnError);
            },
            getItemCharacteristicDetailsV2: function (itemId, onSuccess, OnError) {
                _getItemCharacteristicDetailsV2(itemId, onSuccess, OnError);
            },
            getItemDetailsV2: function (itemId, onSuccess, OnError) {
                _getItemDetailsV2(itemId, onSuccess, OnError);
            },
        };
    }(),
    SpeedItems: function () {
        // private methods
        var _ofType = function (type, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETSPEEDITEMSOFTYPE + type,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            ofType: function (type, onSuccess, OnError) {
                _ofType(type, onSuccess, OnError);
            },
        };
    }(),
    Tasks: function () {
        // private methods
        var _getOpen = function (onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETTASKSOPEN,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _getRecent = function (days, onSuccess, onError) {
            Nsga.Framework.getDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_GETTASKSRECENT + days,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _resolve = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATETASKRESOLVED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _resolveAllAborted = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATETASKSRESOLVEALLABORTED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _unresolve = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_UPDATETASKUNRESOLVED + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        // public methods
        return {
            getOpen: function (onSuccess, OnError) {
                _getOpen(onSuccess, OnError);
            },
            getRecent: function (days, onSuccess, OnError) {
                _getRecent(days, onSuccess, OnError);
            },
            resolve: function (id, onSuccess, OnError) {
                _resolve(id, onSuccess, OnError);
            },
            resolveAllAborted: function (id, onSuccess, OnError) {
                _resolveAllAborted(id, onSuccess, OnError);
            },
            unresolve: function (id, onSuccess, OnError) {
                _unresolve(id, onSuccess, OnError);
            },
        };
    }(),
    Dates: function () {
        return {
            isoToLocaleString: function (value) {
                if (value == null) return "";
                var dt = new Date(value);
                return dt.toLocaleString();
            },
        };
    }(),
    Dx: function () {
        var _dataGridDefaultConfig = function () {
            return {
                columnAutoWidth: true,
                showColumnLines: true,
                showRowLines: true,
                rowAlternationEnabled: true,
                showBorders: true,
                headerFilter: { visible: true },
                filterRow: { visible: true },
                loadPanel: {
                    enabled: true
                },
                paging: { enabled: false },
                editing: {
                    mode: "row",
                    allowUpdating: false,
                    allowDeleting: false,
                    allowAdding: false,
                    useIcons: true
                },
                wordWrapEnabled: true,
            };
        };

        return {
            dataGridDefaultConfig: function () {
                return _dataGridDefaultConfig();
            },
        };
    }(),
    ProductOwnership: function () {
        // private methods
        var _createProductOwnership = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEPRODUCTOWNERSHIP,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _deleteProductOwnership = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_DELETEPRODUCTOWNERSHIP + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        var _updateProductOwnership = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEPRODUCTOWNERSHIP,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        // public methods
        return {
            createProductOwnership: function (entity, onSuccess, OnError) {
                _createProductOwnership(entity, onSuccess, OnError);
            },
            deleteProductOwnership: function (id, onSuccess, OnError) {
                _deleteProductOwnership(id, onSuccess, OnError);
            },
            updateProductOwnership: function (entity, onSuccess, OnError) {
                _updateProductOwnership(entity, onSuccess, OnError);
            },
        };
    }(),
    AccountOwnership: function () {
        var _createAccountOwnership = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_CREATEACCOUNTOWNERSHIP,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        var _updateAccountOwnership = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_UPDATEACCOUNTOWNERSHIP,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        var _deleteAccountOwnership = function (id, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                null,
                Nsga.Callisto.Constants.URL_DELETEACCOUNTOWNERSHIP + id,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };

        return {
            createAccountOwnership: function (entity, onSuccess, OnError) {
                _createAccountOwnership(entity, onSuccess, OnError);
            },
            updateAccountOwnership: function (entity, onSuccess, OnError) {
                _updateAccountOwnership(entity, onSuccess, OnError);
            },
            deleteAccountOwnership: function (id, onSuccess, OnError) {
                _deleteAccountOwnership(id, onSuccess, OnError);
            },
        };
    }(),
    PCNApprovers: function () {
        // private methods
        var _getApproverList = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_GETAPPROVERLIST,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        return {
            getApproverList: function (entity, onSuccess, OnError) {
                _getApproverList(entity, onSuccess, OnError);
            },
        };
    }(),
    PCNManagerFinder: function () {
        // private methods
        var _getApproverList = function (entity, onSuccess, onError) {
            Nsga.Framework.postDataToUrl(
                JSON.stringify(entity),
                Nsga.Callisto.Constants.URL_GETPCNMANAGERAPPROVERLIST,
                function () { },
                function () { },
                function (result) {
                    onSuccess(result);
                },
                function (xhr, status) {
                    onError(xhr, status);
                });
        };
        return {
            getApproverList: function (entity, onSuccess, OnError) {
                _getApproverList(entity, onSuccess, OnError);
            },
        };
    }(),
};

var includes = function (container, value) {
    var result = false;
    if (container) {
        var position = container.indexOf(value);
        if (position >= 0) result = true;
    }
    return result;
}

var isEven = function (n) {
    return n === parseFloat(n) ? !(n % 2) : void 0;
};
