using Intel.NsgAuto.Web.Mvc.Core;

namespace Intel.NsgAuto.Web.Mvc.Models
{
    public class MenuModel
    {
        private MenuItems menu = null;
        public MenuModel()
        {
            this.visible = true;
            createMenu();
            this.Menu = this.menu;
        }

        private void createMenu()
        {
            this.menu = new Core.MenuItems(){
                new MenuItem() { ActionType = "hyperlink", DisplayOrder=1, DisplayText="Auto Checker", ToolTip="Click here to ", Url="JavaScript:void(0);",
                       SubItems= new MenuItems(){
                           new MenuItem(){ ActionType = "hyperlink", DisplayOrder=1, DisplayText="Build Criteria", ToolTip="", Url="JavaScript:void(0);",
                               SubItems=new MenuItems(){
                                   new MenuItem(){ ActionType = "heading", DisplayPosition="left",DisplayOrder=1, DisplayText="Manage Build Criteria", ToolTip="", Url="JavaScript:void(0);",SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Attribute Types", ToolTip="", Url="/AutoChecker/AttributeTypes", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Designs", ToolTip="", Url="/AutoChecker/ListDesigns", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Create Build Criteria", ToolTip="", Url="/AutoChecker/CreateBuildCriteria", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="PRQ Builds", ToolTip="", Url="/AutoChecker/ListBuildCriteriaPOR", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Non-PRQ Builds", ToolTip="", Url="/AutoChecker/ListBuildCriteriaNonPOR", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="All PRQ Criteria", ToolTip="", Url="/AutoChecker/ListBuildCriteriaExportConditions", IsExternal=false, SubItems=null},
                               }
                           }
                       }
                },
                new MenuItem() { ActionType = "hyperlink", DisplayOrder=1, DisplayText="OSAT", ToolTip="Click here to manage ", Url="JavaScript:void(0);",
                       SubItems= new MenuItems(){
                           new MenuItem(){ ActionType = "hyperlink", DisplayOrder=1, DisplayText="Build Management", ToolTip="", Url="JavaScript:void(0);",
                               SubItems=new MenuItems(){
                                   new MenuItem(){ ActionType = "heading", DisplayPosition="left",DisplayOrder=1, DisplayText="Build Management", ToolTip="", Url="JavaScript:void(0);",SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="PAS Versions", ToolTip="", Url="/OSAT/ListPasVersions", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Attribute Types", ToolTip="", Url="/OSAT/AttributeTypes", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Designs", ToolTip="", Url="/OSAT/ListDesigns", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Component Parts", ToolTip="", Url="/OSAT/DesignSummary", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Create Build Criteria", ToolTip="", Url="/OSAT/CreateBuildCriteriaSet", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Qual Filter Preview", ToolTip="", Url="/OSAT/QualFilter", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="QF Exports & Publish", ToolTip="", Url="/OSAT/ListQualFilterExports", IsExternal=false, SubItems=null},
                                   //new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="QF Imports", ToolTip="", Url="/OSAT/ListQualFilterImports", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Qual Filter Bulk Updates", ToolTip="", Url="/OSAT/BulkUpdates", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Publish Qual Filter", ToolTip="", Url="/OSAT/ListQualFilterExports", IsExternal=false, SubItems=null},
                               }
                           }
                       }
                },
                new MenuItem() { ActionType = "hyperlink", DisplayOrder=1, DisplayText="ODM", ToolTip="Click here to ", Url="JavaScript:void(0);",
                       SubItems= new MenuItems(){
                           new MenuItem(){ ActionType = "hyperlink", DisplayOrder=1, DisplayText="Build Management", ToolTip="", Url="JavaScript:void(0);",
                               SubItems=new MenuItems(){
                                   new MenuItem(){ ActionType = "heading", DisplayPosition="left",DisplayOrder=1, DisplayText="Build Management", ToolTip="", Url="JavaScript:void(0);",SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Manage PRF", ToolTip="", Url="/ODM/PRF", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Manage MAT (Media Attributes Table)", ToolTip="", Url="/ODM/MAT", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Qual Filters Scenarios & Results", ToolTip="", Url="/ODM/QFScenarios", IsExternal=false, SubItems=null},
                                   //new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Qual Filter Explanations (Non Scenario)", ToolTip="", Url="/ODM/QualFilterExplanations", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="S-Lot Dispositioning", ToolTip="", Url="/ODM/Dispositions", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Qual Filters Removable SLot Report", ToolTip="", Url="/ODM/QFRemovableSLotReport", IsExternal=false, SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Qual Filters Historical Scenarios", ToolTip="", Url="/ODM/QFHistoricalScenarios", IsExternal=false, SubItems=null},
                               }
                           },
                       }
                },
                 new MenuItem() { ActionType = "hyperlink", DisplayOrder=1, DisplayText="MM Recipe", ToolTip="Click here to ", Url="JavaScript:void(0);",
                       SubItems= new MenuItems(){
                           new MenuItem(){ ActionType = "hyperlink", DisplayOrder=1, DisplayText="Product Data", ToolTip="", Url="JavaScript:void(0);",
                               SubItems=new MenuItems(){
                                   new MenuItem(){ ActionType = "heading", DisplayPosition="left",DisplayOrder=1, DisplayText="Product Data", ToolTip="", Url="JavaScript:void(0);",SubItems=null},
                                   new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Product Ownership", ToolTip="", Url="/ProductOwnerships", IsExternal=false, SubItems=null},
                                    new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Account Ownership", ToolTip="", Url="/AccountOwnerships", IsExternal=false, SubItems=null},
                                     new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="PCN Approvers", ToolTip="", Url="/PCNApprovers", IsExternal=false, SubItems=null},
                                    new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="PCN Manager Finder", ToolTip="", Url="/PCNManagerFinder", IsExternal=false, SubItems=null},
                                   }
                           },
                       }
                },
                new MenuItem() { ActionType = "hyperlink", DisplayOrder=1, DisplayText="Help Center", ToolTip="Click here to learn more about tape out center", Url="JavaScript:void(0);",
                    SubItems= new MenuItems(){
                        new MenuItem(){ ActionType = "hyperlink", DisplayOrder=1, DisplayText="Help & Support", ToolTip="", Url="JavaScript:void(0);",
                            SubItems=new MenuItems(){
                                new MenuItem(){ ActionType = "heading", DisplayPosition="left",DisplayOrder=1, DisplayText="Help & Support - Callisto Center", ToolTip="", Url="JavaScript:void(0);",SubItems=null},
                                new MenuItem(){ ActionType = "hyperlink", DisplayPosition="left",DisplayOrder=1, DisplayText="Get Support", ToolTip="", Url="JavaScript:void(0);",SubItems=null}
                            }
                        }
                    }
                }
            };
        }

        private bool visible;

        public bool Visible
        {
            get { return visible; }
            set { visible = value; }
        }
        public MenuItems Menu { get; set; }
    }
}