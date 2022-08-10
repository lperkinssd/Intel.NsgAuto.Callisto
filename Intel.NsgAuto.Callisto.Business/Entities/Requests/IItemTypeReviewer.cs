using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public interface IItemTypeReviewer
    {
        int Id { get; set; }
        int ReviewerId { get; set; }
        int ReviewItemTypeId { get; set; }
        string Reviewer { get; set; }
        string ItemType { get; set; }
    }
}
