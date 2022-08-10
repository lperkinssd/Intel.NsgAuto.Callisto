using Intel.NsgAuto.Shared.DirectoryServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
	public class RequestRequestor : IRequestRequestor
	{
		public System.Guid RequestId { get; set; }
		public string wwid { get; set; }
		public string Idsid { get; set; }

		public string Email { get; set; }
		public Employee Requestor { get; set; }

	}
}
