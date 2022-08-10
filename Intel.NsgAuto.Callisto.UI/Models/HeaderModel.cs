using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Intel.NsgAuto.Web.Mvc.Models
{
    public class HeaderModel
    {
        public HeaderModel()
        {
            this.visible = true;
        }
        private bool visible;

        public bool Visible
        {
            get { return visible; }
            set { visible = value; }
        }
        private MenuModel menu;

        public MenuModel Menu
        {
            get { return menu; }
            set { menu = value; }
        }        
    }
}