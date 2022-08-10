using Intel.NsgAuto.Web.Mvc.Serializations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Intel.NsgAuto.Web.Mvc.Core
{
    public class MenuItems: List<MenuItem>
    {
        public string ToJson()
        {
            return JsonSerializer.Serialize(this);
        }
    }
}