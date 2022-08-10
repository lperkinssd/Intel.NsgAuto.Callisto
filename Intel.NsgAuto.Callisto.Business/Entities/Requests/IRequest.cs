using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public interface IRequest
    {
        int Id { get; set; }
        ItemType ItemType { get; set; }        
        RequestRequestor RequestedBy { get; set; }
        IdAndName Status { get; set; }
        Reviews Reviews { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string CreatedOnStr { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
        string UpdatedOnStr { get; set; }

        void initialize();
    }
}
