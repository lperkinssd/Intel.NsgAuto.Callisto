using Intel.NsgAuto.Callisto.Business.Entities.Imports;
using Intel.NsgAuto.Callisto.Business.Entities.Osat;
using Intel.NsgAuto.Callisto.Business.Helpers;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;

namespace Intel.NsgAuto.Callisto.UnitTests
{
    [TestClass]
    public class ExcelTests
    {
        private const string FILE_EMPTY = @"Files\Excel\EmptyFile.xlsx";
        private const string FILE_SAMPLE_DATA_IMPORT = @"Files\Excel\SampleDataImport.xlsx";
        private const string WORKSHEET_COLUMN_NAMES = "Data With Column Names";
        private const string WORKSHEET_NO_DATA = "No Data";
        private const string WORKSHEET_NO_COLUMN_NAMES = "Data Without Column Names";

        private class TestSpecification : Specification
        {
            public TestSpecification(bool isFirstRowColumnRow = true, int? rowDataBegins = null, string worksheetName = null) : base(isFirstRowColumnRow: isFirstRowColumnRow, rowDataBegins: rowDataBegins, worksheetName: worksheetName)
            {
                AddField(new ReadOnlyField(name: "RequiredColumn1", columnName: "Required Column 1", columnRequired: true));
                AddField(new ReadOnlyField(name: "RequiredColumn2", columnName: "Required Column 2", columnRequired: true));
                AddField(new ReadOnlyField(name: "OptionalColumn1", columnName: "Optional Column 1"));
                AddField(new ReadOnlyField(name: "OptionalColumn2", columnName: "Optional Column 2"));
            }
        }

        private ExcelStreamToDataTable GetConverter(string filePath, bool isFirstRowColumnRow = true, int? rowDataBegins = 3, string worksheetName = WORKSHEET_COLUMN_NAMES)
        {
            var specification = new TestSpecification(isFirstRowColumnRow, rowDataBegins, worksheetName);
            var converter = new ExcelStreamToDataTable(File.OpenRead(filePath), Path.GetFileName(filePath), specification);
            return converter;
        }

        [TestMethod]
        public void EmptyFileFails()
        {
            var converter = GetConverter(FILE_EMPTY);
            var result = converter.TryConvert(out string message);
            Assert.IsNotNull(message);
            Assert.IsNull(result);
        }

        [TestMethod]
        public void EmptyWorksheetFails()
        {
            var converter = GetConverter(FILE_SAMPLE_DATA_IMPORT, isFirstRowColumnRow: false, rowDataBegins: 1, worksheetName: WORKSHEET_NO_DATA);
            var result = converter.TryConvert(out string message);
            Assert.IsNotNull(message);
            Assert.IsNull(result);
        }

        [TestMethod]
        public void WithoutColumnNamesSucceeds()
        {
            var converter = GetConverter(FILE_SAMPLE_DATA_IMPORT, isFirstRowColumnRow: false, rowDataBegins: 1, worksheetName: WORKSHEET_NO_COLUMN_NAMES);
            var result = converter.TryConvert(out string message);
            Assert.IsNull(message);
            Assert.IsNotNull(result);
            Assert.IsTrue(result.Columns.Contains("RequiredColumn1"));
            Assert.IsTrue(result.Columns.Contains("RequiredColumn2"));
            Assert.IsTrue(result.Rows.Count == 5);
            Assert.AreEqual("5", result.Rows[4]["RequiredColumn1"]);
            Assert.AreEqual("E", result.Rows[4]["RequiredColumn2"]);
        }

        [TestMethod]
        public void WithoutColumnNamesAndRecordNumberSucceeds()
        {
            var converter = GetConverter(FILE_SAMPLE_DATA_IMPORT, isFirstRowColumnRow: false, rowDataBegins: 1, worksheetName: WORKSHEET_NO_COLUMN_NAMES);
            converter.IncludeRecordNumber = false;
            var result = converter.TryConvert(out string message);
            Assert.IsNull(message);
            Assert.IsNotNull(result);
            Assert.IsTrue(result.Columns.Contains("RequiredColumn1"));
            Assert.IsTrue(result.Columns.Contains("RequiredColumn2"));
            Assert.IsTrue(result.Rows.Count == 5);
            Assert.AreEqual("5", result.Rows[4]["RequiredColumn1"]);
            Assert.AreEqual("E", result.Rows[4]["RequiredColumn2"]);
        }

        [TestMethod]
        public void WithColumnNamesSucceeds()
        {
            var converter = GetConverter(FILE_SAMPLE_DATA_IMPORT, isFirstRowColumnRow: true, rowDataBegins: 3, worksheetName: WORKSHEET_COLUMN_NAMES);
            var result = converter.TryConvert(out string message);
            Assert.IsNull(message);
            Assert.IsNotNull(result);
            Assert.IsTrue(result.Columns.Contains("RequiredColumn1"));
            Assert.IsTrue(result.Columns.Contains("RequiredColumn2"));
            Assert.IsTrue(result.Rows.Count == 5);
            Assert.AreEqual("5", result.Rows[4]["RequiredColumn1"]);
            Assert.AreEqual("E", result.Rows[4]["RequiredColumn2"]);
        }

        [TestMethod]
        public void PasSucceeds()
        {
            var specification = new PasVersionImportSpecification();
            var converter = new ExcelStreamToDataTable(File.OpenRead(@"Files\Excel\PasImport.xlsx"), Path.GetFileName("PasImport.xlsx"), specification);
            var result = converter.TryConvert(out string message);
            Assert.IsNull(message);
            Assert.IsNotNull(result);
            Assert.IsTrue(result.Columns.Contains("MaterialMasterField"));
            Assert.IsTrue(result.Columns.Contains("DeviceName"));
            Assert.IsTrue(result.Rows.Count == 496);
            Assert.AreEqual("953367", result.Rows[0]["MaterialMasterField"]);
            Assert.AreEqual("O264-21ST-D4A2", result.Rows[result.Rows.Count - 1]["DeviceName"]);
        }
    }
}
