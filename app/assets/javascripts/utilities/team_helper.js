var TeamHelper = function(aLeagueSelectElementId, aTeamSelectElementId)
{
  this.myLeagueSelectElementId = aLeagueSelectElementId;
  this.myTeamSelectElementId = aTeamSelectElementId;
  
  this.connectToLeaguePicker = function()
  {
    $(this.myLeagueSelectElementId).change(createDelegate(this, this.onLeagueChanged));
  };
  
  this.onLeagueChanged = function(e)
  {
    theLeagueId = e.target.value;
    $.getJSON( "/teams.json?league_id=" + theLeagueId, createDelegate(this, this.onTeamsReady) );
  };
  
  this.onTeamsReady = function(aResult)
  {
    $(this.myTeamSelectElementId).empty();
    for(var i=0,j=aResult.length; i<j; i++)
    {
      $(this.myTeamSelectElementId).append('<option value=' + aResult[i].id + '>' + aResult[i].name + '</option>');
    };
    
    $(this.myTeamSelectElementId).change();
  };
  
}
