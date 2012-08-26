var jQuery = Zepto;

var core_rnotwhite = /\S/;
var rtrim = core_rnotwhite.test("\xA0") ? (/^[\s\xA0]+|[\s\xA0]+$/g) : /^\s+|\s+$/g;
$.trim = String.prototype.trim ?
    function( text ) {
      return text == null ?
        "" :
        String.prototype.trim.call( text );
    } :

    // Otherwise use our own trimming functionality
    function( text ) {
      return text == null ?
        "" :
        text.toString().replace( rtrim, "" );
    }