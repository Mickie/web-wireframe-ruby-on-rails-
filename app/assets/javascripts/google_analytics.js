var _gaq = _gaq || [];

$(function(){
  if (typeof gapi !== 'undefined' && gapi.plusone)
  {
    gapi.plusone.go();  
  }
})

function trackEvent( aCategory, anAction, aLabel, aValue )
{
  _gaq.push(['_trackEvent', aCategory, anAction, aLabel, aValue]);
}
