using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class RunScenarioResponse: Result
    {
        public QualFilterScenarioVersion LatestScenarioVersion { get; set; }
        public QualFilterScenarioVersions ScenarioVersions { get; set; }
    }
}
