/*!
 * Nsga main menu implementation
 * Author: Jose Kurian <jose.kurian@intel.com>
 * 
 *<remarks>
 * ; is for and also realize that $ is the jQuery
 * The semi-colon before the function invocation keeps the plugin from breaking if 
 * our plugin is concatenated with other scripts that are not closed properly.
 * Immediately-Invoked Function Expression (IIFE) (function($) { //... })(jQuery);
   This is called Immediately-Invoked Function Expression or Self-executing anonymous function. 
   It enables the developer to hide his private declarations.
    ;(                                      // <---------------+
                                            //                 | encapsulate the function
        function($, window, document) {     // <--+ declare    | and call it passing three
                                            //    | anonymous  | arguments.
        }                                   // <--+ function   |
                                            //                 |
    )(jQuery, window, document);            // <---------------+
 * Wrapping the jQuery object into the dollar sign via a closure avoids conflicts with other libraries 
 * that also use the dollar sign as an abbreviation. window and document are passed through as local variables 
 * rather than as globals, because this speeds up the resolution process and can be more efficiently minified.
 *</remarks>
 *<uses>
 * Nsga.js
 * Nsga.Framework.js
 *</uses>
 */

; (function ($, window, document, undefined) {
    // "use strict"; puts our code into strict mode, 
    // which catches some common coding problems by throwing exceptions, 
    // prevents/throws errors when relatively "unsafe" actions are taken 
    // and disables Javascript features that are confusing or poorly thought out. 
    // To read about this in detail, please check ECMAScript 5 Strict Mode.
    "use strict";
    var name = 'MainMenu';
    // Nsga is the namespace branched from $ for plugins to avoid conflicts. 
    // if empty, initialize else append to existing definitions.
    if (!$.Nsga) {
        $.Nsga = {};
    }
    // Define the MainMenu plug in
    $.Nsga.MainMenu = function (element, menuData) {
        // To avoid scope issues, use '_self' instead of 
        // 'this' to reference this instance from internal events and functions.
        var _self = $.Nsga.MainMenu;
        // Access to jQuery and DOM versions of element
        _self.$element = $(element);
        _self.element = element;
        // Add a reverse reference to the DOM object
        //_self.$element.data(name, _self);
        _self.init = function () {
            // render the control
            _self.render(menuData);
            // return self for chaining
            return _self;
        };
        // renders the top bar
        _self.render = function (menuData) {
            if (_self.$element && menuData) {
                $('#rootItems').empty();
                _self.$element.empty();
                // Get the menu data to a local variable
                var items = menuData;
                // If there are records for root navigation,
                if (items && items.length && items.length > 0) {
                    var html = '';                    
                    var dos;
                    var dosHtml = '';
                    var tres;
                    var tresHtml = '';
                    var displayPosition;

                    html = '<div class="menucontainer"><div class="primarymenucontainer " style="display: block;"><div style="height:4px;"></div><div class="primarycolumn">';
                    tresHtml += '<div class="level thirdblock menu-content open" style="display: none;"><div class=" " style="text-align:right;margin-top: 8px;" ><a href="http://goto/navmenuhelp" class="showhelpwindow" title="View help" ><span class="help " style="background-position: -2px -90px;cursor:pointer;"></span></a><span class="close menuclose" style="float:right;" title="Close internal online services menu" ></span></div>';

                    $.each(items, function (i) {
                        html += '   <div id="primary' + i + '" data-index="' + i + '" class="primarymenu" ><span>' + this['DisplayText'] + '</span></div>';
                        // Let us build the secondary level sub items
                        dos = this.SubItems;
                        if (dos) {
                            dosHtml += '<div id="secondary' + i + '" class="level middle one" style="display:none;"><div class="secondcolumn">';
                            // for each second level item
                            $.each(dos, function (j) {
                                dosHtml += '   <div id="secondary' + i + j + '" class="leveltwo " data-index="' + i + j + '"><a href="' + this['Url'] + '" target="_self"><span class="middle-item">' + this['DisplayText'] + '</span></a></div>';
                                // let us build the third level sub items
                                tres = this.SubItems;
                                if (tres) {
                                    tresHtml += '<div id="tertiary' + i + j + '"  class="main-content tertiary"  style="display: none;">';
                                    var tempHtml = '';
                                    var leftColumnHtml = ' <div class="linkscolumn left">';
                                    var rightColumnHtml = ' <div class="linkscolumn right">';
                                    var isExternal = false;
                                    var target = '_self';
                                    // for each third level item
                                    $.each(tres, function (k) {
                                        isExternal = (this['IsExternal']) ? this['IsExternal'] : false;
                                        if (isExternal === true) {
                                            target = '_blank';
                                        }
                                        tempHtml = '';
                                        // create the menu item                                       
                                        switch (this['ActionType']) {
                                            case "heading":
                                                tempHtml += '<h4>' + this['DisplayText'] + '</h4>';
                                                break;
                                            case "hyperlink":
                                                tempHtml += '<p class="linkitem "><a href="' + this['Url'] + '" target="' + target + '" class="' + this['Css'] + '" >' + this['DisplayText'];
                                                if (isExternal === true) {
                                                    tempHtml += '<span class="isnavigateaway "></span>';
                                                }
                                                tempHtml += '</a></p>';
                                                break;
                                            case "showhelp":
                                                tempHtml += '<p class="linkitem "><a href="' + this['Url'] + '" target="' + target + '" class="showhelpwindow">' + this['DisplayText'] + '</a></p>';
                                                break;
                                        }
                                        // determine the position to display
                                        displayPosition = (this['DisplayPosition']);
                                        if (!displayPosition) { displayPosition = "left"; }
                                        if (displayPosition === "left") {
                                            leftColumnHtml += tempHtml;
                                        }
                                        else {
                                            rightColumnHtml += tempHtml;
                                        }
                                    });
                                    leftColumnHtml += '</div>';
                                    rightColumnHtml += '</div>';
                                    var highlightHtml = '';
                                    //highlightHtml += '        <div class="highlightcontainer">';
                                    //highlightHtml += '           <h2>Search Analysis</h2>';
                                    //highlightHtml += '           <div class="highlight " style="height: 110px;">';
                                    //highlightHtml += '                <div class="highlight-img ">';
                                    //highlightHtml += '                    <img class="" width="165px" height="110px" alt="" src="/images/2in1-landing-highlight.jpg">';
                                    //highlightHtml += '                </div>';
                                    //highlightHtml += '                <div class="highlight-content ">';
                                    //highlightHtml += '                    <h4 style="margin-top: 0px;">Analysis By Id</h4>';
                                    //highlightHtml += '                    <p class="link-item " style="width: 120px;"><br/><span style="margin-bottom: 5px;display: block;">Enter analysis id and click "Ok"</span><br/><span><input type="text" class="menu-txtsearchanalysisid txtSearchAnalysisId" style="min-width: 55px !important;width: 55px;float:left;" value="" /><input type=button value="Ok" class="menu-openanalysis" style="float:right;" /></span></p>';
                                    //highlightHtml += '                </div>';
                                    //highlightHtml += '           </div>';
                                    //highlightHtml += '        </div>';
                                    tresHtml += leftColumnHtml + rightColumnHtml + highlightHtml;
                                    tresHtml += '</div>';
                                }
                            });                            
                            dosHtml += '</div></div>';
                        }
                    });
                    tresHtml += '    </div>';
                    html += '  </div></div>';
                    html = html + dosHtml + tresHtml;
                    // Close the original container
                    html += '</div>';
                    // create the controls from the html string and append to the top bar menu div element
                    _self.$element.append($(html));
                    $(".menucontainer").hide();
                    // set focus to the menu
                    $('.rootmenulink').focus();
                    // perform the onclick action on root menu link
                    $(".menurootli").bind("click", function (e) {
                        e.preventDefault();
                        if ($(".menucontainer").hasClass('show')) {
                            $(".menucontainer").hide().removeClass('show').addClass('hide');
                        }
                        else {
                            $(".menucontainer").show().removeClass('hide').addClass('show');
                        }
                    });
                    // perform the onclick event actions for the primary menu items
                    $('.primarymenu').bind("click", function (e) {
                        // remove any current selections
                        $('.primarymenu').removeClass('selected');
                        $('.primarymenu img').remove();
                        // high light the current menu item
                        $(this).addClass('selected');
                        $(this).append($('<img src="/images/menuselected.png" />'));

                        // hide all submenu
                        $('.level.middle').hide();
                        $('.thirdblock').hide();
                        // find & show the sub menu - secondory
                        var secondaryForSelected = '#secondary' + $(this).attr('data-index');
                        $(secondaryForSelected).show();
                        // show the first item's items
                        $('#secondary' + $(this).attr('data-index') + '0').click();

                    });

                    $('.leveltwo').bind("click", function (e) {
                        // remove any current selections
                        $('.leveltwo').removeClass('selected');
                        $('.leveltwo img').remove();
                        // high light the current menu item
                        $(this).addClass('selected');
                        $(this).append($('<img src="/images/menuselected.png" />'));
                        // hide all submenu
                        $('.tertiary').hide();
                        // find & show the sub menu - secondory
                        var tertiaryForSelected = '#tertiary' + $(this).attr('data-index');
                        $(tertiaryForSelected).show();
                        $('.thirdblock').show();
                        $('.linkscolumn').find('h4:first').css('margin-top', '0px');
                    });

                    $('.menuclose').bind("click", function (e) {
                        // hide all submenu
                        $('.level.middle').hide();
                        $('.tertiary').hide();
                        $(".menucontainer").hide().removeClass('show').addClass('hide');
                    });
                    $('.newmenu').bind('click', function () {
                        $('.dont-close-menu').toggleClass('open');
                    });
                }
            }

            // return the self object to enable chaining
            return _self;
        };

        // private method to get an array of query strings from a url
        var _getQueryString = function (url) {
            var q = '';
            if (url) {
                q = url.split('?')[1];
            }
            return q;
        };

        var _createMenuItem = function (item) {
            var linkstring = '';
            var actionType = item['ActionType'];
            if (actionType == '' || actionType == undefined || actionType == null) {
                actionType = 'Redirect';
            }
            var url = item['Url'];
            var qs = _getQueryString(url);
            if (qs && qs.length > 0) {
                url = url + '&';
            } else {
                url = url + '?';
            }
            url = url + 'bcid=' + item['FunctionalAreaId'];

            switch (actionType) {
                case 'DoNothing':
                    linkstring = '<a href="javascript:void(0);" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    break;
                case 'ShowFlyoutLink':
                    break;
                case 'OpenWindow':
                    linkstring = '<a href="' + url + '" target="_blank" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    break;
                case 'Redirect':
                    linkstring = '<a href="' + url + '" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    break;
                case 'Render':
                    linkstring = '<a href="' + url + '" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    break;
                case 'Screen':
                    linkstring = '<a href="' + url + '" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    break;
                case 'ShowFlyOut':
                    linkstring = '<a href="' + url + '" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    break;
                case 'ShowOverlay':
                    //linkstring = '<a href="' + url + '" class="showoverlay" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    linkstring = '<a href="' + url + '" title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" data-funcareaid="' + item['FunctionalAreaId'] + '" data-svcid="' + item['ServiceId'] + '" data-procid="' + item['ProcessId'] + '" data-funcid="' + item['FunctionId'] + '" >' + item['Text'] + '</a>';
                    break;
                case 'Widget':
                    break;
                default:
            }
            return linkstring;
        };

        // Run initializer
        _self.init();
        // return self for chaining
        return _self;
    };
    // Version of the plugin
    $.Nsga.MainMenu.version = '1.0.0';
    // build MainMenu from any html element
    $.fn.buildMainMenu = function (menuData) {
        return (new $.Nsga.MainMenu(this, menuData));
    };
})(jQuery, window, document);