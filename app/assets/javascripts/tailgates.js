//= require_tree ./utilities

var myTeamHelper = new TeamHelper("#league_picker", "#tailgate_team_id");

$(function(){
  myTeamHelper.connectToLeaguePicker();
});