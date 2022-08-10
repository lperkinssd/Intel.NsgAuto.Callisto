using System;
using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class ExemptParts: List<ExemptPart>
    {
		public ExemptParts GetByOdmName(string odmName)
		{
			ExemptParts exemptParts = new ExemptParts();
			var results = (from ep in this
						   where ep.OdmName.Equals(odmName, StringComparison.InvariantCultureIgnoreCase)
						   select ep).ToList();
			if (results != null)
			{
				exemptParts.AddRange(results);
			}
			return exemptParts;
		}
	}
}
