
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Intel.NsgAuto.Web.Mvc.Models
{
    public class LayoutModel
    {
        public LayoutModel()
        {
            this.header = new Models.HeaderModel()
            {
                Menu = new MenuModel()
            };
            this.toolBar = new Models.ToolBarModel();
        }
        private HeaderModel header;

        public HeaderModel Header
        {
            get { return header; }
            set { header = value; }
        }
        private ToolBarModel toolBar;

        public ToolBarModel ToolBar
        {
            get { return toolBar; }
            set { toolBar = value; }
        }

    }
}