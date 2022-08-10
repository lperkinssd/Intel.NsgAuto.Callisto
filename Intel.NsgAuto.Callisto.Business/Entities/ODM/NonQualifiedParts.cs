using System;
using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class NonQualifiedParts: List<NonQualifiedPart>
    {
		public NonQualifiedParts GetByOdmName(string odmName)
		{
			NonQualifiedParts qualFilters = new NonQualifiedParts();
			var results = (from q in this
						   where q.OdmName.Equals(odmName, StringComparison.InvariantCultureIgnoreCase)
						   select q).ToList();
			if (results != null)
			{
				qualFilters.AddRange(results);
			}
			return qualFilters;
		}
	}
}
