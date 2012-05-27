$(function(){
  $("#league_picker").change(function(e) 
  {
    theLeagueId = e.target.value;
    $.getJSON( "/teams.json?league_id=" + theLeagueId, onTeamsReady );
  });
  $("#event_id").change(function(e)
  {
    theGame = e.target.value;
    document.location = "/events/" + theGame;
  })
})

function onTeamsReady(aResult)
{
  $("#user_team_team_id").empty();
  for(var i=0,j=aResult.length; i<j; i++)
  {
    $("#user_team_team_id").append('<option value=' + aResult[i].id + '>' + aResult[i].name + '</option>');
  };
}
