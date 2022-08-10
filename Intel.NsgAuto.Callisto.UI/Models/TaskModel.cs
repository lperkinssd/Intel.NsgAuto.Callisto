using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Web.Mvc.Models;

namespace Intel.NsgAuto.Callisto.UI.Models
{
    public class TaskModel : LayoutModel
    {
        public Task Task { get; set; }
        public TaskMessages Messages { get; set; }
    }
}