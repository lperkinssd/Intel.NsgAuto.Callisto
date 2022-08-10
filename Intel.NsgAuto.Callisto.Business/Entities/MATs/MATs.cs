using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    public class MATs : List<MAT>
    {
		public MAT GetByMATId(int id)
		{
			MAT mat = null;
			var result = (from m in this
						  where m.Id == id
						  select m).FirstOrDefault();
			if (result != null)
			{
				mat = (MAT)result;
			}
			return mat;
		}
	}
}
