using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Intel.NsgAuto.Callisto.Business.Entities.MATs;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Callisto.Business.Core;
using System.IO;
using Intel.NsgAuto;

namespace Intel.NsgAuto.Callisto.UnitTests
{
    [TestClass]
    public class MATImport
    {
        private string fileName = @"MMID Media Attribute Table PTI Pilot (Final v1).xlsx";
        private string filePath = @"C:\Users\jakemurx\OneDrive - Intel Corporation\Documents\Projects\Import MAT Data\MMID Media Attribute Table PTI Pilot (Final v1).xlsx";

        [TestMethod]
        public void CreateImportRecords_Return44Records_AreEqual()
        {
            Stream stream = new FileStream(filePath, FileMode.Open);
            MATVersionsService service = new MATVersionsService();

            // TODO: Jake to fix this
            MATsImport records = null; // service.CreateImportRecords(stream, fileName);

            int expected = 44;
            Assert.AreEqual(expected, records.Count);

            records = null;
            service = null;

            stream.Close();
            stream.Dispose();
            stream = null;

        }

        [TestMethod]
        //[ExpectedException(typeof(Exception))]
        public void CreateMATVersionImportResponse_ReturnResponse_ExceptionThrown()
        {

            Stream stream = new FileStream(filePath, FileMode.Open);
            MATVersionsService service = new MATVersionsService();

            try
            {
                MATVersionImportResponse result = service.Import("jakemurx", stream, fileName);
                //MATVersionImportResponse expected = new MATVersionImportResponse();
                //Intel.NsgAuto.DataAccess.Exceptions.DataAccessException expected = new Intel.NsgAuto.DataAccess.Exceptions.DataAccessException("");

                //Assert.AreEqual(expected, )
                //Assert.AreEqual(expected.Version, result.Version);
                //Assert.AreEqual(expected, result);
                //}
            }
            catch (Intel.NsgAuto.DataAccess.Exceptions.DataAccessException e)
            {
                //string expected = "Connection must be instantiated before creating command.";
                string expected = @"Connection must be instantiated before creating command.";
                string actual = e.Message.Substring(0, 56);
                //Intel.NsgAuto.DataAccess.Exceptions.DataAccessException expected = new Intel.NsgAuto.DataAccess.Exceptions.DataAccessException(message);

                Assert.AreEqual(expected,actual);
            }

            service = null;

            stream.Close();
            stream.Dispose();
            stream = null;

        }
    }
}
