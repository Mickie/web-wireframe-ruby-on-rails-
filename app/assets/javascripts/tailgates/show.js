$(function()
{
  var theIdAttribute = $("#tailgate_show div.tailgate_content").attr("id");
  if (theIdAttribute && theIdAttribute.length > 0)
  {
    var theTailgateId = theIdAttribute.split('_')[1]
    $("#nav_" + theId).addClass('active');
  }
});