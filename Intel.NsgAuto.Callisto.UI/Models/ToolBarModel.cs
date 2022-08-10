using Intel.NsgAuto.Web.Mvc.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Intel.NsgAuto.Web.Mvc.Models
{
    public class ToolBarModel
    {
        public ToolBarModel()
        {
            this.visible = true;
        }
        private bool visible;

        public bool Visible
        {
            get { return visible; }
            set { visible = value; }
        }

        public MenuItems Items { get; set; }
    }
}