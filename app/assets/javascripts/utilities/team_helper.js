var TeamHelper = function(aParentSelector)
{
  this.myParentSelector = aParentSelector;
  
  this.connectToLeaguePicker = function()
  {
    $(this.myParentSelector).on("change", "#league_picker", createDelegate(this, this.onLeagueChanged));
  };
  
  this.onLeagueChanged = function(e)
  {
    var theLeagueId = e.target.value;
    $.getJSON( "/teams.json?league_id=" + theLeagueId, createDelegate(this, this.onTeamsReady) );
  };
  
  this.onTeamsReady = function(aResult)
  {
    var theTeamSelect = $(this.myParentSelector).find("#tailgate_team_id");
    theTeamSelect.empty();
    for(var i=0,j=aResult.length; i<j; i++)
    {
      theTeamSelect.append('<option value=' + aResult[i].id + '>' + aResult[i].name + '</option>');
    };
    
    theTeamSelect.change();
  };
  
}
