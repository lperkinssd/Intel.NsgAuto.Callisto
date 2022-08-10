using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Entities.Osat;
using Intel.NsgAuto.Callisto.Business.Services;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;

namespace Intel.NsgAuto.Callisto.Business.Applications
{
    public class OsatQualFilterExportApplication : TaskApplication
    {
        private int? QualFilterExportId { get; }

        private readonly string userId;

        private string UserId
        { 
            get
            {
                if (userId != null) return userId;
                return By;
            }
        }

        private readonly OsatService service;

        public OsatQualFilterExportApplication(string userId = null, int? qualFilterExportId = null) : base("Osat Qual Filter Export")
        {
            this.userId = userId;
            QualFilterExportId = qualFilterExportId;
            service = new OsatService();
        }

        override protected void Content()
        {
            QualFilterExport export = null;
            if (!QualFilterExportId.HasValue)
            {
                var exportResult = service.CreateQualFilterExport(UserId, recordsQuery: null);
                if (!exportResult.Succeeded)
                {
                    string type = "Error";
                    string message = exportResult.Message ?? "The export could not be created";
                    if (message == "There is no associated data to export") type = "Warning";
                    CreateMessage(type, message);
                }
                else
                {
                    export = exportResult.Entity;
                }
            }
            else
            {
                export = service.GetQualFilterExport(UserId, QualFilterExportId.Value);
            }

            if (export != null)
            {
                // prepare data
                var baseTempFilepath = Path.Combine(Path.Combine(Settings.DirectoryTemp, "OsatQualFilterExport"), export.Id.ToString());
                if (!Directory.Exists(baseTempFilepath)) Directory.CreateDirectory(baseTempFilepath);
                var files = export.Files;
                var totalNumberOfFilesToGenerate = files.Count;
                var filepaths = new List<string>();
                var zipFilename = string.Format("osat_qf_export_{0}_{1}.zip", export.Id, export.CreatedOn.ToString("yyyyMMddHHmmss"));
                var zipFilepath = Path.Combine(baseTempFilepath, zipFilename);

                // generate files
                using (var zipStream = new FileStream(zipFilepath, FileMode.OpenOrCreate))
                using (var archive = new ZipArchive(zipStream, ZipArchiveMode.Update))
                {
                    foreach (var file in files)
                    {
                        var progressPercent = (int)(80 * (float)filepaths.Count / totalNumberOfFilesToGenerate);
                        UpdateProgress(progressPercent, string.Format("generating file {0} of {1}", filepaths.Count + 1, totalNumberOfFilesToGenerate));
                        var filepathRelative = Path.Combine(file?.Osat.Name, file.Name);
                        var filepath = Path.Combine(baseTempFilepath, filepathRelative);
                        var directory = Path.GetDirectoryName(filepath);
                        if (!Directory.Exists(directory)) Directory.CreateDirectory(directory);
                        var entry = archive.CreateEntry(filepathRelative, CompressionLevel.Optimal);
                        using (var entryStream = entry.Open())
                        using (var fileStream = new FileStream(filepath, FileMode.OpenOrCreate))
                        using (var spreadsheetStream = OsatService.GenerateQualFilterSpreadsheet(file))
                        {
                            spreadsheetStream.CopyTo(fileStream);
                            spreadsheetStream.Seek(0, SeekOrigin.Begin);
                            spreadsheetStream.CopyTo(entryStream);
                        }
                        filepaths.Add(filepath);
                        CreateInformationalMessage("Successfully generated file: " + filepath);
                    }
                }
                CreateInformationalMessage("Successfully generated zip archive: " + zipFilepath);
                UpdateProgress(85);

                // store zip file permanently
                UpdateProgress(85, "moving zip archive to permanent storage");
                var newZipFilepath = string.Format(Settings.PathOsatQfExport, export.Id, zipFilename);
                var newZipDirectory = Path.GetDirectoryName(newZipFilepath);
                if (!Directory.Exists(newZipDirectory)) Directory.CreateDirectory(newZipDirectory);
                var zipFileLengthInBytes = (int)new FileInfo(zipFilepath).Length;
                File.Move(zipFilepath, newZipFilepath);
                service.UpdateQualFilterExportGenerated(UserId, export.Id, zipFilename, zipFileLengthInBytes);
                CreateInformationalMessage("Successfully stored zip archive: " + newZipFilepath);

                // deliver generated files
                UpdateProgress(90, "delivering files to output location");
                var i = 0;
                foreach (var file in files)
                {
                    var progressPercent = 90 + 10 * (int)((float)i / files.Count);
                    UpdateProgress(progressPercent, string.Format("delivering file to output location: {0} of {1}", i + 1, files.Count));
                    var newDirectory = string.Format(Settings.PathOsatQfOutput, file?.Osat.Name);
                    if (!Directory.Exists(newDirectory)) Directory.CreateDirectory(newDirectory);
                    var newFilepath = Path.Combine(newDirectory, file.Name);
                    File.Move(filepaths[i], newFilepath);
                    CreateInformationalMessage("Successfully delivered file: " + newFilepath);
                    ++i;
                }
                service.UpdateQualFilterExportDelivered(UserId, export.Id);
                CreateInformationalMessage("Successfully delivered all files");
            }
        }
    }
}
