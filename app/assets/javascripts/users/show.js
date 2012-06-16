var myTeamHelper = new TeamHelper("#league_picker", "#user_team_team_id");

$(function(){
  myTeamHelper.connectToLeaguePicker();
  
  $("div#myTailgateList dl dd a")[0].click();
})

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

