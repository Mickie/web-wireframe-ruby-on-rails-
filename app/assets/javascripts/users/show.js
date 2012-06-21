var myTeamHelper = new TeamHelper("#league_picker", "#user_team_team_id");


$(function(){
  myTeamHelper.connectToLeaguePicker();
  
  $("div#myTailgateList dl dd a").first().click();
})
