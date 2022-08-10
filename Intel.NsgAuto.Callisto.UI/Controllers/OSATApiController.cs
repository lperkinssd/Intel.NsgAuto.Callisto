using System.Collections.Generic;
using Intel.NsgAuto.Callisto.Business.Applications;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.Osat;
using Intel.NsgAuto.Callisto.Business.Entities.Osat.Workflows;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.UI.Models.OSAT;
using Intel.NsgAuto.Shared.Extensions;
using Intel.NsgAuto.Web.Mvc.Core;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    [RoutePrefix("api/Osat")]
    public class OSATApiController : ApiController
    {
        [HttpPost]
        [Route("CancelPasVersion/{id:int}")]
        public IHttpActionResult CancelPasVersion(int id)
        {
            var result = new OsatService().CancelPasVersion(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("CreateAttributeType")]
        public IHttpActionResult CreateAttributeType(AttributeTypeCreateDto entity)
        {
            EntitySingleMessageResult<AttributeTypes> result = new OsatService().CreateAttributeType(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("CreateBuildCriteriaSet")]
        public IHttpActionResult CreateBuildCriteriaSet(BuildCriteriaSetCreateDto entity)
        {
            var result = new OsatService().CreateBuildCriteriaSet(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("CreateBuildCriteriaSetComment")]
        public IHttpActionResult CreateBuildCriteriaSetComment(BuildCriteriaSetCommentCreateDto entity)
        {
            var result = new OsatService().CreateBuildCriteriaSetComment(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpGet]
        [Route("BuildCriteriaSet/{id:long}")]
        public IHttpActionResult GetBuildCriteriaSet(long id)
        {
            BuildCriteriaSet result = new OsatService().GetBuildCriteriaSet(Functions.GetLoggedInUserId(), id);
            return Ok(result);
        }

        [HttpGet]
        [Route("BuildCriteriaSetDetails/{id:long}")]
        public IHttpActionResult GetBuildCriteriaSetDetails(long id, long? idCompare = null)
        {
            BuildCriteriaSetDetails result = new OsatService().GetBuildCriteriaSetDetails(Functions.GetLoggedInUserId(), id, idCompare);
            return Ok(result);
        }

        [HttpPost]
        [Route("BuildCriteriaSets")]
        public IHttpActionResult GetBuildCriteriaSets([FromBody] long[] ids)
        {
            var result = new OsatService().GetBuildCriteriaSets(ids.ToList());
            return Ok(result);
        }

        [HttpGet]
        [Route("BuildCriteriaSetAndVersions/{buildCombinationId:int}")]
        public IHttpActionResult GetBuildCriteriaSetAndVersions(int buildCombinationId)
        {
            BuildCriteriaSetAndVersions result = new OsatService().GetBuildCriteriaSetAndVersions(Functions.GetLoggedInUserId(), buildCombinationId);
            return Ok(result);
        }

        [HttpPost]
        [Route("ApproveBuildCriteriaSet")]
        public IHttpActionResult ApproveBuildCriteriaSet(ReviewDecisionDto decision)
        {
            var result = new OsatService().ApproveBuildCriteriaSet(Functions.GetLoggedInUserId(), decision,false,true);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("ApproveBuildCriteriaSets")]
        public IHttpActionResult ApproveBuildCriteriaSets([FromBody] ReviewDecisionDto[] decisions)
        {
            var osatSvc = new OsatService();
            var results = decisions.OrderByDescending(x => x.VersionId).Select(decision => osatSvc.ApproveBuildCriteriaSet(Functions.GetLoggedInUserId(), decision, true, decision.Selected)).ToList();

            if (results.All(x => x.Succeeded)) return Ok(results.OrderByDescending(x => x.Entity.BuildCriteriaSet.UpdatedOn).First(x => x.Entity.BuildCriteriaSet.Id == decisions.First(j => j.Selected).VersionId).Entity.Review);

            return Content(HttpStatusCode.BadRequest, results.First(x => !x.Succeeded));
        }

        [HttpPost]
        [Route("CancelBuildCriteriaSet")]
        public IHttpActionResult CancelBuildCriteriaSet(DraftDecisionDto decision)
        {
            var result = new OsatService().CancelBuildCriteriaSet(Functions.GetLoggedInUserId(), decision, false, true);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("CancelBuildCriteriaSets")]
        public IHttpActionResult CancelBuildCriteriaSets([FromBody] DraftDecisionDto[] decisions)
        {
            var osatSvc = new OsatService();
            var results = decisions.Select(decision => osatSvc.CancelBuildCriteriaSet(Functions.GetLoggedInUserId(), decision, true, decision.Selected)).ToList();

            if (results.All(x => x.Succeeded)) return Ok(results.First().Entity.Review);

            return Content(HttpStatusCode.BadRequest, results.First(x => !x.Succeeded));
        }

        [HttpPost]
        [Route("RejectBuildCriteriaSet")]
        public IHttpActionResult RejectBuildCriteriaSet(ReviewDecisionDto decision)
        {
            var result = new OsatService().RejectBuildCriteriaSet(Functions.GetLoggedInUserId(), decision,false,true);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("RejectBuildCriteriaSets")]
        public IHttpActionResult RejectBuildCriteriaSets([FromBody] ReviewDecisionDto[] decisions)
        {
            var osatSvc = new OsatService();
            var results = decisions.OrderByDescending(x => x.VersionId).Select(decision => osatSvc.RejectBuildCriteriaSet(Functions.GetLoggedInUserId(), decision,true,decision.Selected)).ToList();

            if (results.All(x => x.Succeeded)) return Ok(results.Single(x => x.Entity.BuildCriteriaSet.Id == decisions.Single(j => j.Selected).VersionId).Entity.Review);

            return Content(HttpStatusCode.BadRequest, results.First(x => !x.Succeeded));
        }

        [HttpPost]
        [Route("SubmitBuildCriteriaSet")]
        public IHttpActionResult SubmitBuildCriteriaSet(DraftDecisionDto decision)
        {
            var result = new OsatService().SubmitBuildCriteriaSet(Functions.GetLoggedInUserId(), decision, false, true,"");
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("SubmitBuildCriteriaSets")]
        public IHttpActionResult SubmitBuildCriteriaSets([FromBody] DraftDecisionDtoText[] decisionsText)
        {
            var osatSvc = new OsatService();
            var decisions = decisionsText.Select(y => new DraftDecisionDto { DecisionType = y.DecisionType, DesignId = y.DesignId, ImportId = y.ImportId, Override = y.Override, Selected = y.Selected, VersionId = y.VersionId, VersionIdCompare = y.VersionIdCompare });
            var results = decisions.Select(decision => osatSvc.SubmitBuildCriteriaSet(Functions.GetLoggedInUserId(), decision, true, decision.Selected, decisionsText[0].ReviewText)).ToList();

            if (results.All(x => x.Succeeded))
                return Ok(new
                {
                    SelectedReview = results
                        .First(x => x.Entity.BuildCriteriaSet.Id == decisions.First(j => j.Selected).VersionId).Entity
                        .Review,
                    AllReviews = results.SelectMany(x => x.Entity.Review.ReviewSteps.SelectMany(r => r.ReviewGroupReviewers.SelectMany(s => s.Reviewers))).ToArray()
                });

            return Content(HttpStatusCode.BadRequest, results.First(x => !x.Succeeded));
        }

        [HttpPost]
        [Route("GetAllReviews")]
        public IHttpActionResult GetAllReviews([FromBody] long[] ids)
        {
            var selectedBuildCriteriaSetId = ids[0];
            var osatSvc = new OsatService();
            var results = ids.Select(id => osatSvc.GetBuildCriteriaSetDetails(Functions.GetLoggedInUserId(), id, null)).ToList();

            return Ok(new
            {
                SelectedReview = results
                    .Single(x => x.BuildCriteriaSet.Id == selectedBuildCriteriaSetId)
                    .Review,
                AllReviews = results.SelectMany(x => x.Review.ReviewSteps.SelectMany(r => r.ReviewGroupReviewers.SelectMany(s => s.Reviewers))).ToArray()
            });

        }



        [HttpGet]
        [Route("DownloadPasVersion/{id:int}")]
        public HttpResponseMessage DownloadPasVersion(int id)
        {
            PasVersion version = new OsatService().GetPasVersion(Functions.GetLoggedInUserId(), id);
            if (version == null) return Request.CreateResponse(HttpStatusCode.NotFound);
            string filePath = string.Format(Business.Core.Settings.PathOsatPasVersion, version.Id, version.OriginalFileName, version.Combination.DesignFamily.Name);
            if (!File.Exists(filePath)) return Request.CreateResponse(HttpStatusCode.NotFound);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
            byte[] bytes = File.ReadAllBytes(filePath);
            response.Content = new ByteArrayContent(bytes);
            response.Content.Headers.ContentLength = bytes.LongLength;
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentDisposition.FileName = version.OriginalFileName;
            response.Content.Headers.ContentType = new MediaTypeHeaderValue(MimeMapping.GetMimeMapping(version.OriginalFileName));
            return response;
        }

        [HttpGet]
        [Route("GetBuildCombinations/{designId:int?}")]
        public IHttpActionResult GetBuildCombinations(int? designId = null, bool? porBuildCriteriaSetExists = null, int? osatId=null)
        {
            BuildCombinations result = new OsatService().GetBuildCombinations(Functions.GetLoggedInUserId(), designId: designId, porBuildCriteriaSetExists: porBuildCriteriaSetExists, osatId: osatId);
            return Ok(result);
        }

        [HttpGet]
        [Route("GetBuildCombinationsbyosatId")]
        public IHttpActionResult GetBuildCombination(int? designId=null, int? osatId=null, bool? porBuildCriteriaSetExists = null)
        {
            BuildCombinations result = new OsatService().GetBuildCombinations(Functions.GetLoggedInUserId(), designId: designId, porBuildCriteriaSetExists: porBuildCriteriaSetExists, osatId: osatId);
            return Ok(result);
        }



        [HttpGet]
        [Route("GetPasVersions")]
        public IHttpActionResult GetPasVersions()
        {
            PasVersions result = new OsatService().GetPasVersions(Functions.GetLoggedInUserId());
            return Ok(result);
        }

        [HttpPost]
        [Route("ImportPasVersion")]
        public IHttpActionResult ImportPasVersion()
        {
            HttpFileCollection httpFiles = HttpContext.Current.Request.Files;
            if (httpFiles.Count == 1)
            {
                HttpPostedFile httpFile = httpFiles[0];
                PostedFile file = new PostedFile()
                {
                    ContentLength = httpFile.ContentLength,
                    ContentType = httpFile.ContentType,
                    OriginalFileName = Path.GetFileName(httpFile.FileName),
                    OriginalFilePath = httpFile.FileName,
                    OriginalExtension = Business.Core.Functions.GetFileExtension(httpFile.FileName),
                    UploadFilePath = Path.Combine(Business.Core.Settings.DirectoryTemp, System.Guid.NewGuid().ToString("N")),
                };
                if (!Directory.Exists(Business.Core.Settings.DirectoryTemp)) Directory.CreateDirectory(Business.Core.Settings.DirectoryTemp);
                httpFile.SaveAs(file.UploadFilePath);
                PasVersionImport versionImport = new PasVersionImport()
                {
                    File = file,
                    OsatId = HttpContext.Current.Request.Params["osatId"].ToNullableIntSafely(),
                    DesignFamilyId = HttpContext.Current.Request.Params["designFamilyId"].ToNullableIntSafely(),
                };
                EntitySingleMessageResult<PasVersion> result = new OsatService().ImportPasVersion(Functions.GetLoggedInUserId(), versionImport);
                if (result.Succeeded) return Ok(result);
                else return Content(HttpStatusCode.BadRequest, result);
            }
            else
            {
                string message;
                if (httpFiles.Count == 0) message = "A file is required.";
                else message = "Multiple files are not supported.";
                return Content(HttpStatusCode.BadRequest, new EntitySingleMessageResult<PasVersion>() { Succeeded = false, Message = message });
            }
        }

        [HttpPost]
        [Route("SubmitPasVersion/{id:int}")]
        public IHttpActionResult SubmitPasVersion(int id)
        {
            var result = new OsatService().SubmitPasVersion(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("UpdateAttributeType")]
        public IHttpActionResult UpdateAttributeType(AttributeTypeUpdateDto entity)
        {
            EntitySingleMessageResult<AttributeTypes> result = new OsatService().UpdateAttributeType(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpGet]
        [Route("GenerateQualFilterSpreadsheetData/{designId:int}/{osatId:int}/{includeStatusSubmittedInReview:bool}/{includeStatusDraft:bool}")]
        public HttpResponseMessage GenerateQualFilterSpreadsheetData(int designId, int osatId, bool includeStatusSubmittedInReview, bool includeStatusDraft)
        {
            FileResponse file = new OsatService().GenerateQualFilterSpreadsheet(Functions.GetLoggedInUserId(), designId, osatId, includeStatusSubmittedInReview, includeStatusDraft);
            if (file == null || file.Content == null) return Request.CreateResponse(HttpStatusCode.BadRequest);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
         
            return response;
        }



        [HttpGet]
        [Route("GenerateQualFilterSpreadsheet/{designId:int}/{osatId:int}/{includeStatusSubmittedInReview:bool}/{includeStatusDraft:bool}")]
        public HttpResponseMessage GenerateQualFilterSpreadsheet(int designId, int osatId, bool includeStatusSubmittedInReview, bool includeStatusDraft)
        {
            FileResponse file = new OsatService().GenerateQualFilterSpreadsheet(Functions.GetLoggedInUserId(), designId, osatId, includeStatusSubmittedInReview, includeStatusDraft);
            if (file == null || file.Content == null) return Request.CreateResponse(HttpStatusCode.BadRequest);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StreamContent(file.Content); // stream must be at beginning for this to work properly; i.e. stream.Seek(0, SeekOrigin.Begin)
            response.Content.Headers.ContentLength = file.Content.Length;
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = file.Name
            };
            response.Content.Headers.ContentType = new MediaTypeHeaderValue(MimeMapping.GetMimeMapping(file.Name));
            return response;
        }

        [HttpPost]
        [Route("CreateQualFilterExport")]
        public IHttpActionResult CreateQualFilterExport(QualFilterRecordsQueryCustom recordsQuery)
        {
            var userId = Functions.GetLoggedInUserId();
            var result = new OsatService().CreateQualFilterExport(userId, recordsQuery: recordsQuery);
            if (result.Succeeded)
            {
                var app = new OsatQualFilterExportApplication(userId, qualFilterExportId: result?.Entity?.Id);
                System.Threading.Tasks.Task.Run(() => app.Start());
                return Ok(result);
            }
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("QualFilterFile")]
        public IHttpActionResult GetQualFilterFile(QualFilterRecordsQuery entity)
        {
            if (entity != null)
            {
                // null values don't filter (i.e. retrieve more data than allowed here), so set them to an invalid value if null
                entity.DesignId = entity.DesignId ?? 0;
                entity.OsatId = entity.OsatId ?? 0;
            }
            QualFilterFile result = new OsatService().GetQualFilterFile(Functions.GetLoggedInUserId(), entity);
            return Ok(result);
        }


        [HttpPost]
        [Route("QualFilterFileBulkUpdate")]
        public IHttpActionResult GetQualFilterFileBulkUpdate(QualFilterRecordsQuery entity)
        {
            entity.IncludeStatusDraft = true;
            entity.IncludeStatusSubmitted = true;
            entity.IncludeStatusInReview = true;
            if (!entity.ImportId.HasValue)
            {
                entity.IsPOR = false;
            }

          //  entity.OsatId = 1;

            var osatService = new OsatService();

            var file = osatService.GetQualFilterFile(Functions.GetLoggedInUserId(), entity);

            if (file == null)
            {
                return Ok(new
                {
                    error = true,
                    msg = "The review is not longer active."
                });
            }

            var buildCriteriaSetAttributeChanges = new List<QualFilterBulkUpdateAttributeChange>();
            foreach (var qualFilterRecord in file.Sheets.SelectMany(sheet => sheet.Records))
            {
                buildCriteriaSetAttributeChanges.AddRange(
                    osatService.GetOsatBuildCriteriaSetBulkUpdateChanges(qualFilterRecord.BuildCriteriaSetId, entity.ImportId.GetValueOrDefault())
                        .Where(x => x.NewValue.Trim().TrimEnd('+') != x.OldValue.Trim().TrimEnd('+'))
                        .Select(x => new QualFilterBulkUpdateAttributeChange
                        {
                            BuildCriteriaSetId = x.BuildCriteriaSetId,
                            AttributeName = x.AttributeName,
                            NewValue = x.NewValue,
                            OldValue = x.OldValue,
                            BuildCriteriaOrdinal = x.BuildCriteriaOrdinal
                        }));
            }

            foreach (var sheet in file.Sheets)
            {
                var recordsToDelete = new List<KeyValuePair<long, int>>();
                foreach (var qualFilterRecord in sheet.Records)
                {
                    if (buildCriteriaSetAttributeChanges.Any(x => x.BuildCriteriaSetId == qualFilterRecord.BuildCriteriaSetId
                                                                  && x.BuildCriteriaOrdinal == qualFilterRecord.BuildCriteriaOrdinal)) continue;

                    recordsToDelete.Add(new KeyValuePair<long, int>(qualFilterRecord.BuildCriteriaSetId, qualFilterRecord.BuildCriteriaOrdinal));
                }

                if (recordsToDelete.Any())
                {
                    sheet.Records.RemoveAll(x => recordsToDelete.Any(rd => rd.Key == x.BuildCriteriaSetId && rd.Value == x.BuildCriteriaOrdinal));
                }
            }

            file.Sheets.RemoveAll(x => !x.Records.Any());

            return Ok(new
            {
                buildCriteriaSetAttributeChanges,
                file,
                error = false
            });
        }

        [HttpGet]
        [Route("DownloadQualFilterExport/{id:int}")]
        public HttpResponseMessage DownloadQualFilterExport(int id)
        {
            QualFilterExport export = new OsatService().GetQualFilterExport(Functions.GetLoggedInUserId(), id);
            if (export == null) return Request.CreateResponse(HttpStatusCode.NotFound);
            string filePath = string.Format(Business.Core.Settings.PathOsatQfExport, export.Id, export.FileName);
            if (!File.Exists(filePath)) return Request.CreateResponse(HttpStatusCode.NotFound);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
            byte[] bytes = File.ReadAllBytes(filePath);
            response.Content = new ByteArrayContent(bytes);
            response.Content.Headers.ContentLength = bytes.LongLength;
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentDisposition.FileName = export.FileName;
            response.Content.Headers.ContentType = new MediaTypeHeaderValue(MimeMapping.GetMimeMapping(export.FileName));
            return response;
        }

        [HttpGet]
        [Route("DownloadQualFilterImport/{id:int}")]
        public HttpResponseMessage DownloadQualFilterImport(int id)
        {
            QualFilterImport item = new OsatService().GetQualFilterImport(Functions.GetLoggedInUserId(), id);
            if (item == null) return Request.CreateResponse(HttpStatusCode.NotFound);
            string filePath = string.Format(Business.Core.Settings.PathOsatQfImport, item.Id, item.FileName);
            if (!File.Exists(filePath)) return Request.CreateResponse(HttpStatusCode.NotFound);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
            byte[] bytes = File.ReadAllBytes(filePath);
            response.Content = new ByteArrayContent(bytes);
            response.Content.Headers.ContentLength = bytes.LongLength;
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentDisposition.FileName = item.FileName;
            response.Content.Headers.ContentType = new MediaTypeHeaderValue(MimeMapping.GetMimeMapping(item.FileName));
            return response;
        }

        [HttpPost]
        [Route("ImportQualFilter")]
        public IHttpActionResult ImportQualFilter()
        {
            HttpFileCollection httpFiles = HttpContext.Current.Request.Files;
            if (httpFiles.Count == 1)
            {
                HttpPostedFile httpFile = httpFiles[0];
                PostedFile file = new PostedFile()
                {
                    ContentLength = httpFile.ContentLength,
                    ContentType = httpFile.ContentType,
                    OriginalFileName = Path.GetFileName(httpFile.FileName),
                    OriginalFilePath = httpFile.FileName,
                    OriginalExtension = Business.Core.Functions.GetFileExtension(httpFile.FileName),
                    UploadFilePath = Path.Combine(Business.Core.Settings.DirectoryTemp, System.Guid.NewGuid().ToString("N")),
                };
                if (!Directory.Exists(Business.Core.Settings.DirectoryTemp)) Directory.CreateDirectory(Business.Core.Settings.DirectoryTemp);
                httpFile.SaveAs(file.UploadFilePath);
                EntitySingleMessageResult<QualFilterImport> result = new OsatService().ImportQualFilter(Functions.GetLoggedInUserId(), file, removeFileAfter: true);
                if (result.Succeeded) return Ok(result);
                else return Content(HttpStatusCode.BadRequest, result);
            }
            else
            {
                string message;
                if (httpFiles.Count == 0) message = "A file is required.";
                else message = "Multiple files are not supported.";
                return Content(HttpStatusCode.BadRequest, new EntitySingleMessageResult<QualFilterImport>() { Succeeded = false, Message = message });
            }
        }

        [HttpPost]
        [Route("UpdateBuildCombinationPublish")]
        public IHttpActionResult UpdateBuildCombinationPublish(BuildCombinationUpdatePublishDto entity)
        {
            var result = new OsatService().UpdateBuildCombinationPublish(Functions.GetLoggedInUserId(), entity);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("UpdateQualFilterImportCanceled/{id:int}")]
        public IHttpActionResult UpdateQualFilterImportCanceled(int id)
        {
            var result = new OsatService().UpdateQualFilterImportCanceledReturnDetails(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }

        [HttpPost]
        [Route("UpdateQualFilterImportPor/{id:int}")]
        public IHttpActionResult UpdateQualFilterImportPor(int id)
        {
            var result = new OsatService().UpdateQualFilterImportPorReturnDetails(Functions.GetLoggedInUserId(), id);
            if (result.Succeeded) return Ok(result);
            else return Content(HttpStatusCode.BadRequest, result);
        }



        [HttpPost]
        [Route("ImportQualFilterBulkUpdates")]
        public IHttpActionResult ImportQualFilterBulkUpdates()
        {
            HttpFileCollection httpFiles = HttpContext.Current.Request.Files;
            if (httpFiles.Count == 1)
            {
                HttpPostedFile httpFile = httpFiles[0];
                PostedFile file = new PostedFile()
                {
                    ContentLength = httpFile.ContentLength,
                    ContentType = httpFile.ContentType,
                    OriginalFileName = Path.GetFileName(httpFile.FileName),
                    OriginalFilePath = httpFile.FileName,
                    OriginalExtension = Business.Core.Functions.GetFileExtension(httpFile.FileName),
                    UploadFilePath = Path.Combine(Business.Core.Settings.DirectoryTemp, System.Guid.NewGuid().ToString("N")),
                };

                var osatId = HttpContext.Current.Request.Params["osatId"].ToNullableIntSafely();
                var designId = HttpContext.Current.Request.Params["designId"].ToNullableIntSafely();

                if (!Directory.Exists(Business.Core.Settings.DirectoryTemp)) Directory.CreateDirectory(Business.Core.Settings.DirectoryTemp);
                File.Delete(file.UploadFilePath);
                httpFile.SaveAs(file.UploadFilePath);

                string pendingImportId;
                var osatService = new OsatService();
                var result = osatService.ValidateImportQualFilterBulkUpdate(Functions.GetLoggedInUserId(), designId.GetValueOrDefault(), file, true, out pendingImportId, osatId.GetValueOrDefault());


                if (result.Succeeded)
                {
                    if (result.Entity.Any())
                    {
                        return Ok(new
                        {
                            pendingImportId,
                            osatId,
                            result
                        });
                    }

                    var importResult = osatService.ImportQualFilterBulkUpdate(Functions.GetLoggedInUserId(), pendingImportId, osatId.GetValueOrDefault());

                    if (importResult.Succeeded)
                    {
                        return Ok(new
                        {
                            pendingImportId,
                            importResult,
                            imported = true,
                            osatId
                        });
                    }
                    else return Content(HttpStatusCode.BadRequest, importResult);

                }
                else return Content(HttpStatusCode.BadRequest, result);
            }
            else
            {
                string message;
                if (httpFiles.Count == 0) message = "A file is required.";
                else message = "Multiple files are not supported.";
                return Content(HttpStatusCode.BadRequest, new EntitySingleMessageResult<BulkUpdatesModel>() { Succeeded = false, Message = message });
            }
        }

        [HttpGet]
        [Route("PendingImportQualFilterBulkUpdates")]
        public IHttpActionResult PendingImportQualFilterBulkUpdates([FromUri] string id, [FromUri] int osatid)
        {
            var osatService = new OsatService();
            var importResult = osatService.ImportQualFilterBulkUpdate(Functions.GetLoggedInUserId(), id, osatid);
           
            if (importResult.Succeeded)
            {
                return Ok(importResult);
            }
            else return Content(HttpStatusCode.BadRequest, importResult);
        }
    }

}