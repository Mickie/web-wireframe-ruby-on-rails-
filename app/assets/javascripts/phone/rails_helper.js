function handleRailsBeforeSend(e, anXHR, aSettingsObject)
{ 
  var theToken = $('meta[name="csrf-token"]').attr('content');
  anXHR.setRequestHeader('X-CSRF-Token', theToken);
  aSettingsObject.headers["X-CSRF-Token"] = theToken;
  
  return true;
}

$(function()
{
  $.rails.fileInputSelector = "input[type=file]";
  $(document).on("ajax:beforeSend.rails", "form", handleRailsBeforeSend);
})
