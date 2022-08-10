using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Entities.ODM;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public interface IIogNpsgDataContext
    {
        Result CreateLotDisposition(string userId, LotDispositionDto lotDisposition);
        Result SaveLotDispositions(string userId, LotDispositions lotDispositions);
        ExplainabilityReport GetExplainabilityReport(string userId);
        //IdAndNames GetLotDispositionReasons(string userId);
        IdAndNames GetLotDispositionReasons(string userId, int? id = null);
        MatVersions GetMatVersionDetails(string userId, int versionId);
        ImportVersions GetMatVersions(string userId);
        QualFilterScenario GetQualFilterScenario(string userId, int versionId);
        QualFilterScenario GetQualFilterHistoricalScenario(string userId, int versionId);
        OdmWips GetOdmLotWipDetails(string sLot, string mediaIPN, string sCode, string odmName, string userId);
        QualFilterScenarioVersions GetQualFilterScenarioVersions(string userId);
        QualFilterScenarioVersions GetQualFilterScenarioVersionsDaily(string userId);
        QualFilterScenarioVersions GetOdmQualFilterScenarioHistoricalVersions(string userId);
        QualFilterRemovableSLotUploads GetQualFilterRemovableSLotUploads(string userId, DateTime loadToDate);
        QualFilterRemovableSLots GetRemovableSLotDetails(string userId, int version, string odmName);
        string GetProhibitedTimeRanges(string userId);
        PrfVersions GetPrfVersionDetails(string userId, int versionId);
        ImportVersions GetPrfVersions(string userId);
        ImportResult Import(string userId, MatRecords records);
        ImportResult Import(string userId, PrfRecords records);
        DispositionVersions GetDispositionVersions(string userId);
        ImportDispositionsResponse ImportDispositions(Stream stream, string filename, string userId);
        Result PublishScenario(string userId, int? versionId);
        Result RunQualFilter(string userId);
        //Result RunScenario(string userId);
        Dispositions GetDispositionsByVersion(int versionId, string userId);
        LotDispositionActions GetLotDispositionActions(string userId, int? id = null);
        RunScenarioResponse RunScenario(string userId);
        Dispositions GetAll(string userId, bool? isActive = null);
        void ProcessRemovableSLots(string userId);
        CheckProhibitedScenarioRunTimeResponse CheckProhibitedScenarioRunTime(string userId);
        Result ClearArchiveOdmManualDisposition(string userId);
    }
}
