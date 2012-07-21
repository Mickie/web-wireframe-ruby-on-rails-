$(function()
{
  if ( $("#flash_alerts").length > 0 )
  {
    $("#flash_alerts").slideDown(600);
    setTimeout("$('#flash_alerts').slideUp(600)", 3600);
  } 
})
