using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
	public interface IRequestRequestor
	{
		System.Guid RequestId { get; set; }
		string wwid { get; set; }
		string Idsid { get; set; }

		string Email { get; set; }
	}
}
