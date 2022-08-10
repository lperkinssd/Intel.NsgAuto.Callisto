using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Intel.NsgAuto.Web.Mvc.Core
{
    public class MenuItem
    {
        public bool IsExternal { get; set; }
        public int DisplayOrder { get; set; }
        public string DisplayPosition { get; set; }
        public string DisplayText { get; set; }
        public string ToolTip { get; set; }
        public string Url { get; set; }
        public string ActionType { get; set; }
        public MenuItems SubItems { get; set; }
    }
}