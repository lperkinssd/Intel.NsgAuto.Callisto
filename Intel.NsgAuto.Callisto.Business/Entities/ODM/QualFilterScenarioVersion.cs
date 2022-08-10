using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM
{
    public class QualFilterScenarioVersion
	{
		public int Id { get; set; }
		public int PrfVersion { get; set; }
		public int MatVersion { get; set; }
		public int OdmWipSnapshotVersion { get; set; }
		public int LotShipSnapshotVersion { get; set; }
		public int LotDispositionSnapshotVersion { get; set; }
		public DateTime CreatedOn { get; set; }
		public string CreatedBy { get; set; }
		public int DailyId { get; set; }
		public int StatusId { get; set; }
	}
}
