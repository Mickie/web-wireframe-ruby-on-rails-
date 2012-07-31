
$(function(){
  initializeFrameContent();
  initializeNavigationWatchers();

  var theCreateFanzoneDialog = new FanzoneDialog("#myCreateFanzoneModal", false);
  theCreateFanzoneDialog.initialize();
});

function isFacebookCallbackHash( aHash )
{
  return ( aHash == "_=_" );
}

function getLeftNavElement( aHash )
{
  return $("#fanzo_navigation " + aHash + " a");
}

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
    var theElement = [];

    if (isFacebookCallbackHash( theHash ))
    {
      window.location.hash = ""
      return;
    }
    else if ( (theElement = getLeftNavElement( theHash ) ) && theElement.length > 0)
    {
      theElement.click();
      theElement.addClass('active');
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
}

function navToAllFanzones()
{
  $('#allFanzones a').click();
  $('#allFanzones').addClass('active');
}

function getIdFromHash( aHash )
{
  var thePieces = aHash.split("_");
  if (thePieces[0] == "#nav" || thePieces[0] == "#tailgate")
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
  }
  cleanupTimestamps();
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
  $("#frameContent").html("<div style='height:700px;'><h1 style='text-align:center'><img src='/assets/loading.gif' style='margin:20px'/>Loading</h1></div>");
  $("body").scrollTop(0);
  
  var theToken = $('meta[name=csrf-token]').attr('content');
  $.ajax({
           url: aPath + "&authenticity_token=" + theToken,
           cache:false,
           dataType: "html",
           success: onLoadDataComplete,
           error: onLoadError
         });
}
