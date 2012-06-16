var myTeamHelper = new TeamHelper("#league_picker", "#user_team_team_id");

function onLoadDataComplete(aResult)
{
  $("#frameContent").html(aResult);
}

function onLoadError(anError)
{
  console.log(anError);  
}

function loadData(aPath)
{
  $.ajax({
           url: aPath,
           cache:false,
           dataType: "html",
           success: onLoadDataComplete,
           error: onLoadError
         });
}

$(function(){
  myTeamHelper.connectToLeaguePicker();
  
  var theFirstFanzone = $("div#myTailgateList dl dd a")[0];
  if (theFirstFanzone)
  {
    window.location = theFirstFanzone.href;
  }
})
