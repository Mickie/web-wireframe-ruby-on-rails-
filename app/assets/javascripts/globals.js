
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
      return unescape(theCurrentValue);
    }
  }
  return null;
};

String.prototype.escapeQuotes = function()
{
  return this.replace(/([\\"'])/g, "\\$1");
};

Function.prototype.subclass= function(base) {
    var c= Function.prototype.subclass.nonconstructor;
    c.prototype= base.prototype;
    this.prototype= new c();
};
Function.prototype.subclass.nonconstructor= function() {};

$(function()
{
  setTimeout(function()
  {
    window.scrollTo(0, 1);
  }, 100);
});

