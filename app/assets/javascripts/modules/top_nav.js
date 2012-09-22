var myNavigator = new FanzoNavigator();

$(function(){
  myNavigator.initialize();
  $("#myFanzones .dropdown-toggle").dropdown();
});


function loadData(aPath, aNewActiveSelector)
{
  myNavigator.loadData( aPath, aNewActiveSelector );
  return false;
}
