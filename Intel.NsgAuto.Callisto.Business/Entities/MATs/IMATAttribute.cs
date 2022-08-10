using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MATs
{
    interface IMATAttribute
    {
        int Id { get; set; }
        int MATId { get; set; }
        string Name { get; set; }
        string NameDisplay { get; set; }
        string Value { get; set; }
        string Operator { get; set; }
        string DataType { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
