if (typeof console === "undefined" || typeof console.log === "undefined") 
{
   console = {};
   console.log = function() {};
}

if (!Date.now) 
{
  Date.now = function() 
  {
    return new Date().valueOf();
  }
}

var ie = (function(){

    var undef,
        v = 3,
        div = document.createElement('div'),
        all = div.getElementsByTagName('i');
    
    while (
        div.innerHTML = '<!--[if gt IE ' + (++v) + ']><i></i><![endif]-->',
        all[0]
    );
    
    return v > 4 ? v : undef;
    
}());
   
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

function killEvent(e)
{
  e.stopPropagation();
  e.preventDefault();
  return false;
}

function buildUrl(aServer, aPath)
{
  return ('https:' == document.location.protocol ? 'https://' : 'http://') + aServer + "/" + aPath;
}

function makeUrlHttpsSafe(aUrl)
{
  if ('https:' == document.location.protocol)
  {
    return aUrl.replace("http", "https");
  }
  return aUrl;
}

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

Date.prototype.toISOString || (Date.prototype.toISOString = (function(){
  
  var str = function(n, l) {
    var str = String(n),
      len = l || 2;
    while( str.length < len )
      str = '0' + str;
    return str;
  };
  
  return function(){
      return isFinite( this.getTime() )
        ? String(this.getUTCFullYear()).concat( '-', 
          str(this.getUTCMonth() + 1), "-",
          str(this.getUTCDate()), "T",
          str(this.getUTCHours()), ":",
          str(this.getUTCMinutes()), ":",
          str(this.getUTCSeconds()), ".",
                      str(this.getUTCMilliseconds(),3), "Z" )
                    : 'Invalid Date';
    };
  
})() );

$(function()
{
  setTimeout(function()
  {
    window.scrollTo(0, 1);
  }, 100);
});

