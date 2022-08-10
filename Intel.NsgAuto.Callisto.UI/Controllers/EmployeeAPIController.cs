
using Intel.NsgAuto.Web.Mvc.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Results;
using Intel.NsgAuto.Callisto.Business.Entities;

using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.UI.Controllers
{
    
    public class EmployeeAPIController : ApiController
    {
        [HttpGet]
        [Route("api/EmployeeApi/GetContact")]
        [ActionName("GetContact")]
        public JsonResult<RequestRequestor> GetContact(string idsid)
        {

            RequestRequestor response = null;
            try
            {

                Employee employee = new EmployeeDataProvider().GetUser(idsid);

                if (employee == null)
                    throw new NullReferenceException("Employee does not exists.");
                response = new RequestRequestor()
                {
                    Requestor = employee,
                    wwid = employee.WWID,
                    Idsid = employee.Idsid,
                    Email = employee.Email
                };
                //if (reviewer.Roles.Contains(Settings.UserRole))
                //{
                //    response = new RequestRequestor() { Reviewer = reviewer };
                //}
            }
            catch (Exception ex)
            {
                //TODO: Log the error
                throw ex;
            }

            return Json(response);
        }

    }
}