if (typeof console === "undefined" || typeof console.log === "undefined") 
{
   console = {};
   console.log = function() {};
}
   
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

function enableTextAreaMaxLength()
{
  var ignore = [8, 9, 13, 33, 34, 35, 36, 37, 38, 39, 40, 46];

  $("#frameContent").on('keypress', 'textarea[maxlength]', function(event)
  {
    var self = $(this), maxlength = self.attr('maxlength'), code = $.data(this, 'keycode');
    if (maxlength && maxlength > 0)
    {
      return (self.val().length < maxlength || $.inArray(code, ignore) !== -1 );
    }
  }).on('keydown', 'textarea[maxlength]', function(event)
  {
    $.data(this, 'keycode', event.keyCode || event.which);
  });
}

function updateTimestamps()
{
  $(".timestamp").timeago();
}

$(function()
{
  setTimeout(function()
  {
    window.scrollTo(0, 1);
  }, 100);

  jQuery.timeago.settings.strings =
  {
    prefixAgo : null,
    prefixFromNow : null,
    suffixAgo : "",
    suffixFromNow : "from now",
    seconds : "%d s",
    minute : "< 1 m",
    minutes : "%d m",
    hour : "~1 h",
    hours : "%d h",
    day : "~1 d",
    days : "%d d",
    month : "~1 mth",
    months : "%d mth",
    year : "1 y",
    years : "%d y",
    wordSeparator : " ",
    numbers : []
  };

  enableTextAreaMaxLength();

  updateTimestamps();
  setInterval(updateTimestamps, 60000);

});

