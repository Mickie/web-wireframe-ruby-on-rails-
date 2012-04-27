$(function(){
  $("#sport_picker").change(function(e) {
    theSport = e.target.value;
    $.getJSON( "/teams.json?sport_id=" + theSport, onTeamsReady );
  });
})

function onTeamsReady(aResult)
{
  for(var i=0,j=aResult.length; i<j; i++)
  {
    $("#user_team_team_id").append('<option value=' + aResult[i].id + '>' + aResult[i].name + '</option>');
  };
}
