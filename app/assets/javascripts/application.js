// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// update config/environments/production.rb with other files you want to also include in addition to this one
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require autocomplete-rails
//= require bootstrap
//= require facebook_js_sdk_loader
//= require google_analytics
//= require_tree ./lib
//= require_tree ./facebook
//= require_tree ./utilities
//= require_tree ./modules
//= require_tree ./layouts

function createDelegate(anObject, aMethod)
{
  var theDelegate = function()
  {
    return aMethod.apply(anObject, arguments);
  }
  return theDelegate;
}; 

function createExtendedDelegate(anObject, aMethod, anArgumentExtensionArray)
{
  var theDelegate = function()
  {
    var theArgsAsArray = Array.prototype.slice.call(arguments);
    var theNewArguments = theArgsAsArray.concat(anArgumentExtensionArray)
    return aMethod.apply(anObject, theNewArguments);
  }

  return theDelegate;
};

function setCookie(aName, aValue, aNumberOfDaysTillExpire)
{
  var theExpiration = "";
  if (aNumberOfDaysTillExpire)
  {
    var theExpirationDate = new Date();
    theExpirationDate.setDate(theExpirationDate.getDate() + aNumberOfDaysTillExpire);
    theExpiration = "; expires=" + theExpirationDate.toUTCString();
  }

  var theCookieValue = escape(aValue) + theExpiration;

  document.cookie = aName + "=" + theCookieValue;
};

function getCookie(aName)
{
  var i, theCurrentName, theCurrentValue, theCookieArray = document.cookie.split(";");
  for ( i = 0; i < theCookieArray.length; i++)
  {
    theCurrentName = theCookieArray[i].substr(0, theCookieArray[i].indexOf("="));
    theCurrentValue = theCookieArray[i].substr(theCookieArray[i].indexOf("=") + 1);
    theCurrentName = theCurrentName.replace(/^\s+|\s+$/g, "");
    if (theCurrentName == aName)
    {
      return unescape( theCurrentValue );
    }
  }
  return null;
};

String.prototype.escapeQuotes = function() 
{ 
   return this.replace(/([\\"'])/g, "\\$1"); 
};

$(function()
{
  setTimeout(function()
  {
    window.scrollTo(0, 1);
  }, 100);
});

