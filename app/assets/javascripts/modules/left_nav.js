var myTeamHelper = new TeamHelper("#league_picker", "#tailgate_team_id");


$(function(){
  myTeamHelper.connectToLeaguePicker();
  initializeFrameContent();
});

function initializeFrameContent()
{
  var theHash = window.location.hash;
  if(theHash.length > 0)
  {
    var theLeftNavElement = $(theHash + ' a');
    if (theLeftNavElement.length > 0)
    {
      theLeftNavElement.click();
      theLeftNavElement.addClass('active');
    }
    else
    {
      var theTailgateId = getIdFromHash(theHash);
      loadData("/tailgates/" + theTailgateId + "?noLayout=true", theHash);
    }
  }
  else
  {
    $('#allFanzones a').click();
    $('#allFanzones').addClass('active');
  }
}

function getIdFromHash( aHash )
{
  var thePieces = aHash.split("_");
  return thePieces[thePieces.length-1];
}

function onLoadDataComplete(aResult)
{
  $("#frameContent").html(aResult);
  window.scrollTo( 0, 1 );
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
  $.ajax({
           url: aPath,
           cache:false,
           dataType: "html",
           success: onLoadDataComplete,
           error: onLoadError
         });
}
