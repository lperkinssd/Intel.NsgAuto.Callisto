using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Web.Mvc.Serializations
{
    public interface IJsonSerializable
    {
        string ToJson();
    }
}
