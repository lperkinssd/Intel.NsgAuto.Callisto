/*!
 * Nsga client side framework root namespace implementation implementation
 * Author: Jose Kurian <jose.kurian@intel.com>
 * 
 *<remarks>
 * Usage examples : 
 * var args = 'framework initialization data';
 * Nsga.Framework.init(args);
 * 
 * Nsga namespace contains both code libraries as well as Immediately-Invoked Function Expressions (IIFE)
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
 * jquery-1.8.1.js
 * json.js
 * Nsga.js
 *</uses>
 */
// If Nsga is already defined and loaded, append the implementations given below
Nsga = InitializeNamespace(Nsga);
function InitializeNamespace(namepace) {
    if (typeof (namepace) === "undefined") namepace = {}; else namepace = namepace || {};
    return namepace;
}
/// Nsga client side framework
Nsga.Framework = {
    /// Initializes Nsga application framework
    Config: function () {
        // the default framework values
        var defaults = {
            SessionId: '',
            Environment: 'localhost',
            WebRootUrl: ''
        };
        // update\extend the existing framework data
        var opts = $.extend(defaults);
        // private method to get 
        var _getSessionId = function () {
            return opts['SessionId'];
        };
        // private method to get 
        var _getUserWWId = function () {
            return opts['WWID'];
        };
        // private method to get 
        var _getEnvironment = function () {
            return opts['Environment'];
        };
        // private method to get 
        var _getWebRootUrl = function () {
            return opts['WebRootUrl'];
        };
        // private method to get SelectedTimeZoneId
        var _getSelectedTimeZoneId = function () {
            return opts['SelectedTimeZoneId'];
        };
        // private method to get SelectedTimeZoneOffset
        var _getSelectedTimeZoneOffset = function () {
            return opts['SelectedTimeZoneOffset'];
        };
        // private method to get SelectedTimeZoneOffset
        var _getMessageDisplayTimeOut = function () {
            var result = opts['MessageDisplayTimeOut'];
            if (!result) { result = 15000; }
            return result;
        };
        // private method to get 
        var _getUserIdSid = function () {
            return opts['IdSid'];
        };
        // private method to get 
        var _getCurrentWorkWeek = function () {
            // Get the work week from the user settings
            return opts['WorkWeek'];
        };
        // These are the public methods
        return {
            Init: function (parameters) {
                if (parameters && parameters != 'undefined') {
                    opts = $.extend(defaults, parameters);
                }
            },
            // gets  
            getSessionId: function () {
                // invoke the private implementation
                return _getSessionId();
            },
            // gets  
            getUserWWId: function () {
                return _getUserWWId();
            },
            // gets the  
            getEnvironment: function () {
                return _getEnvironment();
            },
            // gets the  
            getWebRootUrl: function () {
                return _getWebRootUrl();
            },
            // gets the Message Display TimeOut
            getMessageDisplayTimeOut: function () {
                return _getMessageDisplayTimeOut();
            },
            // gets the SelectedTimeZoneId
            getSelectedTimeZoneId: function () {
                return _getSelectedTimeZoneId();
            },
            // gets the offset value
            getSelectedTimeZoneOffset: function () {
                return _getSelectedTimeZoneOffset();
            },
            // gets the offset value
            getTimeZoneAgnosticDate: function (cellValue) {
                return new Date(cellValue + 'Z');
            },//Gets a cell value date into UTC
            // gets the offset value
            getUserTimeZoneDate: function (date) {
                var convertedDate = date;
                try {
                    if (date && (date instanceof Date)) {
                        // Obtain local UTC offset and convert to msec
                        var localOffset = date.getTimezoneOffset() * 60000;
                        // Obtain the current UTC time, by adding the local time zone offset to the local time.
                        // (localTime you will get from getTime()), obtain UTC time in msec
                        var utc = date.getTime() + localOffset;
                        // obtain and add destination's UTC time offset
                        // for example, India is UTC + 5.5 hours
                        var offset = _getSelectedTimeZoneOffset();
                        var usersTimeZone = utc + (3600000 * offset);
                        // convert msec value to date string
                        convertedDate = new Date(usersTimeZone);
                    }
                }
                catch (ex) {
                    Nsga.writeTrace(ex);
                }
                return convertedDate;
            },
            // gets the offset value, passed in date must be Utc date
            getUserTimeZoneDateFromUtc: function (date) {
                var convertedDate = date;
                try {
                    if (date && (date instanceof Date)) {
                        // obtain UTC time in msec
                        var utc = date.getTime();
                        // obtain and add destination's UTC time offset
                        // for example, India is UTC + 5.5 hours
                        var offset = _getSelectedTimeZoneOffset();
                        var usersTimeZone = utc + (3600000 * offset);
                        // convert msec value to date string
                        convertedDate = new Date(usersTimeZone);
                    }
                }
                catch (ex) {
                    Nsga.writeTrace(ex);
                } 
                return convertedDate;
            },
            getUserTimeZoneDateFromUtcString: function (date) {
                var parsedDate = Date.parse(date);
                var formattedDate;
                var utcDate;
                try {
                    if (parsedDate) {
                         utcDate = Nsga.Framework.Config.getUserTimeZoneDateFromUtc(new Date(parsedDate));
                    }
                    if (utcDate) {
                        formattedDate = Nsga.Framework.Config.getFormattedDate(utcDate);
                    }
                }

                catch (ex) {
                    Nsga.writeTrace(ex);
                }
                return formattedDate;
            },
            getFormattedDate: function (date) {
                if (date) {
                    var hours = date.getHours();
                    var minutes = date.getMinutes();
                    var seconds = date.getSeconds();
                    //var ampm = hours >= 12 ? 'PM' : 'AM';
                    //hours = hours % 12;
                    //hours = hours ? hours : 12; // the hour '0' should be '12'
                    hours = hours < 10 ? '0' + hours : hours;
                    minutes = minutes < 10 ? '0' + minutes : minutes;
                    var strTime = hours + ':' + minutes + ':' + seconds;//+ ' ' + ampm;
                    return date.getMonth() + 1 + "/" + date.getDate() + "/" + date.getFullYear() + " " + strTime;
                }
            },
            getShortDayName: function (date) {
                if (!date) {
                    date = new Date();
                }
                var weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                return weekdays[date.getDay()];
            },
            // gets the current work week
            getCurrentWorkWeek: function () {
                return _getCurrentWorkWeek();
            },
            // gets  user IDSID
            getUserIdSid: function () {
                return _getUserIdSid();
            },
        }
    }(),
    Constants: function () {
        return {
            MODE_CREATE: 'CREATE',
            MODE_EDIT: 'EDIT',
            QS_EVENTSESSIONID: "qsevtsessnid",
            // Add a comma and append any required constants here
        };
    }(),
    Persistence: function () {
        return {
            add: function (key, value) {
                sessionStorage.setItem(key, value);
            },
            get: function (key) {
                return sessionStorage.getItem(key);
            },
            clear: function (key) {
                sessionStorage.removeItem(key);
            }
        }
    }(),
    Kendo: function () {
        var _hideKendoWindows = function () {
            $('div.k-window').each(function (index) { $(this).hide(); }); //Closes all open Kendo windows
        };
        return {
            hideKendoWindows: function () {
                _hideKendoWindows();
            },
        }
    }(),
    Messages: function () {
        // notification in span in divNotification in site.Master
        //var _notifier = $('#notification').kendoNotification({
        //    position: {
        //        pinned: true,
        //        top: 30,
        //        right: 30
        //    },
        //    autoHideAfter: 3000,
        //    stacking: "down",
        //    templates: [{
        //        type: "info",
        //        template: "<div class='unified info'><span class='info-ico-left'></span><span>#= message #</span></div>" //$("#infoTemplate").html()
        //    }, {
        //        type: "warn",
        //        template: "<div class='unified warning'><span class='warn-ico-left'></span><span>#= message #</span></div>"//$("#errorTemplate").html()
        //    }, {
        //        type: "error",
        //        template: "<div class='unified error'><span class='error-ico-left'></span><span>#= message #</span></div>"//$("#errorTemplate").html()
        //    }, {
        //        type: "success",
        //        template: "<div class='unified success'><span class='success-ico-left'></span><span>#= message #</span></div>"//$("#successTemplate").html()
        //    }]

        //});
        var _show = function (msg, msgType, autoCloseTime) {
            if (autoCloseTime === undefined) { autoCloseTime = 3000; }
            // notification in span in divNotification in site.Master
            var _notifier = $('#notification').kendoNotification({
                position: { pinned: true, top: 30, right: 30 },
                autoHideAfter: autoCloseTime,
                stacking: "down",
                templates: [{
                    type: "info",
                    template: "<div class='unified popup info wrapword'><span class='info-ico-left'></span><span class='wrapword'>#= message #</span></div>" //$("#infoTemplate").html()
                }, {
                    type: "warn",
                    template: "<div class='unified popup warning wrapword'><span class='warn-ico-left'></span><span class='wrapword'>#= message #</span></div>"//$("#errorTemplate").html()
                }, {
                    type: "error",
                    template: "<div class='unified popup error wrapword'><span class='error-ico-left'></span><span class='wrapword'>#= message #</span></div>"//$("#errorTemplate").html()
                }, {
                    type: "success",
                    template: "<div class='unified popup success wrapword'><span class='success-ico-left'></span><span class='wrapword'>#= message #</span></div>"//$("#successTemplate").html()
                }]
            });
            var _notify = $('#notification').data("kendoNotification");
            switch (msgType) {
                case 'error':
                    // display the error message
                    _notify.hide().error({ message: msg });
                    break;
                case 'warn':
                    // display the warn message
                    _notify.hide().warn({ message: msg });
                    break;
                case 'success':
                    // display the success message
                    _notify.hide().success({ message: msg });
                    break;
                case 'info':
                default:
                    // display the info message
                    _notify.hide().info({ message: msg });
                    break;
            }
        };
        var _showUserInfo = function () {
            $('.getbywwid').bind('click mouseover', function (e) {
                try {
                    var element = $(this);
                    var wwId = element.text();
                    var toolTip = element.data("kendoTooltip");
                    //if (!toolTip && wwId && wwId.length > 0) {
                    if (wwId && wwId.length > 0) {
                        Nsga.Framework.getDataToUrl({ 'id': wwId }, Nsga.Promise.Constants.URL_GETEMPLOYEE,
                                null, null,
                                function (results) {
                                    if (results && results.Data) {
                                        element.attr("title", results.Data.Name + ' [' + results.Data.WWID + "]<br/>" + results.Data.Email);
                                        var tip = element.kendoTooltip({
                                            position: "left",
                                            showOn: "click",
                                        }).data("kendoTooltip");
                                        tip.show();
                                    }
                                }, null);
                    }
                } catch (e) {
                    ///Logging failed, cann't do anything about it!
                }
            });
        };
        var _showProgressBar = function () {
            $('<div class="progressbar" />').css({
                'position': 'absolute',
                'top': '0',
                'left': '0',
                'width': '100%',
                'height': '100%',
                'background': 'url("/Images/loader.gif") center center no-repeat',
                'background-position': 'center',
                'z-index': '3000'
            }).appendTo('body');
        };
        var _removeProgressBar = function () {
            $('body').remove('.progressbar');
            $('.progressbar').remove();
        };
        return {
            // display a notification message based on message type
            show: function (msg, msgType, autoCloseTime) {
                return _show(msg, msgType);
            },
            showError: function (msg, autoCloseTime) {
                return _show(msg, 'error', autoCloseTime);
            },
            showWarning: function (msg, autoCloseTime) {
                return _show(msg, 'warn', autoCloseTime);
            },
            showSuccess: function (msg, autoCloseTime) {
                return _show(msg, 'success', autoCloseTime);
            },
            showInformation: function (msg, autoCloseTime) {
                return _show(msg, 'info', autoCloseTime);
            },
            showUserInfo: function () {
                return _showUserInfo();
            },
            showProgressBar: function () {
                return _showProgressBar();
            },
            removeProgressBar: function () {
                return _removeProgressBar();
            },
        };
    }(),
    /// submits data in a form to a web address in GET mode in json format
    /// How to use :
    /// Nsga.Framework.getFormToUrl('<yourformname>', '<yoururl>', '<yourfntobinvokedonsend>','<yourfntobinvokedoncomplete>', '<yourfntobinvokedonsuccess>', '<yourfntobinvokedonerror>');
    getFormToUrl: function (formName, submitUrl, onSend, onComplete, onSuccess, onError) {
        // get the form object from the form name
        var form = $('#' + formName);
        // if the form object is not null
        if (Nsga.isInitialized(form)) {
            // serialize form data
            var formData = form.serialize();
            // submit the form data in GET mode in json format
            $.ajax({
                url: submitUrl,
                data: formData,
                type: 'GET',
                dataType: 'json',
                beforeSend: onSend,
                complete: onComplete,
                success: onSuccess,
                error: onError,
                cache: false
            });
        }
    },
    /// submits data to a web address in GET mode in json format
    /// How to use :
    /// Nsga.Framework.getDataToUrl('<yourjsonobject>', '<yoururl>', '<yourfntobinvokedonsend>','<yourfntobinvokedoncomplete>', '<yourfntobinvokedonsuccess>', '<yourfntobinvokedonerror>');
    getDataToUrl: function (data, submitUrl, onSend, onComplete, onSuccess, onError) {
        $.ajax({
            url: submitUrl,
            data: data,
            type: 'GET',
            dataType: 'json',
            beforeSend: onSend,
            complete: onComplete,
            success: onSuccess,
            error: onError,
            cache: false
        });
    },
    /// submits data to a web address in POST mode in json format
    /// How to use :
    /// Nsga.Framework.postFormToUrl('<yourformname>', '<yoururl>', '<yourfntobinvokedonsend>','<yourfntobinvokedoncomplete>', '<yourfntobinvokedonsuccess>', '<yourfntobinvokedonerror>');
    postFormToUrl: function (formName, submitUrl, onSend, onComplete, onSuccess, onError) {
        var form = $('#' + formName);
        if (Nsga.isInitialized(form)) {
            var formData = form.serialize();
            $.ajax({
                url: submitUrl,
                data: formData,
                type: 'POST',
                dataType: 'json',
                beforeSend: onSend,
                complete: onComplete,
                success: onSuccess,
                error: onError,
                cache: false
            });
        }
    },
    /// submits data to a web address in POST mode in json format
    /// How to use :
    /// Nsga.Framework.postDataToUrl('<yourjsonobject>', '<yoururl>', '<yourfntobinvokedonsend>','<yourfntobinvokedoncomplete>', '<yourfntobinvokedonsuccess>', '<yourfntobinvokedonerror>', 'true if async post, by default false = sync');
    postDataToUrl: function (data, submitUrl, onSend, onComplete, onSuccess, onError, isAsync) {
        if (!isAsync)
            isAsync = false;

        $.ajax({
            url: submitUrl,
            data: data,
            type: 'POST',
            dataType: 'json',
            beforeSend: onSend,
            complete: onComplete,
            success: onSuccess,
            error: onError,
            cache: false,
            contentType: 'application/json',
            async: isAsync
        });
    },
    /// Enables the browser client to log a message from client side interactions
    /// value of selector must be in format '#selector' or '.selector'
    /// message is the log message
    /// projectids as csv
    setLogMessage: function (selector, message, projectIds) {
        try {
            var el = $(selector);
            if (selector) {
                // get session id from the data that was initialized when the page loaded
                var sessionId = Nsga.Framework.Init.getSessionId();
                var funcAreaId = selector.attr('data-funcareaid');
                // construct the name value pairs for the loghandler and pass the data
                var data = Nsga.Framework.Constants.QS_EVENTSESSIONID + '=' + sessionId + '&';
                data += Nsga.Framework.Constants.QS_FUNCTIONALAREAID + '=' + funcAreaId + '&';
                data += Nsga.Framework.Constants.QS_LOGMESSAGE + '=' + message + '&';
                data += Nsga.Framework.Constants.QS_PROJECTIDS + '=' + projectIds;
                // ... add more, if required.
                // Send the log request
                Nsga.Framework.getDataToUrl(data, '/Handlers/LogHandler.ashx', null, null, null, null);
            }
        } catch (e) {
            ///Logging failed, cann't do anything about it!
        }
    },
    openHelpWindow: function (url, height, width, left, top) {
        var helpWindow = window.open(url, 'Help', 'height=' + height + ',width=' + width
            + ',left=100,top=100,location=no,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no');
    }
}
