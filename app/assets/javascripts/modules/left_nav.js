var myNavigator = new FanzoNavigator();

$(function(){
  myNavigator.initialize();
});


function loadData(aPath, aNewActiveSelector)
{
  myNavigator.loadData( aPath, aNewActiveSelector );
}
