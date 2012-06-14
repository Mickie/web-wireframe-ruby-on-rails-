var myTeamHelper = new TeamHelper("#league_picker", "#user_team_team_id");

$(function(){
  myTeamHelper.connectToLeaguePicker();  
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

