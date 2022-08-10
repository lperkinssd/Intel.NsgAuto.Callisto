/*!
 * Clear on focus implementation
 * Author: 1. Jose Kurian <jose.kurian@intel.com> 
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
 * jquery-1.8.1.js 
 * Nsga.js
 * Nsga.Framework.js
 * core.css
 *</uses>
 */

(function ($) {
    $.fn.clearOnFocus = function () {
        function clearOnFocusFocus(event) {
            if ($(this).val() == $(this).data('clearonfocus')) {
                $(this).val('');
            }
        }
        function clearOnFocusBlur(event) {
            if ($.trim($(this).val()) == '') {
                $(this).val($(this).data('clearonfocus'));
            }
        }
        return this.each(function () {
            $(this).data('clearonfocus', $(this).attr('value'));

            //	unbind any previous listeners
            $(this).unbind('focus', clearOnFocusFocus);
            //$(this).unbind('click', clearOnFocusFocus(e));
            $(this).unbind('blur', clearOnFocusBlur);


            //	bind listeners to the functions
            $(this).bind('focus', clearOnFocusFocus);
            //$(this).bind('click', clearOnFocusFocus(e));
            $(this).bind('blur', clearOnFocusBlur);
        });
    };
})(jQuery);