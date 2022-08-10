/*!
 * Nsga top bar implementation
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
    var name = 'ToolBar';
    // Nsga is the namespace branched from $ for plugins to avoid conflicts. 
    // if empty, initialize else append to existing definitions.
    if (!$.Nsga) {
        $.Nsga = {};
    }
    // Define the ToolBar plug in
    $.Nsga.ToolBar = function (element, topBarData) {
        // To avoid scope issues, use '_self' instead of 
        // 'this' to reference this instance from internal events and functions.
        var _self = $.Nsga.ToolBar;
        // Access to jQuery and DOM versions of element
        _self.$element = $(element);
        _self.element = element;
        // Add a reverse reference to the DOM object
        //_self.$element.data(name, _self);
        _self.init = function () {
            // render the control
            _self.render(topBarData);
            // return self for chaining
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
        // renders the top bar
        _self.render = function (topBarData) {            
            if (_self.$element && topBarData) {
                _self.$element.empty();
                // Get the menu data
                var links = topBarData.Menu;                
                if (links) {
                    var sublinks;
                    // create the html unordered list container
                    // This is the root level for top bar menu
                    var html = '<ul id="nav" class="my-intel"><div class="uheaderlinks">';
                    var subItemsHtml = '';
                    // for each navigation item
                    $.each(links, function () {
                        // create a hyper link and add it as a list item
                        html += '<li class="link " ';
                        // Get sub items
                        sublinks = this['SubItems'];
                        if (sublinks && sublinks.length && sublinks.length > 0) {
                            html += 'style="padding-right:16px;" ';
                        }
                        html += '>';
                        //// if the link is the sign out link, display the lick icon in front of it
                        //if (this['Text'].toLowerCase() === 'log out' || this['Text'].toLowerCase() === 'sign out') {
                        //    html += '<span class="lockicon"></span>';
                        //}
                        html += _createMenuItem(this);
                        
                        if (sublinks && sublinks.length && sublinks.length > 0) {
                            //html += '<span class="down-arrow"></span>';
                            // create the div to hold the sub menu items   
                            html += '<ul class="child" style="padding-bottom: 5px;"><div>';
                            // for each sub item
                            $.each(sublinks, function () {
                                html += '<li>' + _createMenuItem(this); +'</li>';
                            });
                            // close the opened html elements
                            html += '</div></ul>';                           
                        }
                        // close the top level list item
                        html += '</li>';
                    });
                    // close the unordered list
                    html += '</div></ul>';
                    // create the controls from the html string and append to the top bar menu div element
                    _self.$element.append($(html));
                    // Remove the class of child and grandchild; this removes the css 'fallback'
                    $("#nav ul.child").removeClass("child");
                    $("#nav ul.grandchild").removeClass("grandchild");
                    // When a list item that contains an unordered list is hovered on
                    $("#nav li").has("ul").hover(function () {
                        //Add a class of current and fade in the sub-menu
                        $(this).addClass("current selected ").children("ul").show();
                        //animate our up down arrows next to the menu
                        $(this).find('.down-arrow').addClass('up-arrow').removeClass('down-arrow');
                    }, function () {
                        // On mouse off remove the class of current
                        // Stop any sub-menu animation and set its display to none
                        $(this).removeClass("current selected ").children("ul").hide();
                        //animate our up down arrows next to the menu
                        $(this).find('.up-arrow').addClass('down-arrow').removeClass('up-arrow');
                    });

                    $(".my-intel .link").bind("click mouseenter", function (index) {
                        var mywidth = $(this).width();
                        var myoffset = $(this).offset();
                        var myx = Math.round(myoffset.left);
                        var moveto = myx + Math.round(mywidth / 2) - 4000;
                        var mybgpos = moveto + "px top";
                        $("#header").css("background-position", mybgpos);
                    });

                    $(".my-intel .link").bind("mouseleave", function (index) {
                        if ($(".my-intel .link.selected").length > 0) {
                            var mywidth = $(".my-intel .link.selected").width();
                            var myoffset = $(".my-intel .link.selected").offset();
                            var myx = Math.round(myoffset.left);
                            var moveto = myx + Math.round(mywidth / 2) - 4000;
                            var mybgpos = moveto + "px top";
                            $("#header").css("background-position", mybgpos);
                        }
                        else {
                            $("#header").css("background-position", "");
                        }
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
            //html += '<span class="down-arrow"></span>';
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
            var sublinks = item['SubItems'];
            var hasSublinks = (sublinks && sublinks.length && sublinks.length > 0);
            linkstring = '<a ';
            switch (actionType) {
                case 'DoNothing':
                    linkstring += 'href="javascript:void(0);" ';                    
                    break;
                case 'ShowFlyoutLink':
                    linkstring += 'href="' + url +'"';
                    break;
                case 'OpenWindow':
                    linkstring += 'href="' + url + '" target="_blank"';
                    break;
                case 'Redirect':
                    linkstring += 'href="' + url + '"';
                    break;
                case 'Render':
                    linkstring += 'href="' + url + '"';
                    break;
                case 'Screen':
                    linkstring += 'href="' + url + '"';
                    break;
                case 'ShowFlyOut':
                    linkstring += 'href="' + url + '"';
                    break;
                case 'ShowOverlay':
                    linkstring += 'href="' + url + '" class="showoverlay" ';
                    break;
                case 'ShowHelpWindow':
                    linkstring += 'href="' + url + '" class="showhelpwindow" ';
                    break;
                case 'Widget':
                    break;
                default:
            }
            linkstring += ' title="' + item['ToolTip'] + '"  data-ctrlid="' + item['Id'] + '" >' + item['Text'];
            linkstring += (hasSublinks === true) ? '<span class="down-arrow"></span>' : '';
            linkstring += '</a>';
            return linkstring;
        };
        // Run initializer
        _self.init();
        // return self for chaining
        return _self;
    };
    // Version of the plugin
    $.Nsga.ToolBar.version = '1.0.0';   
    // build topbar from any html element
    $.fn.buildToolBar = function (topBarData) {
        return (new $.Nsga.ToolBar(this, topBarData));
    };
})(jQuery, window, document);