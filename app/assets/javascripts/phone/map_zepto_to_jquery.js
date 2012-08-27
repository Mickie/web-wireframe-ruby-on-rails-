var jQuery = Zepto;

function addMissingStuffWeNeedToZepto()
{
  var core_rnotwhite = /\S/;
  var rtrim = core_rnotwhite.test("\xA0") ? (/^[\s\xA0]+|[\s\xA0]+$/g) : /^\s+|\s+$/g;
  $.trim = String.prototype.trim ? function(text)
  {
    return text == null ? "" : String.prototype.trim.call(text);
  } :
  function(text)
  {
    return text == null ? "" : text.toString().replace(rtrim, "");
  }
  
  $.fn.extend = function(aGroupOfFunctions)
  {
    for (var theKey in aGroupOfFunctions)
    {
      $.fn[theKey] = aGroupOfFunctions[theKey];
    }
  }
}
addMissingStuffWeNeedToZepto();
