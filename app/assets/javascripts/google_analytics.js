var _gaq = _gaq || [];

$(function(){
  gapi.plusone.go();  
})

function trackEvent( aCategory, anAction, aLabel, aValue )
{
  _gaq.push(['_trackEvent', aCategory, anAction, aLabel, aValue]);
}
