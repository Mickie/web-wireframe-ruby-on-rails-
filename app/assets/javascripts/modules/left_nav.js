var myTeamHelper = new TeamHelper("#league_picker", "#tailgate_team_id");


$(function(){
  myTeamHelper.connectToLeaguePicker();
  initializeFrameContent();
  initializeNavigationWatchers();
});

function initializeFrameContent()
{
  var theHash = "";
  var theLocationCookie = getCookie("myCurrentLocationHash");
  if (theLocationCookie && theLocationCookie.length > 0)
  {
    theHash = theLocationCookie;
    setCookie("myCurrentLocationHash", "");
  }
  else
  {
    theHash = window.location.hash;
  }
  
  if(theHash.length > 0)
  {
    var theLeftNavElement = $("#fanzo_navigation " + theHash + ' a');
    if (theLeftNavElement.length > 0)
    {
      theLeftNavElement.click();
      theLeftNavElement.addClass('active');
    }
    else
    {
      var theTailgateId = getIdFromHash(theHash);
      if (theTailgateId)
      {
        loadData("/tailgates/" + theTailgateId + "?noLayout=true", theHash);
      }
      else
      {
        window.location.hash = "";
        navToAllFanzones();
      }
    }
  }
  else
  {
    navToAllFanzones();
  }
}

function navToAllFanzones()
{
  $('#allFanzones a').click();
  $('#allFanzones').addClass('active');
}

function getIdFromHash( aHash )
{
  var thePieces = aHash.split("_");
  if (thePieces[0] == "#nav")
  {
    return thePieces[thePieces.length-1];
  }
  
  return null;
}

function saveLocation()
{
  setCookie("myCurrentLocationHash", window.location.hash);
}

function clearLocation() 
{
  setCookie("myCurrentLocationHash", "");
}

function handleSearchSubmit()
{
  window.location.hash = "";
  InfiniteScroller.get().stop();
}

function handleSearchSelect()
{
  $('#fanzone_search form').submit();
}

function initializeNavigationWatchers()
{
  $('#myLoginModal').on('shown', saveLocation);
  $('#myLoginModal').on('hidden', clearLocation);  
  $('#myConnectTwitterModal').on('shown', saveLocation);
  $('#myConnectTwitterModal').on('hidden', clearLocation);
  $('#fanzone_search form').on('submit', handleSearchSubmit);
  $('#fanzone_search').on('railsAutocomplete.select', handleSearchSelect);
}

function onLoadDataComplete(aResult)
{
  $("#frameContent").html(aResult);
  window.scrollTo( 0, 1 );
  
  if ($(".active").attr("id") == "allFanzones")
  {
    InfiniteScroller.get().handleScrollingForResource("/tailgates");
    $("#fanzone_search").slideDown(400);
  }
  else
  {
    $("#fanzone_search").slideUp(400);
  }
  
}

function onLoadError(anError)
{
  console.log(anError);  
}

function addActiveToCurrentNavItem(aNewActiveSelector)
{
  $('.active').removeClass('active');
  $(aNewActiveSelector).addClass('active'); 
}

function loadData(aPath, aNewActiveSelector)
{
  if (aNewActiveSelector)
  {
    addActiveToCurrentNavItem(aNewActiveSelector);
    window.location.hash = aNewActiveSelector;
  }
  
  InfiniteScroller.get().stop();
  $("body").scrollTop(0);
  $("#frameContent").html("<div style='height:700px;'><h1 style='text-align:center'><img src='/assets/loading.gif' style='margin:20px'/>Loading</h1></div>");
  
  
  $.ajax({
           url: aPath,
           cache:false,
           dataType: "html",
           success: onLoadDataComplete,
           error: onLoadError
         });
}
