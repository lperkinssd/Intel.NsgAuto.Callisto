using System;

namespace Intel.NsgAuto.Callisto.Business.Entities
{
    interface IProductFamily
    {
        int Id { get; set; }
        string Name { get; set; }
        string NameSpeed { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
