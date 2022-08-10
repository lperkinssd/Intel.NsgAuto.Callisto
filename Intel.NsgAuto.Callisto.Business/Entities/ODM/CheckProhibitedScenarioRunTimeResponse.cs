using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class CheckProhibitedScenarioRunTimeResponse : Result
    {
        public bool IsProhibited { get; set; }
        public string ProhibitedMessage { get; set; }
    }
}
