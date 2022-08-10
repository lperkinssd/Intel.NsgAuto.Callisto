using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Services;
using System.IO;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Applications
{
    public class OsatQualFilterImportApplication : TaskApplication
    {
        private string Directory { get; }

        private readonly OsatService service;

        private bool SetPor { get; }

        private readonly string userId;

        private string UserId
        {
            get
            {
                if (userId != null) return userId;
                return By;
            }
        }

        public OsatQualFilterImportApplication(string directory, string userId = null, bool setPor = true) : base("Osat Qual Filter Import")
        {
            Directory = directory;
            this.userId = userId;
            SetPor = setPor;
            service = new OsatService();
        }

        override protected void Content()
        {
            CreateInformationalMessage(string.Format("Directory supplied: {0}", Directory));

            if (!System.IO.Directory.Exists(Directory))
            {
                Abort(string.Format("Directory is inaccessible or does not exist: {0}", Directory));
                return;
            }

            var filepaths = System.IO.Directory.GetFiles(Directory).Where(x => x.ToLower().EndsWith(".xls") || x.ToLower().EndsWith(".xlsx")).ToArray();
            CreateInformationalMessage(string.Format("Number of files to import: {0}", filepaths.Length));

            var countFail = 0;
            var index = 0;
            foreach (var filepath in filepaths)
            {
                var progressPercent = (int)(100 * (float)index / filepaths.Length);
                UpdateProgress(progressPercent, string.Format("importing file {0} of {1}", index + 1, filepaths.Length));
                var postedFile = newPostedFile(filepath);
                var resultImport = service.ImportQualFilter(UserId, postedFile, false);
                if (resultImport.Succeeded)
                {
                    var errorText = (resultImport?.Entity?.MessageErrorsExist == true) ? "Errors exist" : "No errors";
                    CreateInformationalMessage(string.Format("Import succeeded; Id = {0}; {1}; {2}", resultImport.Entity?.Id, errorText, filepath));
                    if (SetPor)
                    {
                        var resultPor = service.UpdateQualFilterImportPor(UserId, resultImport.Entity.Id);
                        var statusPor = (resultPor?.Succeeded == true) ? "succeeded" : "failed";
                        CreateInformationalMessage(string.Format("Set POR {0}; Id = {1}", statusPor, resultImport.Entity?.Id));
                    }
                }
                else
                {
                    ++countFail;
                    CreateErrorMessage(string.Format("Import failed; {0}", filepath));
                    if (!string.IsNullOrEmpty(resultImport.Message))
                    {
                        CreateErrorMessage(resultImport.Message);
                    }
                }
                ++index;
            }

            if (countFail > 0)
            {
                Abort(string.Format("Total file import failures: {0}", countFail));
            }
            else
            {
                CreateInformationalMessage("Successfully imported all files");
            }
        }

        public static PostedFile newPostedFile(string filepath)
        {
            var filename = Path.GetFileName(filepath);
            var fileExtension = Functions.GetFileExtension(filename);
            string contentType = null;
            if (fileExtension.ToLower() == "xls")
            {
                contentType = "application/vnd.ms-excel";
            }
            else if (fileExtension.ToLower() == "xlsx")
            {
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            }
            var fileInfo = new FileInfo(filepath);
            return new PostedFile()
            {
                ContentLength = (int)fileInfo.Length,
                ContentType = contentType,
                OriginalFileName = filename,
                OriginalFilePath = filepath,
                OriginalExtension = fileExtension,
                UploadFilePath = filepath,
            };
        }
    }
}
