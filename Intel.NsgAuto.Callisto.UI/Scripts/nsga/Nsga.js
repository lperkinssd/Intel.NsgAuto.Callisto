/*!
 * Nsga client side framework implementation
 * Author: Jose Kurian <jose.kurian@intel.com>
 * 
 *<remarks>
 * Usage examples : 
 * Nsga.version;
 * Nsga.Environment.getUrl();
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
 *</uses>
 */

// "use strict"; puts our code into strict mode, 
// which catches some common coding problems by throwing exceptions, 
// prevents/throws errors when relatively "unsafe" actions are taken 
// and disables Javascript features that are confusing or poorly thought out. 
// To read about this in detail, please check ECMAScript 5 Strict Mode.
"use strict";
// Nsga root namespace
var Nsga = {
    // version of the framework
    version: '1.0.0',
    // html language code from the document object
    languageCode: document.documentElement.lang == "" ? "en_us" : document.documentElement.lang.toLowerCase(),
    // Enables the scripts to ensure that an intance is initialized check if an object is null or undefined
    // This is a re-usable function for null checks, returns true if initialized. false otherwise.
    isInitialized: function (instance) {
        // If instance is null, return false
        if (instance == null) { return false };
        // If instance is 'undefined', return false
        if (typeof (instance) === 'undefined') { return false };
        return true;
    },
    // This is a re-usable method to write to the console of a window object
    writeTrace: function (trace) {
        if (window.console && window.console.log)
            window.console.log('trace data: ' + trace);

        // TO DO: Create a log entry in the database

    },
    // The sub namespace holding the environment related data and functions
    Environment: function () {
        // Private variables for holding the expected host headers
        // Note that private implementations is not visible through the namespace
        var hostHeaders = {
            "local": "http://localhost:64481/",
            "dev": "http://dev.domain.com/",
            "test": "http://tst.domain.com/",
            "preprod": "http://day1.domain.com/",
            "prod": "http://web.domain.com/"
        };
        // private variable holding the host header to environment mappings
        var hostMappings = {
            "name here": "local",
            "dev.domain.com": "dev",
            "tst.domain.com": "test",
            "day1.domain.com": "preprod",
            "web.domain.com": "prod"
        };
        // private method to get the current url
        var _getUrl = function () {
            return ((hostMappings[window.location.hostname.toLowerCase()])
                ? hostHeaders[hostMappings[window.location.hostname]]
                : hostHeaders["local"]);
        };
        // private method to get the current url
        var _getHost = function (env) {
            return ((env) ? hostMappings[env] : hostMappings["local"]);
        };
        // private method to get the current url
        var _getEnvironment = function () {
            return ((window.location.hostname)
                ? hostMappings[window.location.hostname]
                : "local");
        }
        // These are the public methods
        return {
            // gets the url for the current environment based on the host header name
            getUrl: function () {
                // invoke the private implementation
                return _getUrl();
            },
            // gets the host 
            getHost: function (env) {
                return _getHost(env);
            },
            // gets the environment based on the document 
            getEnvironment: function () {
                return _getEnvironment();
            },
            // public method to get the current document language code
            getLanguage: function () {
                return Nsga.languageCode;
            }
        };
    }(),
    Browser: {
        // TO DO: Functions to capture browser information from client side

    },
    Url: function(){
        // private method to get an array of query strings from a url
        var _getQueryStringParameters = function (url) {
            var vars = [], hash;
            var q = url.split('?')[1];
            if (q != undefined) {
                q = q.split('&');
                for (var i = 0; i < q.length; i++) {
                    hash = q[i].split('=');
                    vars.push(hash[1]);
                    vars[hash[0]] = hash[1];
                }
            }
            return vars;
        };
        // private function to get a query string value from an array of query string name values
        var _getQueryStringValue = function (queryStrings, queryStringKey) {
            return queryStrings[queryStringKey];
        };
        // private function to do a redirect
        var _redirect = function (url) {
            window.location.href = url;
        };
        // These are the public methods
        return {
            // public method to get an array of query strings from a url
            // an array of name value pairs will be returned
            // How to use:
            // Nsga.Url.getQueryStringParameters('<yoururl>');
            getQueryStringParameters: function (url) {
                return _getQueryStringParameters(url);
            },
            // public method to get the value of a query strings from a url
            // How to use:
            // Nsga.Url.getQueryStringValue('<yoururl>', 'key');
            getQueryStringValue: function (url, key) {
                return _getQueryStringValue(_getQueryStringParameters(url), key);
            },
            // public method which will do a redirect operation for you
            // How to use:
            // Nsga.Url.redirect('<yoururl>');
            redirect: function (url) {
                return _redirect(url);
            }
            // Add a comma and add more re-usable functions as required following the standards
        };
    }()

    // Append any new namespace required here following standards.
}
